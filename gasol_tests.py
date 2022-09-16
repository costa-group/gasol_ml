from datasets import *
from models import Model_1, Model_2
from training_on_graphs import training as training_g
from training_on_sequences import training as training_s
from misc import print_dataset_stats_g, print_dataset_stats_s
import torch
from torch.utils.data import DataLoader


def test_0():
    dataset = GasolBasicBlocks(root='data', name='oms_gas', tag=1, graph_builder=GraphBuilder_1(features_gen=features_generator_1,class_gen=class_generator_4))
    model = Model_1(hidden_channels=64,num_node_features=dataset.num_node_features, num_classes=dataset.num_classes)
    optimizer = torch.optim.Adam(model.parameters(), lr=0.01)
    criterion = torch.nn.CrossEntropyLoss()
    
    print_dataset_stats_g(dataset)
    training_g(model,criterion,optimizer,dataset,balance_train_set=True,balance_test_set=True)

def test_1():
    dataset = GasolBasicBlocks(root='data', name='oms_gas', tag=1, graph_builder=GraphBuilder_2(class_gen=class_generator_4))
    model = Model_1(hidden_channels=64,num_node_features=dataset.num_node_features, num_classes=dataset.num_classes)
    optimizer = torch.optim.Adam(model.parameters(), lr=0.01)
    criterion = torch.nn.CrossEntropyLoss()
    
    print_dataset_stats_g(dataset)
    training_g(model,criterion,optimizer,dataset,balance_train_set=True,balance_test_set=True)

def test_2():
    dataset = GasolBytecodeSeq(root='data', name='oms_gas', tag=2, sequence_builder=SequenceBuilder_1(class_gen=class_generator_4))
    model = Model_2(hidden_channels=4,input_size=dataset.input_size, num_classes=dataset.num_classes)
    optimizer = torch.optim.Adam(model.parameters(), lr=0.01)
    criterion = torch.nn.CrossEntropyLoss()

    print_dataset_stats_s(dataset)
    training_s(model,criterion,optimizer,dataset,balance_train_set=True,balance_test_set=True)

if __name__ == "__main__":
    torch.manual_seed(56783)
    test_1()
