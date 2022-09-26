from datasets import GasolBytecodeSeq, SequenceBuilder_1, class_generator_11
from models import Model_2
from training_on_sequences_regression import training as training_s_reg
import torch
import sys
import math
from pathlib import Path


def set_torch_rand_seed():
    torch.manual_seed(56783)

def model_path():
    return Path(__file__).parent.joinpath(Path('saved_models/gas_bound_model.pyt')).resolve()

def train(epochs=171):
    dataset = GasolBytecodeSeq(root='data', name='oms_gas', tag='gas_bound_model', sequence_builder=SequenceBuilder_1(class_gen=class_generator_11, regression=True))
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
    # output: a bound n (float) on the number of instruction of the optimized code, None if the input is not valid.
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

def test_all():
    lt = 0
    eq = 0
    gt = 0
    max_err = 0
    count = 0
    total_err = 0
    model_args, model_state_dic = torch.load(model_path())
    model = Model_2(**model_args)
    model.load_state_dict(model_state_dic)
    model.eval()
    dataset = GasolBytecodeSeq(root='data', name='oms_gas', tag='gas_bound_model', sequence_builder=SequenceBuilder_1(class_gen=class_generator_11, regression=True))
    for data in dataset:
         seq_length = data[2]
         seq_tensor = data[0].view(1,len(data[0]))
         actual = data[1].item()
         if len(seq_tensor) > 0: # recall that edges list is transposed
             out = model(seq_tensor, [seq_length])  # Perform a single forward pass.
             #pred = out.item()
             #pred = math.floor(out.item())
             pred = math.ceil(out.item())
             err = (pred-actual)**2
             total_err += err
             max_err = max(max_err, err)
             if pred < actual:
                 lt = lt+1
             elif pred > actual:
                 gt = gt + 1
             else:
                 eq = eq + 1
             count = count+1
    precision = total_err/count
    print(f'total_err: {total_err:.4f} count: {count}  precision: {total_err/count:.4f}  max_err: {max_err:.4f}   {lt},{eq},{gt}')

if __name__ == "__main__":
    set_torch_rand_seed()
    epochs = int(sys.argv[1]) if len(sys.argv)==2 else 2
    #train(epochs=epochs)
    #test_query()
    test_all()
