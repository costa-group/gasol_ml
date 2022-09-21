from datasets import *
from models import Model_1, Model_2, Model_3
from training_on_graphs import training as training_g
from training_on_graphs_regression import training as training_g_reg
from training_on_sequences import training as training_s
from training_on_sequences_regression import training as training_s_reg
import torch
from torch.utils.data import DataLoader


def test_0():
    dataset = GasolBasicBlocks(root='data', name='oms_gas', tag=0, graph_builder=GraphBuilder_1(features_gen=features_generator_2,class_gen=class_generator_1))
    model = Model_1(hidden_channels=64,in_channels=dataset.num_node_features, out_channels=dataset.num_classes)
    optimizer = torch.optim.Adam(model.parameters(), lr=0.01)
    criterion = torch.nn.CrossEntropyLoss()
  
    training_g(model,criterion,optimizer,dataset,balance_train_set=False,balance_test_set=False)

def test_1():
    dataset = GasolBasicBlocks(root='data', name='oms_gas', tag=1, graph_builder=GraphBuilder_2(class_gen=class_generator_4))
    model = Model_1(hidden_channels=64,in_channels=dataset.num_node_features, out_channels=dataset.num_classes)
    optimizer = torch.optim.Adam(model.parameters(), lr=1e-3)
    criterion = torch.nn.CrossEntropyLoss()
    
    training_g(model,criterion,optimizer,dataset,balance_train_set=True,balance_test_set=True)

def test_1_size():
    dataset = GasolBasicBlocks(root='data', name='oms_size', tag=1, graph_builder=GraphBuilder_2(class_gen=class_generator_4_size))
    model = Model_1(hidden_channels=64,in_channels=dataset.num_node_features, out_channels=dataset.num_classes)
    optimizer = torch.optim.Adam(model.parameters(), lr=1e-3)
    criterion = torch.nn.CrossEntropyLoss()
    
    training_g(model,criterion,optimizer,dataset,balance_train_set=True,balance_test_set=True)
    
def test_2():
    dataset = GasolBytecodeSeq(root='data', name='oms_gas', tag=2, sequence_builder=SequenceBuilder_1(class_gen=class_generator_4))
    model = Model_2(hidden_channels=64,vocab_size=dataset.vocab_size, out_channels=dataset.num_classes)
    optimizer = torch.optim.Adam(model.parameters(), lr=1e-3)
    criterion = torch.nn.CrossEntropyLoss()

    training_s(model,criterion,optimizer,dataset,balance_train_set=True,balance_test_set=True)

def test_3():
    dataset = GasolBytecodeSeq(root='data', name='oms_gas', tag=3, sequence_builder=SequenceBuilder_1(class_gen=class_generator_4))
    model = Model_3(hidden_channels=64,vocab_size=dataset.vocab_size, out_channels=dataset.num_classes, embed_dim=3)
    optimizer = torch.optim.Adam(model.parameters(), lr=1e-3)
    criterion = torch.nn.CrossEntropyLoss()

    training_s(model,criterion,optimizer,dataset,balance_train_set=True,balance_test_set=True)

# regression    
def test_4():
    dataset = GasolBasicBlocks(root='data', name='oms_gas', tag=4, graph_builder=GraphBuilder_1(features_gen=features_generator_1,class_gen=class_generator_11, regression=True))
    model = Model_1(hidden_channels=64,in_channels=dataset.num_node_features, out_channels=1)
    optimizer = torch.optim.SGD(model.parameters(), lr=1e-3)
    criterion = torch.nn.MSELoss(reduction='mean')
    
    training_g_reg(model,criterion,optimizer,dataset,balance_train_set=False,balance_test_set=False)

def test_5():
    dataset = GasolBasicBlocks(root='data', name='oms_gas', tag=5, graph_builder=GraphBuilder_2(class_gen=class_generator_11,regression=True))
    model = Model_1(hidden_channels=64,in_channels=dataset.num_node_features, out_channels=1)
    optimizer = torch.optim.SGD(model.parameters(), lr=1e-3)
    criterion = torch.nn.MSELoss(reduction='mean')
    
    training_g_reg(model,criterion,optimizer,dataset,balance_train_set=True,balance_test_set=True)
    
   
def test_6():
    dataset = GasolBytecodeSeq(root='data', name='oms_gas', tag=6, sequence_builder=SequenceBuilder_1(class_gen=class_generator_11, regression=True))
    model = Model_2(hidden_channels=64,vocab_size=dataset.vocab_size, out_channels=1)
    optimizer = torch.optim.SGD(model.parameters(), lr=1e-3)
    criterion = torch.nn.MSELoss(reduction='mean')

    training_s_reg(model,criterion,optimizer,dataset,balance_train_set=False,balance_test_set=False)

if __name__ == "__main__":
    torch.manual_seed(56783)
    test_1_size()
