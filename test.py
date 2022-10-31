
from models import *
from precision_eval import CriterionLoss, CorrectClass, TimeGain_vs_OptLoss, CountEpsError, SafeBound, PreciseBound, TimeGain_vs_OptLossRand
from training import training
from datasets_db import load_dataset
import torch
import sys
import argparse
from pathlib import Path



# pyg graphs
def label_of_pyg_graph(d):
    return d.y

def label_of_pyg_graph_for_balancing(d):
    return d.y.item()


# sequence_1
def label_of_sequence_1(d):
    # l = []
    # for i in d[2]:
    #     if i.item() == 1:
    #         l.append([0.0,1.0])
    #     else:
    #         l.append([1.0,0.0])

    return d[2] #torch.tensor(l).to(torch.float) #d[2]

def label_of_sequence_1_for_balancing(d):
    return d[2]

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
        
    return (seq_tensor, seq_lengths, seq_labels, seq_info)


def set_torch_rand_seed():
    torch.manual_seed(56783)

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


def train_s(epochs=10):
    dataset = load_dataset(2)

    # dataset = dataset.shuffle()
    # n = int(len(dataset)*0.5)
    # train_set= dataset[:n]
    # testset = dataset[n:]

    train_set= dataset
    testset = load_dataset(0)

    
    model_args = {
        "hidden_channels": 64,
        "vocab_size": dataset.vocab_size,
        "out_channels": dataset.num_classes
    }
    model = Model_2(**model_args)
    optimizer = torch.optim.Adam(model.parameters(), lr=1e-3)
    criterion = torch.nn.CrossEntropyLoss(weight=torch.tensor([0.3,0.7]),reduction='mean')
    #criterion = torch.nn.BCELoss(weight=torch.tensor([0.4,0.6]))
    #criterion = torch.nn.NLLLoss(weight=torch.tensor([0.4,0.6]))

    training(model=model,
             criterion=criterion,
             optimizer=optimizer,
             dataset=train_set,
             testset=testset,
             get_label_f=label_of_sequence_1,
             get_class_f_for_balancing=label_of_sequence_1_for_balancing,
             balance_train_set=False,
             balance_validation_set=False,
             balance_testset=False,
             epochs=epochs,
             precision_evals=[CriterionLoss(),CorrectClass(), TimeGain_vs_OptLoss()],
             batch_transformer=batch_transformer_for_sequence_1)

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

def train_g_reg(epochs=10, dataset_id=None, testset_id=None, loadmodel=None, outfilename=None):
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
    
    # optimizer
    #
    optimizer = torch.optim.Adam(model.parameters(), lr=1e-3)
    #optimizer = torch.optim.SGD(model.parameters(), lr=1e-2)

    #loss function
    #
    #criterion = torch.nn.MSELoss(reduction='mean')
    #criterion = torch.nn.SmoothL1Loss(reduction='mean',beta=1)
    criterion = torch.nn.L1Loss(reduction='mean')
    
    training(model=model,
             criterion=criterion,
             optimizer=optimizer,
             dataset=dataset,
             testset=testset,
             get_label_f=label_of_pyg_graph,
             get_class_f_for_balancing=label_of_pyg_graph_for_balancing,
             balance_train_set=True,
             balance_validation_set=True,
             epochs=epochs,
             precision_evals=[CriterionLoss(),CountEpsError(eps=1),SafeBound(), PreciseBound()],
             regression=True)

    # save the last model
    if dataset_id is not None and outfilename is not None:
        save_model(model,model_args,outfilename)


def save_model(model,model_args,filename):
    torch.save( (model_args,model.state_dict()), Path(__file__).parent.joinpath(Path(filename)).resolve() )

def main():
    parser = argparse.ArgumentParser()

    parser.add_argument('-e', '--epochs', type=int)
    parser.add_argument('-ds', '--dataset', type=int)
    parser.add_argument('-ts', '--testset', type=int)
    parser.add_argument('-of', '--outfilename', type=str)
    parser.add_argument('-lm', '--loadmodel', type=str)
    args = parser.parse_args()

    train_g_reg(epochs=args.epochs,dataset_id=args.dataset,testset_id=args.testset,loadmodel=args.loadmodel,outfilename=args.outfilename)

        
if __name__ == "__main__":
    set_torch_rand_seed()
    main()
    #epochs = int(sys.argv[1]) if len(sys.argv)==2 else 2
    #train_s_reg(epochs=epochs)
    #train_g_reg(epochs=epochs,)
#    train_s(epochs=epochs)
