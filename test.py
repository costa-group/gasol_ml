
from models import *
from precision_eval import CriterionLoss, CorrectClass, TimeGain_vs_OptLoss, CountEpsError, SafeBound, PreciseBound, TimeGain_vs_OptLossRand
from training import training
from datasets_db import load_dataset
from misc import calc_dist
import torch
import sys
import argparse
from pathlib import Path




# pyg graphs
#
def label_of_pyg_graph(d):
    return d[3]

def label_of_pyg_graph_for_balancing(d):
    return d[3].item()

def batch_transformer_for_pyg_graph(d):
     return 'pyg', { 'initial_n_instrs' : d.initial_n_instrs, 'sfs_size': d.sfs_size, 'size_saved' : d.size_saved }, d.x, d.y, d.edge_index, d.batch


# sequence of type 1
#
def label_of_sequence_1(d):
    return d[3] 

def label_of_sequence_1_for_balancing(d):
    return d[3]

def batch_transformer_for_sequence_1(d):
    seq_tensor = d[0]
    seq_labels = d[1]
    seq_lengths = d[2]
    seq_info = d[3]
    
    seq_lengths, perm_idx = seq_lengths.sort(0, descending=True)
    seq_tensor = seq_tensor[perm_idx]
    seq_labels = seq_labels[perm_idx]

    for key in seq_info:
        seq_info[key] = seq_info[key][perm_idx]
        
    return 'seq', seq_info, seq_tensor, seq_labels, seq_lengths


def train_g(epochs=10):
    dataset = load_dataset(1)
    n = int(len(dataset)*0.5)
    train_set= dataset[:n]
    testset = dataset[n:]


    model_args = {
        "hidden_channels": 64,
        "in_channels": dataset.num_node_features,
        "out_channels": dataset.num_classes
    }
    model = Model_1(**model_args)
    optimizer = torch.optim.Adam(model.parameters(), lr=1e-3)
    criterion = torch.nn.CrossEntropyLoss()
    training(model=model,
             criterion=criterion,
             optimizer=optimizer,
             dataset=train_set,
             testset=testset,
             get_label_f=label_of_pyg_graph,
             get_class_f_for_balancing=label_of_pyg_graph_for_balancing,
             balance_train_set=True,
             balance_validation_set=True,
             epochs=epochs,precision_evals=[CriterionLoss(),CorrectClass()])



### Classification on sequences
###
def train_s(epochs=10,
            dataset_id=None,
            testset_id=None,
            loss_f_tag=None,
            optimizer_tag=None,
            lr=1e-3,
            loadmodel=None,
            outfilename=None):

    # create the data set if needed
    if dataset_id is not None:
        dataset = load_dataset(dataset_id)
        dist = calc_dist(dataset, get_class_f_for_balancing=label_of_sequence_1_for_balancing)
        dist = torch.tensor(dist,dtype=torch.float)
        dist = dist.sum()/dist
        weight = dist/dist.sum()
    else:
        dataset = None
        weight = None
    # create the test set if needed
    if testset_id is not None:
        testset = load_dataset(testset_id)
    else:
        testset = None

    # Create or load the model
    #
    if loadmodel is not None:
        model_args, model_state_dic = torch.load(loadmodel)
    else:
        model_args = {
            "hidden_channels": 128,
            "vocab_size": dataset.vocab_size,
            "out_channels": dataset.num_classes
        }
        model_state_dic = None

    model = Model_3(**model_args)

    if model_state_dic is not None:
        model.load_state_dict(model_state_dic)

    
    criterion = create_loss_function(loss_f_tag,weight=weight)
    optimizer = create_optimizer(model, optimizer_tag, lr)

    print()
    print(f'Loss function: {criterion}')
    if weight is not None:
        print(f'Class weights: {weight}')
    print(f'Optimizer: {optimizer}')
    print()

    training(model=model,
             criterion=criterion,
             optimizer=optimizer,
             dataset=dataset,
             testset=testset,
             get_label_f=label_of_sequence_1,
             get_class_f_for_balancing=label_of_sequence_1_for_balancing,
             balance_train_set=False,
             balance_validation_set=False,
             balance_testset=False,
             epochs=epochs,
             precision_evals=[CriterionLoss(),CorrectClass(), TimeGain_vs_OptLoss()],
             batch_transformer=batch_transformer_for_sequence_1)

    # save the last model
    if dataset_id is not None and outfilename is not None:
        save_model(model,model_args,outfilename)

def train_s_reg(epochs=10):
    dataset = load_dataset(4)
    train_set=dataset
    testset = load_dataset(3)
    model_args = {
        "hidden_channels": 64,
        "vocab_size": dataset.vocab_size,
        "out_channels": 1
    }
    model = Model_2(**model_args)
    optimizer = torch.optim.SGD(model.parameters(), lr=1e-2)
    criterion = torch.nn.MSELoss(reduction='mean')
    
    training(model=model,
             criterion=criterion,
             optimizer=optimizer,
             dataset=dataset,
             testset=testset,
             get_label_f=label_of_sequence_1,
             get_class_f_for_balancing=label_of_sequence_1_for_balancing,
             batch_transformer=batch_transformer_for_sequence_1,
             balance_train_set=False,
             balance_validation_set=False,
             epochs=epochs,
             precision_evals=[CriterionLoss(),CountEpsError(eps=1),SafeBound(), PreciseBound()],
             regression=True)




