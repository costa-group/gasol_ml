import numpy as np
import torch_geometric
import torch

def calc_dist(dataset, get_class_f_for_balancing=None):
    def get_class(d):
        c = get_class_f_for_balancing(d)
        return c.item() if type(c) == torch.Tensor else c

    all_labels = [ get_class(d) for d in dataset]
    labels_unique, counts = np.unique(all_labels,return_counts=True)
    n = sum(counts)
    dist = [  counts[i]/n for i in range(len(labels_unique)) ]

    return dist


def print_dataset_stats(dataset, regression=False):
    if issubclass(type(dataset),torch_geometric.data.Dataset):
        print_dataset_stats_g(dataset,regression=regression)
    else:
        print_dataset_stats_s(dataset,regression=regression)

    
def print_dataset_stats_g(dataset,show_dist=True, regression=False):
    print()
    print(f'Dataset: {dataset}:')
    print('====================')
    print(f'Number of graphs: {len(dataset)}')
    print(f'Number of features: {dataset.num_features}')

    if show_dist and not regression:
        print("Class distribution:")
        print('===================')
        print(f'Number of classes: {dataset.num_classes}')
        print()
        
        all_labels = [d.y.tolist()[0] for d in dataset]    
        labels_unique, counts = np.unique(all_labels,return_counts=True)
        class_weights = { i : 0 for i in range(dataset.num_classes) }
        total = sum(counts)
        class_weights = { labels_unique[i] : f'{counts[i]} ({counts[i]/total*100:0.2f})% ' for i in range(len(counts)) }
        print(class_weights)
        print()


def print_dataset_stats_s(dataset,show_dist=True, regression=False):
    print()
    print(f'Dataset: {dataset}:')
    print('====================')
    print(f'Number of sequences: {len(dataset)}')
    print(f'Input sizes: {dataset.vocab_size}')

    if show_dist and not regression:
        print("Class distribution:")
        print('===================')
        print(f'Number of classes: {dataset.num_classes}')
        print()

        all_labels = [label for (data,label,length,_) in dataset]
        labels_unique, counts = np.unique(all_labels,return_counts=True)
        class_weights = { i : 0 for i in range(dataset.num_classes) }
        total = sum(counts)
        class_weights = { labels_unique[i] : f'{counts[i]} ({counts[i]/total*100:0.2f})% ' for i in range(len(counts)) }
        print(class_weights)
        print()

