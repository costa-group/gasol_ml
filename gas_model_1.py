from datasets import GasolBasicBlocks, GraphBuilder_2, class_generator_4
from models import Model_1
from training_on_graphs import training as training_g
import torch
import sys

def set_torch_rand_seed():
    torch.manual_seed(56783)

def model_path():
    return "saved_models/gas_model_1.pyt"

def train(epochs=171):
    dataset = GasolBasicBlocks(root='data', name='oms_gas', tag='gas_model_1', graph_builder=GraphBuilder_2(class_gen=class_generator_4))
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
    # output: 0 if the block is classified as "gas will be saved", 1 or None othewise
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

def test_all():
    correct = wrong = wrong1 = wrong0 = 0
    model_args, model_state_dic = torch.load(model_path())
    model = Model_1(**model_args)
    model.load_state_dict(model_state_dic)
    model.eval()
    dataset = GasolBasicBlocks(root='data', name='oms_gas', tag='gas_model_1', graph_builder=GraphBuilder_2(class_gen=class_generator_4))
    for data in dataset:
        if data is not None and len(data.edge_index) == 2 and len(data.edge_index[0]) > 0: # recall that edges list is transposed
            out = model(data.x, data.edge_index, data.batch)  
            pred = out.argmax(dim=1)  # Use the class with highest probability.
            if pred.item() == data.y.item():
                correct = correct + 1
            elif data.y.item() == 0:
                wrong0 = wrong0 + 1
            else:
                wrong1 = wrong1 + 1
    wrong = wrong0+wrong1
    total = correct+wrong
    print(f'total: {total} correct: {correct} ({correct/total*100.0:.2f}%)  wrong: {wrong,wrong0,wrong1} ({wrong/total*100.0:.2f}%)')

if __name__ == "__main__":
    set_torch_rand_seed()
    epochs = int(sys.argv[1]) if len(sys.argv)==2 else 2
    #train(epochs=epochs)
    #test_query()
    test_all()
