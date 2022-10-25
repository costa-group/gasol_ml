
from models import *
from precision_eval import CriterionLoss, CorrectClass, TimeGain_vs_OptLoss, CountEpsError, SafeBound, PreciseBound, TimeGain_vs_OptLossRand
from training import training
from datasets_db import load_dataset
import torch
import sys



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
    test_set = dataset[n:]


    model_args = {
        "hidden_channels": 64,
        "in_channels": dataset.num_node_features,
        "out_channels": dataset.num_classes
    }
    model = Model_1(**model_args)
    optimizer = torch.optim.Adam(model.parameters(), lr=1e-3)
    criterion = torch.nn.CrossEntropyLoss()
    training(model,criterion,optimizer,train_set,test_set=test_set,get_label_f=label_of_pyg_graph,get_class_f_for_balancing=label_of_pyg_graph_for_balancing,balance_train_set=True,balance_validation_set=True, epochs=epochs,precision_evals=[CriterionLoss(),CorrectClass()])


def train_s(epochs=10):
    dataset = load_dataset(15)
    dataset = dataset.shuffle()

    n = int(len(dataset)*0.5)
    train_set= dataset[:n]
    test_set = dataset[n:]
    model_args = {
        "hidden_channels": 64,
        "vocab_size": dataset.vocab_size,
        "out_channels": dataset.num_classes
    }
    model = Model_2(**model_args)
    optimizer = torch.optim.Adam(model.parameters(), lr=1e-2)
    criterion = torch.nn.CrossEntropyLoss(weight=torch.tensor([0.2,0.8]),reduction='mean')
    #criterion = torch.nn.BCELoss(weight=torch.tensor([0.4,0.6]))
    #criterion = torch.nn.NLLLoss(weight=torch.tensor([0.4,0.6]))

    training(model,criterion,optimizer,train_set,test_set=test_set,get_label_f=label_of_sequence_1,get_class_f_for_balancing=label_of_sequence_1_for_balancing,balance_train_set=False,balance_validation_set=False,balance_test_set=True, epochs=epochs,precision_evals=[CriterionLoss(),CorrectClass(), TimeGain_vs_OptLoss(), TimeGain_vs_OptLossRand()],batch_transformer=batch_transformer_for_sequence_1)

# def train_s_reg(epochs=10):tr
#     dataset = load_dataset(15)
#     train_set=dataset
#     test_set = load_dataset(17)
#     model_args = {
#         "hidden_channels": 64,
#         "vocab_size": dataset.vocab_size,
#         "out_channels": 1
#     }
#     model = Model_2(**model_args)
#     optimizer = torch.optim.SGD(model.parameters(), lr=1e-2)
#     criterion = torch.nn.MSELoss(reduction='mean')
    
#     training(model,criterion,optimizer,dataset, test_set=test_set, regression=True, get_label_f=label_of_sequence_1,get_class_f_for_balancing=label_of_sequence_1_for_balancing,batch_transformer=batch_transformer_for_sequence_1,balance_train_set=False,balance_validation_set=False, epochs=epochs)

def train_g_reg(epochs=10):
    dataset = load_dataset(21)
    train_set = dataset
    test_set = load_dataset(23)
    model_args = {
        "hidden_channels": 64,
        "in_channels": dataset.num_node_features,
        "out_channels": 1
    }
    model = Model_1(**model_args)
    optimizer = torch.optim.Adam(model.parameters(), lr=1e-2)
   # optimizer = torch.optim.SGD(model.parameters(), lr=1e-3)
#    criterion = torch.nn.MSELoss(reduction='mean')
#    criterion = torch.nn.SmoothL1Loss(reduction='mean',beta=1)
    criterion = torch.nn.L1Loss(reduction='mean')
    
    training(model,criterion,optimizer,train_set,test_set=test_set,get_label_f=label_of_pyg_graph,get_class_f_for_balancing=label_of_pyg_graph_for_balancing,balance_train_set=True,balance_validation_set=True, epochs=epochs,precision_evals=[CriterionLoss(),CountEpsError(eps=1),SafeBound(), PreciseBound()],regression=True)


if __name__ == "__main__":
    set_torch_rand_seed()
    epochs = int(sys.argv[1]) if len(sys.argv)==2 else 2
#    train_g_reg(epochs=epochs)
    train_s(epochs=epochs)
