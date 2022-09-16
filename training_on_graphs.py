from torch_geometric.loader import DataLoader
import torch
from torch.utils.data import WeightedRandomSampler

import numpy as np

def train(model, criterion, optimizer, loader):
    model.train()

    for data in loader:  # Iterate in batches over the training dataset.
         # all_labels = data.y.tolist()
         # labels_unique, counts = np.unique(all_labels,return_counts=True)
         # print(counts)
         out = model(data.x, data.edge_index, data.batch)  # Perform a single forward pass.
         loss = criterion(out, data.y)  # Compute the loss.
         loss.backward()  # Derive gradients.
         optimizer.step()  # Update parameters based on gradients.
         optimizer.zero_grad()  # Clear gradients.

def test(model,loader):
     model.eval()

     correct = 0
     safe = 0
     for data in loader:  # Iterate in batches over the training/test dataset.
         out = model(data.x, data.edge_index, data.batch)  
         pred = out.argmax(dim=1)  # Use the class with highest probability.
         correct += int((pred == data.y).sum())  # Check against ground-truth labels.
     return correct / len(loader.dataset) # Derive ratio of correct predictions.


def f(a,c):
    if c==0:
        return 0
    else:
        return a/c

# model is expected to receive a graph as input    
def training(model, criterion, optimizer, dataset, epochs=171, balance_train_set=True, balance_test_set=True):

    dataset = dataset.shuffle()

    train_set_size = int(len(dataset)*0.8)
    train_set = dataset[:train_set_size]
    test_set = dataset[train_set_size:]

    if balance_train_set:
        print("Balancing train set ...")
        all_labels = [ d.y.tolist()[0] for d in train_set]
        labels_unique, counts = np.unique(all_labels,return_counts=True)
        class_weights = { labels_unique[i] : f(sum(counts),counts[i]) for i in range(len(counts)) }
        example_weights = [ class_weights[d.y.tolist()[0]] for d in train_set ]
        sampler= WeightedRandomSampler(example_weights, len(example_weights))
        train_loader = DataLoader(train_set, batch_size=64, sampler=sampler)
    else:
        train_loader = DataLoader(train_set, batch_size=64, shuffle=True)
        
    if balance_test_set:
        print("Balancing test set ...")
        all_labels = [ d.y.tolist()[0] for d in test_set]
        labels_unique, counts = np.unique(all_labels,return_counts=True)
        class_weights = { labels_unique[i] : f(sum(counts),counts[i]) for i in range(len(counts)) }
        example_weights = [ class_weights[d.y.tolist()[0]] for d in test_set ]
        sampler= WeightedRandomSampler(example_weights, len(example_weights))
        test_loader = DataLoader(test_set, batch_size=64, sampler=sampler)
    else:
        test_loader = DataLoader(test_set, batch_size=64, shuffle=True)

    for epoch in range(1, epochs):
        train(model,criterion,optimizer,train_loader)
        train_acc = test(model,train_loader)
        test_acc = test(model,test_loader)
        print(f'Epoch: {epoch:03d}, Train Acc: {train_acc:.4f}, Test Acc: {test_acc:.4f}')
