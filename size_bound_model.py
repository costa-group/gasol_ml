from datasets import GasolBytecodeSeq, SequenceBuilder_1, class_generator_11
from models import Model_2
from training_on_sequences_regression import training as training_s_reg
import torch
import sys

def set_torch_rand_seed():
    torch.manual_seed(56783)

def model_path():
    return "saved_models/size_bound_model.pyt"

def train(epochs=171):
    dataset = GasolBytecodeSeq(root='data', name='oms_size', tag='size_bound_model', sequence_builder=SequenceBuilder_1(class_gen=class_generator_11, regression=True))
    model_args = {
        "hidden_channels": 64,
        "vocab_size": dataset.vocab_size,
        "out_channels": 1
    }
    model = Model_2(**model_args)
    optimizer = torch.optim.SGD(model.parameters(), lr=1e-2)
    criterion = torch.nn.MSELoss(reduction='mean')
    
    training_s_reg(model,criterion,optimizer,dataset,balance_train_set=False,balance_test_set=False, epochs=epochs)
    torch.save( (model_args,model.state_dict()), model_path())

class ModelQuery:
    def __init__(self):
        set_torch_rand_seed()
        model_args, model_state_dic = torch.load(model_path())
        self.model = Model_2(**model_args)
        self.model.load_state_dict(model_state_dic)
        self.model.eval()
        self.seq_builder = SequenceBuilder_1()

    # input: block as a string
    # output: a bound n (float) on the number of instruction of the optimized code, None if the input is not valid
    #
    def eval(self, bytecode: str): # as a string
        data = self.seq_builder.build_seq_for_evaluation(bytecode)["data"]
        if data is not None and len(data) > 0: # recall that edges list is transposed
            x = data.view(1,len(data))
            out = self.model(x, [len(data)])
            if out.item() > 0:
                return out.item()
        return None

def test_query():
    m = ModelQuery()
    bytecode = "PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP6 AND DUP2 MSTORE PUSH 1 PUSH 20 MSTORE DUP2 DUP2 KECCAK256 CALLER DUP3 MSTORE PUSH 20 MSTORE KECCAK256 SLOAD SWAP1 DUP3 DUP3 LT PUSH [tag] 94"
    c = m.eval(bytecode)
    print(f"bound: {c}") 

if __name__ == "__main__":
    set_torch_rand_seed()
    epochs = int(sys.argv[1]) if len(sys.argv)==2 else 2
    #train(epochs=epochs)
    test_query()
