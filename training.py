from torch_geometric.loader import DataLoader
import torch

def train(model, criterion, optimizer, loader):
    model.train()

    for data in loader:  # Iterate in batches over the training dataset.
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



def training(model, criterion, optimizer, dataset, epochs=171):

    torch.manual_seed(12345)
    dataset = dataset.shuffle()
    train_set_size = int(len(dataset)/2)
    train_loader = DataLoader(dataset[:train_set_size], batch_size=64, shuffle=True)
    test_loader = DataLoader(dataset[train_set_size:], batch_size=64, shuffle=False)

    for epoch in range(1, epochs):
        train(model,criterion,optimizer,train_loader)
        train_acc = test(model,train_loader)
        test_acc = test(model,test_loader)
        print(f'Epoch: {epoch:03d}, Train Acc: {train_acc:.4f}, Test Acc: {test_acc:.4f}')
