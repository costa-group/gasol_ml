import torch
import numpy as np
from torch_geometric.loader import DataLoader
from torch.utils.data import WeightedRandomSampler
from misc import print_dataset_stats
from precision_eval import CriterionLoss, CorrectClass
from precision_cmp import train_first_elem_cmp, val_first_elem_cmp


    
# Training a model on a given data, it returns the accumulated loss
#
def train(model, criterion, optimizer, loader, get_label_f=None, batch_transformer=lambda d : d):
    model.train()
    for data in loader:
        data = batch_transformer(data)  # trasfom the batch if needed
        out = model(data) 
        labels = get_label_f(data) # get the label (class for classification and value for regression)
        loss = criterion(out, labels)
        loss.backward()
        optimizer.step()
        optimizer.zero_grad()


# Test a model on a given data. 
#
def test_c(model,criterion,loader,get_label_f=None, batch_transformer=lambda d : d, precision_evals=[]):
    model.eval()

    with torch.no_grad():

        # reset all precision evaluators
        for peval in precision_evals:
            peval.reset()

        for data in loader:       
            data = batch_transformer(data) # trasfrom the batch if needed
            out = model(data) # apply model
            labels = get_label_f(data) # get labels from data
            
            # evaluate all precision criteria
            for peval in precision_evals:
                peval.eval(out,labels,data,criterion)
                
    return [ (peval.tag(), peval.loss(), peval.report())  for peval in precision_evals ]


# creates a loader, and balance the set (only in case of classification for now) if needed
#
#  TBD: we always use the DataLoader of pyg, seems to works with datasets of torch, but should check it out.
#
def create_loader(dataset, name="dataset", get_class_f_for_balancing=None, balance = False, regression = False, batch_size=64):
    def get_class(d):
        c = get_class_f_for_balancing(d)
        return c.item() if type(c) == torch.Tensor else c

    if not regression and balance:
        print(f"Balancing the {name} ...", flush=True)
        all_labels = [ get_class(d) for d in dataset]
        labels_unique, counts = np.unique(all_labels,return_counts=True)
        class_weights = { labels_unique[i] : sum(counts)/counts[i] if counts[i] else 0 for i in range(len(counts)) }
        data_weights = [ class_weights[get_class(d)] for d in dataset ] # weight for every example in train_set
        sampler= WeightedRandomSampler(data_weights, len(data_weights))
        loader = DataLoader(dataset, batch_size=batch_size, sampler=sampler)
    else:
        loader = DataLoader(dataset, batch_size=batch_size, shuffle=True)

    return loader


# The main training loop
#
def training(model = None, # a model that is suitable for the dataset provided, its forward receives 1 argument (the batch) and is supposed to get a batch and do all work
             criterion = None, # loss function
             optimizer = None, # an optimizer
             dataset = None, # the data set (suitable for the model)
             epochs=10, # number of epochs
             train_set_size_percentage=0.8, # how to split the set into training and validation
             regression=False, # if it is a regression or a classification problem (eventually will be eliminated)
             testset=None, # an optional test set, that is supposed to be independent from dataset
             get_label_f=None, # a function to extract the labels from a batch (just to support several kinds of datasets)
             balance_train_set=True, # if the train set should be balanced when creating a loader (for classification for now)
             balance_validation_set=True, # same as above but for the validation set
             balance_testset=True, # same as above but for the test set
             get_class_f_for_balancing = lambda d : get_label_f(d).item(), # a function that returns the label for the purpose of balancing
             batch_size = 64, # the size of each batch created by the loader
             batch_transformer=lambda d : d, # in case batches needed to be transformed a bit before sending to the model
             precision_evals=[CriterionLoss()], # a list of precision evaluators (see the module precision_eval)
             prec_cmp=train_first_elem_cmp, # a comparator of precision for each batch (see the module precision_cmp)
             model_path = None): # where to save the optimal model

    # if there is a data set, then we are doing training 
    if dataset is not None:
        print()
        print(f'** The training set ({train_set_size_percentage*100:.2f}% for training and {(1-train_set_size_percentage)*100:.2f}% for validation)')
        print_dataset_stats(dataset, regression=regression)

        # split the dataset into training and validation
        #
        dataset = dataset.shuffle()
        train_set_size = int(len(dataset)*train_set_size_percentage)
        train_set = dataset[:train_set_size]
        validation_set = dataset[train_set_size:]

        # Create the loaders. In case of classification we might be balancing
        train_loader = create_loader(train_set, name="training set", regression=regression, balance=balance_train_set, get_class_f_for_balancing=get_class_f_for_balancing, batch_size=batch_size)
        val_loader = create_loader(validation_set, name="validation set", regression=regression, balance=balance_validation_set, get_class_f_for_balancing=get_class_f_for_balancing, batch_size=batch_size)

        # best epoch information
        best_epoch = None
        best_epoch_train_loss = [ float('inf') ] * len(precision_evals)
        best_epoch_val_loss = [ float('inf') ] * len(precision_evals)
    else:
        epochs = 1 # otherwise we are just testing, so we fix the epochs to 1

        
    # create the loader of the testset if provided
    if testset is not None:
        print()
        print(f'** The test set')
        print_dataset_stats(testset, regression=regression)
        test_loader = create_loader(testset, name="test set", regression=regression, balance=balance_testset, get_class_f_for_balancing=get_class_f_for_balancing, batch_size=batch_size)


    print()
    for epoch in range(1, epochs+1):
        print(f'Epoch {epoch:03d}', end="", flush=True)

        # calculate precicion on train/val sets
        #
        if dataset is not None:

            # train
            #
            train(model,criterion,optimizer,train_loader,get_label_f=get_label_f,batch_transformer=batch_transformer)
            
            train_precision = test_c(model,criterion,train_loader,get_label_f=get_label_f,batch_transformer=batch_transformer, precision_evals=precision_evals)
            val_precision = test_c(model,criterion,val_loader,get_label_f=get_label_f,batch_transformer=batch_transformer, precision_evals=precision_evals)

            # check if there is an improvement wrt. the best epoch
            curr_train_loss = [ loss for (_,loss,_) in train_precision]
            curr_val_loss = [ loss for (_,loss,_) in val_precision]
            improved=False
            if prec_cmp(curr_train_loss,curr_val_loss,best_epoch_train_loss,best_epoch_val_loss):
                best_epoch_train_loss = curr_train_loss
                best_epoch_val_loss = curr_val_loss
                best_epoch = epoch
                improved=True
                if model_path is not None: 
                    torch.save(model.state_dict(), model_path)

            mark = '*' if improved else ''
            print(f'{mark} \t ')
            print(f'\tTrain: ', end="")
            for (tag,loss,prec_info) in train_precision:
                print(f'{tag}={loss:.4f} ({prec_info})', end="")
                print("\t", end="")
            print()
            print(f'\tVal: ', end="")
            for (tag,loss,prec_info) in val_precision:
                print(f'{tag}={loss:.4f} ({prec_info})', end="")
                print("\t", end="")
            print(flush=True)

        if testset is not None:
            test_precision = test_c(model,criterion,test_loader,get_label_f=get_label_f,batch_transformer=batch_transformer, precision_evals=precision_evals)

            print(f'\tTest: ', end="")
            for (tag,loss,prec_info) in test_precision:
                print(f'{tag}={loss:.4f} ({prec_info})', end="")
                print("\t", end="")

            print(flush=True)

