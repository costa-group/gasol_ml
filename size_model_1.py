from datasets import GasolBasicBlocks, GraphBuilder_2, class_generator_4_size
from models import Model_1
from training_on_graphs import training as training_g
import torch
import sys

def set_torch_rand_seed():
    torch.manual_seed(56783)

def model_path():
    return "saved_models/size_model_1.pyt"

def train(epochs=171):
    dataset = GasolBasicBlocks(root='data', name='oms_size', tag='size_model_1', graph_builder=GraphBuilder_2(class_gen=class_generator_4_size))
    model_args = {
        "hidden_channels": 64,
        "in_channels": dataset.num_node_features,
        "out_channels": dataset.num_classes
    }
    model = Model_1(**model_args)
    optimizer = torch.optim.Adam(model.parameters(), lr=1e-3)
    criterion = torch.nn.CrossEntropyLoss()

    training_g(model,criterion,optimizer,dataset,balance_train_set=False,balance_test_set=False, epochs=epochs)
    torch.save( (model_args,model.state_dict()), model_path())

class ModelQuery:
    def __init__(self):
        set_torch_rand_seed()
        model_args, model_state_dic = torch.load(model_path())
        self.model = Model_1(**model_args)
        self.model.load_state_dict(model_state_dic)
        self.model.eval()
        self.graph_builder = GraphBuilder_2()


    # input: block as a string
    # output: 0 if the block is classified as "size will be saved", 1 or None othewise
    #
    def eval(self, bytecode: str): # as a string
        data = self.graph_builder.build_graph_for_evaluation(bytecode)
        if data is not None and len(data.edge_index) == 2 and len(data.edge_index[0]) > 0: # recall that edges list is transposed
            out = self.model(data.x, data.edge_index, data.batch)  
            pred = out.argmax(dim=1)  # Use the class with highest probability.
            return pred.item()
        else:
            return None

def test_query():
    m = ModelQuery()
    bytecode = "PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP6 AND DUP2 MSTORE PUSH 1 PUSH 20 MSTORE DUP2 DUP2 KECCAK256 CALLER DUP3 MSTORE PUSH 20 MSTORE KECCAK256 SLOAD SWAP1 DUP3 DUP3 LT PUSH [tag] 94"
    c = m.eval(bytecode)
    print(f"classified as: {c}") 

if __name__ == "__main__":
    set_torch_rand_seed()
    epochs = int(sys.argv[1]) if len(sys.argv)==2 else 2
    sys.stdout=sys.stderr=open(f'{model_path()}.log', 'w')
    train(epochs=epochs)
    test_query()
