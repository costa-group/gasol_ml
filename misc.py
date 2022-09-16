import numpy as np

def print_dataset_stats_g(dataset):
    print()
    print(f'Dataset: {dataset}:')
    print('====================')
    print(f'Number of graphs: {len(dataset)}')
    print(f'Number of features: {dataset.num_features}')
    print(f'Number of classes: {dataset.num_classes}')
    print()
    print("Class distribution:")
    print('===================')
    
    all_labels = [d.y.tolist()[0] for d in dataset]    
    labels_unique, counts = np.unique(all_labels,return_counts=True)
    class_weights = { i : 0 for i in range(dataset.num_classes) }
    total = sum(counts)
    class_weights = { labels_unique[i] : f'{counts[i]/total:0.2f}% ' for i in range(len(counts)) }
    print(class_weights)
    print()


def print_dataset_stats_s(dataset):
    print()
    print(f'Dataset: {dataset}:')
    print('====================')
    print(f'Number of sequences: {len(dataset)}')
    print(f'Input sizes: {dataset.vocab_size}')
    print(f'Number of classes: {dataset.num_classes}')
    print()
    print("Class distribution:")
    print('===================')

    all_labels = [label for (data,label,length) in dataset]
    labels_unique, counts = np.unique(all_labels,return_counts=True)
    class_weights = { i : 0 for i in range(dataset.num_classes) }
    total = sum(counts)
    class_weights = { labels_unique[i] : f'{counts[i]/total:0.2f}% ' for i in range(len(counts)) }
    print(class_weights)
    print()

