from datasets import GasolBasicBlocks, GraphBuilder_1, features_generator_1, features_generator_2
from models import Model_1
from training import training
from misc import print_dataset_stats
import torch

dataset = GasolBasicBlocks(root='data', name='oms_gas', tag=1, graph_builder=GraphBuilder_1(features_gen=features_generator_1))
model = Model_1(hidden_channels=128,num_node_features=dataset.num_node_features, num_classes=dataset.num_classes)
optimizer = torch.optim.Adam(model.parameters(), lr=0.01)
criterion = torch.nn.CrossEntropyLoss()


print_dataset_stats(dataset)
training(model,criterion,optimizer,dataset)
