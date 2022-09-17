from datasets import GasolBasicBlocks, GraphBuilder_2, class_generator_5
from models import Model_1
from training_on_graphs import training as training_g
from misc import print_dataset_stats_g
from torch.utils.data import DataLoader
import torch
import csv
import json

def set_torch_rand_seed():
    torch.manual_seed(56783)

def model_path():
    return "model_gas.pyt"

def train(epochs=171):
    dataset = GasolBasicBlocks(root='data', name='oms_gas', tag=2, graph_builder=GraphBuilder_2(class_gen=class_generator_5))
    model = Model_1(hidden_channels=64,num_node_features=dataset.num_node_features, num_classes=dataset.num_classes)
    optimizer = torch.optim.Adam(model.parameters(), lr=0.01)
    criterion = torch.nn.CrossEntropyLoss()

    print_dataset_stats_g(dataset)
    training_g(model,criterion,optimizer,dataset,balance_train_set=True,balance_test_set=True, epochs=epochs)
    torch.save(model.state_dict(), model_path())

    
def select_sample(block_info, block_sfs, data):
    return data is not None and len(data.edge_index) == 2 and len(data.edge_index[0]) > 0 # recall that edges list is transposed

class ModelQuery:
    def __init__(self):
        set_torch_rand_seed()
        self.model = Model_1(hidden_channels=64,num_node_features=137, num_classes=2)
        self.model.load_state_dict(torch.load(model_path()))
        self.model.eval()
        self.graph_builder = GraphBuilder_2(class_gen=class_generator_5)

    def eval(self, block_info, block_sfs):
        data = self.graph_builder.build_graph(block_info,block_sfs)
        if select_sample(block_info, block_sfs, data):
            out = self.model(data.x, data.edge_index, data.batch)  
            pred = out.argmax(dim=1)  # Use the class with highest probability.
            return pred[0].item()
        else:
            return None

def test_query():
    m = ModelQuery()

    with open("data/oms_gas/raw/csv/0x08B02C0B0D5Bc97ceae343c88A90342b5e4d3C0C.csv", newline='') as csvfile:
        csv_reader = csv.DictReader(csvfile)
        block_info = next(csv_reader)
        block_id = block_info['block_id']
        with open(f'data/oms_gas/raw/jsons/0x08B02C0B0D5Bc97ceae343c88A90342b5e4d3C0C/{block_id}_input.json', 'r') as f:
            block_sfs = json.load(f)
            return m.eval(block_info,block_sfs)

if __name__ == "__main__":
    set_torch_rand_seed()
    train(epochs=2) # 2 just to save time, should be changed to the epoch we want
    #test_query()
