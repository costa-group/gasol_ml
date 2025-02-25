from precision_eval import CriterionLoss, CorrectClass, TimeGain_vs_OptLoss, CountEpsError, SafeBound, PreciseBound, RegInfo, ROC
from training import training
from datasets_db import load_dataset, get_data_manipulators
from misc import calc_dist, import_string
import torch
import sys
import argparse
from pathlib import Path
import math





#
def calculate_class_weight(dataset):
    _, label_b, _ = get_data_manipulators(dataset)
    dist = calc_dist(dataset, get_class_f_for_balancing=label_b)
    dist = torch.tensor(dist,dtype=torch.float)
    dist = dist.sum()/dist
    weight = dist/dist.sum()

    return weight



def create_loss_function(dataset,args):

    tag = args.lossfunction
    
    if tag == 'mse':
        loss_f = torch.nn.MSELoss(reduction='mean')
    elif tag == 'l1':
        loss_f = torch.nn.L1Loss(reduction='mean')
    elif tag == 'cross_entropy':
        loss_f =torch.nn.CrossEntropyLoss()
    elif tag == 'cross_entropy_w':
        weight = calculate_class_weight(dataset)
        print(f'Cross entropy weights: {weight}')
        loss_f =torch.nn.CrossEntropyLoss(weight=weight)
    else:
        raise Exception(f'Invalid loss function: {tag}')

    return loss_f

def create_optimizer(model, args):
    tag = args.optimizer
    lr = args.learningrate
    
    if tag == 'adam':
        optimizer = torch.optim.Adam(model.parameters(), lr=lr)
    elif tag == 'sgd':
        optimizer = torch.optim.SGD(model.parameters(), lr=lr)
    else:
        raise Exception(f'Invalid optimizer: {tag}')

    return optimizer

def save_model(model,filename):
    torch.save( model, Path(__file__).parent.joinpath(Path(filename)).resolve() )





# regression with pyg graphs
#
def train(args):

    # for some reason multithreading slows down everything
    if args.numthreads is not None:
        torch.set_num_threads(args.numthreads)
        torch.set_num_interop_threads(args.numthreads)

    # data set and test set, they should be defined in dataset_db.py
    dataset_id=args.dataset
    testset_id=args.testset
    
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
    if args.loadmodel is not None:
        print(f'Loading model: {args.loadmodel}')
        model = torch.load(args.loadmodel)
        criterion = create_loss_function(dataset if dataset is not None else testset,args)
        optimizer = create_optimizer(model, args)
    else:
        print(f'Creating model: {args.model}')
        model_class = import_string(args.model)
        print(args)
        model = model_class(dataset,args)
        criterion = create_loss_function(dataset,args)
        optimizer = create_optimizer(model, args)

    print()
    print(f'Model: {model}')
    print()
    print(f'Loss function: {criterion}')
    print()
    print(f'Optimizer: {optimizer}')
    print()

    if args.learningtype == 'regression':
        if args.to_int == 'round':
            to_int = round
        elif args.to_int == 'ceil':
            to_int = math.ceil
        else:
            to_int = math.floor
        precision_evals = [CriterionLoss(),CountEpsError(eps=1),SafeBound(to_int=to_int), PreciseBound(to_int=to_int)]
    else:
        p = args.prop_threshold
        precision_evals = [CriterionLoss(),CorrectClass(p=p), TimeGain_vs_OptLoss(opt_key=args.opt_keyword,p=p),ROC(opt_key=args.opt_keyword)]

    label, label_b, batch_t = get_data_manipulators(dataset if dataset is not None else testset)

    training(model=model,
             criterion=criterion,
             optimizer=optimizer,
             dataset=dataset,
             testset=testset,
             get_label_f=label,
             get_class_f_for_balancing=label_b,
             batch_transformer=batch_t,
             balance_train_set=False,
             balance_validation_set=False,
             balance_testset=False,
             epochs=args.epochs,
             precision_evals=precision_evals,
             regression=args.learningtype == 'regression',
             save_models = args.savemodels,
             save_improved_only = args.saveimprovedonly,
             out_path = args.outputpath)

    # save the last model
    if dataset_id is not None and args.outfilename is not None:
        save_model(model,args.outfilename)

def main():
    cmd = ' '.join(sys.argv)
    print(f'Command line: {cmd}')
    print()
    
    parser = argparse.ArgumentParser()

    parser.add_argument('-e', '--epochs', type=int, default=1)
    parser.add_argument('-ds', '--dataset', type=int)
    parser.add_argument('-ts', '--testset', type=int)
    parser.add_argument('-of', '--outfilename', type=str) 
    parser.add_argument('-op', '--outputpath', type=str, default='/tmp')
    parser.add_argument('-sm', '--savemodels', type=str, choices=['all','last'], default=None)
    parser.add_argument('-sio', '--saveimprovedonly', action='store_true')
    
    parser.add_argument('-lm', '--loadmodel', type=str)
    parser.add_argument('-lr', '--learningrate', type=float, default=1e-3)
    parser.add_argument('-lf', '--lossfunction', type=str, choices=['mse','cross_entropy','cross_entropy_w'], default='mse')
    parser.add_argument('-opt', '--optimizer', type=str, default='adam')
    parser.add_argument('-hc', '--hiddenchannels', type=int, default=128)
    parser.add_argument('-lt', '--learningtype', type=str, default='regression')
    parser.add_argument('-m', '--model', type=str, default='nn_models.Model_1')
    parser.add_argument('-ed', '--embeddingdim', type=int, default=None)
    parser.add_argument('-to_int', '--to_int', type=str, choices=['round','ceil','floor'], default='round')
    parser.add_argument('-pt', '--prop_threshold', type=float, default=None)
    parser.add_argument('-dop', '--drop_out_p', type=float, default=0.5)
    parser.add_argument('-rnndop', '--rnn_drop_out_p', type=float, default=0)
    parser.add_argument('-rnn', '--rnn_class', type=str, choices=['lstm','gru'], default='lstm')
    parser.add_argument('-nt', '--numthreads', type=int, default=None)
    parser.add_argument('-opt_key', '--opt_keyword', type=str, choices=['saved_size','saved_gas'], default='saved_size')
    parser.add_argument('-nl', '--layers', type=int, default=1)


    args = parser.parse_args()

    train(args)
    
if __name__ == "__main__":
    torch.manual_seed(56783)
#    torch.manual_seed(12930873561324785612)
    main()
