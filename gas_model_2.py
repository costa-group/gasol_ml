from datasets import GasolBytecodeSeq, SequenceBuilder_1, class_generator_4
from models import Model_2
from training_on_sequences import training as training_s
import torch
import sys

def set_torch_rand_seed():
    torch.manual_seed(56783)

def model_path():
    return "saved_models/gas_model_2.pyt"

def train(epochs=171):
    dataset = GasolBytecodeSeq(root='data', name='oms_gas', tag='gas_model_2', sequence_builder=SequenceBuilder_1(class_gen=class_generator_4))
    model_args = {
        "hidden_channels": 64,
        "vocab_size": dataset.vocab_size,
        "out_channels": dataset.num_classes
    }
    model = Model_2(**model_args)
    optimizer = torch.optim.Adam(model.parameters(), lr=1e-3)
    criterion = torch.nn.CrossEntropyLoss()

    training_s(model,criterion,optimizer,dataset,balance_train_set=True,balance_test_set=True, epochs=epochs)
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
    # output: 0 if the block is classified as "gas will be saved", 1 or None othewise
    #
    def eval(self, bytecode: str): # as a string
        data = self.seq_builder.build_seq_for_evaluation(bytecode)["data"]
        if data is not None and len(data) > 0: # recall that edges list is transposed
            x = data.view(1,len(data))
            out = self.model(x, [len(data)])
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
    correct = wrong = 0
    model_args, model_state_dic = torch.load(model_path())
    model = Model_2(**model_args)
    model.load_state_dict(model_state_dic)
    model.eval()
    dataset = GasolBytecodeSeq(root='data', name='oms_gas', tag='gas_model_2', sequence_builder=SequenceBuilder_1(class_gen=class_generator_4))
    for data in dataset:

         seq_length = data[2]
         seq_tensor = data[0].view(1,len(data[0]))
         label = data[1]
         if len(seq_tensor) > 0: # recall that edges list is transposed
             out = model(seq_tensor, [seq_length])  # Perform a single forward pass.
             pred = out.argmax(dim=1)  # Use the class with highest probability.
             if pred.item() == label:
                 correct = correct + 1
             else:
                 wrong = wrong + 1
    total = correct+wrong
    print(f'total: {total} correct: {correct} ({correct/total*100.0:.2f}%)  wrong: {wrong} ({wrong/total*100.0:.2f}%)')

if __name__ == "__main__":
    set_torch_rand_seed()
    epochs = int(sys.argv[1]) if len(sys.argv)==2 else 2
    #train(epochs=epochs)
    #test_query()
    test_all()
