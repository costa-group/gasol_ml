from torch.utils.data import DataLoader
import torch
from torch.utils.data import WeightedRandomSampler
from misc import print_dataset_stats_s

import numpy as np
import time

def train(model, criterion, optimizer, loader):
    model.train()

    # i=0
    for data in loader:  # Iterate in batches over the training dataset.

         seq_lengths = data[2]
         seq_tensor = data[0]
         labels = data[1]

         seq_lengths, perm_idx = seq_lengths.sort(0, descending=True)
         seq_tensor = seq_tensor[perm_idx]
         labels = labels[perm_idx]

         out = model(seq_tensor, seq_lengths)  # Perform a single forward pass.
         if out.isnan().sum() > 0:
             print("NaN", flush=True)
             exit(0)
         #out=torch.ceil(out)
         loss = criterion(out, labels)  # Compute the loss.
         loss.backward()  # Derive gradients.
         optimizer.step()  # Update parameters based on gradients.
         optimizer.zero_grad()  # Clear gradients.

def test(model,loader,criterion):
     model.eval()

     i=0;
     loss = 0
     for data in loader:  # Iterate in batches over the training/test dataset.
         seq_lengths = data[2]
         seq_tensor = data[0]
         labels = data[1]

         seq_lengths, perm_idx = seq_lengths.sort(0, descending=True)
         seq_tensor = seq_tensor[perm_idx]
         labels = labels[perm_idx]

         out = model(seq_tensor, seq_lengths)  # Perform a single forward pass.
         if out.isnan().sum() > 0:
             print("NaN", flush=True)
             exit(0)
         loss += criterion(out, labels).item()  # Compute the loss.
         i=i+1
     loss = loss/i
     return loss

    
# model is expected to receive an RNN as input    
def training(model, criterion, optimizer, dataset, epochs=171, balance_train_set=True, balance_test_set=True):

    print_dataset_stats_s(dataset,show_dist=False)

    dataset = dataset.shuffle()

    train_set_size = int(len(dataset)*0.8)
    train_set = dataset[:train_set_size]
    test_set = dataset[train_set_size:]


    train_loader = DataLoader(train_set, batch_size=4, shuffle=True)
    test_loader = DataLoader(test_set, batch_size=4, shuffle=False)

    for epoch in range(1, epochs):
        train(model,criterion,optimizer,train_loader)
        train_acc = test(model,train_loader,criterion)
        test_acc = test(model,test_loader,criterion)
        print(f'Epoch: {epoch:03d}, Train Acc: {train_acc:.4f}, Test Acc: {test_acc:.4f}', flush=True)

        
        