# regression with pyg graphs
#
def train_g_reg(epochs=10,
                dataset_id=None,
                testset_id=None,
                loss_f_tag=None,
                optimizer_tag=None,
                lr=1e-3,
                loadmodel=None,
                outfilename=None):
    
    # create the data set if needed
    if dataset_id is not None:
        dataset = load_dataset(dataset_id)
    else:
        dataset = None

    # create the test set if needed
    if testset_id is not None:
        testset = load_dataset(testset_id)
    else:
        testset = None

    # Create or load the model
    #
    if loadmodel is not None:
        model_args, model_state_dic = torch.load(loadmodel)
    else:
        model_args = {
            "hidden_channels": 128,
            "in_channels": dataset.num_node_features,
            "out_channels": 1
        }
        model_state_dic = None

    model = Model_1(**model_args)

    if model_state_dic is not None:
        model.load_state_dict(model_state_dic)

    criterion = create_loss_function(loss_f_tag)
    optimizer = create_optimizer(model, optimizer_tag, lr)

    print()
    print(f'Loss function: {criterion}')
    print(f'Optimizer: {optimizer}')
    print()
    
    training(model=model,
             criterion=criterion,
             optimizer=optimizer,
             dataset=dataset,
             testset=testset,
             get_label_f=label_of_pyg_graph,
             get_class_f_for_balancing=label_of_pyg_graph_for_balancing,
             batch_transformer=batch_transformer_for_pyg_graph,
             balance_train_set=False,
             balance_validation_set=False,
             balance_testset=False,
             epochs=epochs,
             precision_evals=[CriterionLoss(),CountEpsError(eps=1),SafeBound(), PreciseBound()],
             regression=True)

    # save the last model
    if dataset_id is not None and outfilename is not None:
        save_model(model,model_args,outfilename)

def create_loss_function(tag,weight=None):
    if tag == 'mse':
        loss_f = torch.nn.MSELoss(reduction='mean')
    elif tag == 'l1':
        loss_f = torch.nn.L1Loss(reduction='mean')
    elif tag == 'ce':
        loss_f =torch.nn.CrossEntropyLoss(weight=weight)
        #criterion = torch.nn.CrossEntropyLoss(weight=torch.tensor([0.3,0.7]),reduction='mean')
    else:
        raise Exception(f'Invalid loss function: {tag}')

    return loss_f

def create_optimizer(model, tag, lr):
    if tag == 'adam':
        optimizer = torch.optim.Adam(model.parameters(), lr=lr)
    elif tag == 'sgd':
        optimizer = torch.optim.SGD(model.parameters(), lr=lr)
    else:
        raise Exception(f'Invalid optimizer: {tag}')

    return optimizer

def save_model(model,model_args,filename):
#    torch.save( (model_args,model.state_dict()), Path(__file__).parent.joinpath(Path(filename)).resolve() )
    torch.save( model, Path(__file__).parent.joinpath(Path(filename)).resolve() )

def main():
    cmd = ' '.join(sys.argv)
    print(f'Command line: {cmd}')
    print()
    
    parser = argparse.ArgumentParser()

    parser.add_argument('-e', '--epochs', type=int, default=1)
    parser.add_argument('-ds', '--dataset', type=int)
    parser.add_argument('-ts', '--testset', type=int)
    parser.add_argument('-of', '--outfilename', type=str)
    parser.add_argument('-lm', '--loadmodel', type=str)
    parser.add_argument('-lr', '--learningrate', type=float, default=1e-3)
    parser.add_argument('-lf', '--lossfunction', type=str, default='mse')
    parser.add_argument('-opt', '--optimizer', type=str, default='adam')
    parser.add_argument('-hc', '--hiddenchannels', type=int, default=128)

    parser.add_argument('-dt', '--datatype', type=str, default='pyg')
    parser.add_argument('-lt', '--learningtype', default='reg')

    args = parser.parse_args()

    if args.datatype == 'pyg':
        if args.learningtype == 'reg':
            train_g_reg(epochs=args.epochs,
                        dataset_id=args.dataset,
                        testset_id=args.testset,
                        loadmodel=args.loadmodel,
                        loss_f_tag=args.lossfunction,
                        optimizer_tag=args.optimizer,
                        lr=args.learningrate,
                        outfilename=args.outfilename)
        else:
            pass
        
    elif args.datatype == 'seq':
        if args.learningtype == 'reg':
            pass
        elif args.learningtype == 'cl':
            train_s(epochs=args.epochs,
                    dataset_id=args.dataset,
                    testset_id=args.testset,
                    loadmodel=args.loadmodel,
                    loss_f_tag=args.lossfunction,
                    optimizer_tag=args.optimizer,
                    lr=args.learningrate,
                    outfilename=args.outfilename)
    else:
        raise Exception('No supported yet')

        
if __name__ == "__main__":
    torch.manual_seed(56783)
    main()
