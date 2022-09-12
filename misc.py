def print_dataset_stats(dataset):
    print()
    print(f'Dataset: {dataset}:')
    print('====================')
    print(f'Number of graphs: {len(dataset)}')
    print(f'Number of features: {dataset.num_features}')
    print(f'Number of classes: {dataset.num_classes}')
    print()
    print("Class distribution:")
    print('===================')
    
    x = [0]*dataset.num_classes
    t = 0
    for d in dataset:
        x[d.y] = x[d.y]+1
        t = t + 1
        
    for i in range(len(x)):
        z = (x[i]/t)*100
        print(f'{z:0.2f}% ',end='')

    print()
    print()

