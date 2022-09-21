from torch_geometric.loader import DataLoader
import torch
from torch.utils.data import WeightedRandomSampler
from misc import print_dataset_stats_g
import numpy as np

def train(model, criterion, optimizer, loader):
    model.train()

    for data in loader:  # Iterate in batches over the training dataset.
         out = model(data.x, data.edge_index, data.batch)  # Perform a single forward pass.
         loss = criterion(out, data.y)  # Compute the loss.
         loss.backward()  # Derive gradients.
         optimizer.step()  # Update parameters based on gradients.
         optimizer.zero_grad()  # Clear gradients.

def test(model,criterion,loader):
     model.eval()
     i=0;
     loss = 0
     for data in loader:  # Iterate in batches over the training/test dataset.
         out = model(data.x, data.edge_index, data.batch)
         loss += criterion(out, data.y).item()  # Compute the loss.
         i=i+1
     loss = loss/i
     return loss


# model is expected to receive a graph as input    
def training(model, criterion, optimizer, dataset, epochs=171, balance_train_set=True, balance_test_set=True):

    print_dataset_stats_g(dataset,show_dist=False)

    dataset = dataset.shuffle()

    train_set_size = int(len(dataset)*0.8)
    train_set = dataset[:train_set_size]
    test_set = dataset[train_set_size:]

    train_loader = DataLoader(train_set, batch_size=64, shuffle=True)    
    test_loader = DataLoader(test_set, batch_size=64, shuffle=True)

    for epoch in range(1, epochs):
        train(model,criterion,optimizer,train_loader)
        train_acc = test(model,criterion,train_loader)
        test_acc = test(model,criterion,test_loader)
        print(f'Epoch: {epoch:03d}, Train Acc: {train_acc:.4f}, Test Acc: {test_acc:.4f}')