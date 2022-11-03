from bytecode_sequence import BytecodeSequence  
from fixed_models import Model_opt_classifier_size_03112022_1230_samirpc as Model

from pathlib import Path
import torch
import json
import argparse



class ModelQuery:
    def __init__(self,model_filename):
        torch.set_num_threads(1)
        model_args, model_state_dic = torch.load(Path(__file__).parent.joinpath(Path(model_filename)).resolve())
        self.model = Model(**model_args)
        self.model.load_state_dict(model_state_dic)
        self.model.eval()
        self.sequence_builder = BytecodeSequence(encoding='multi_push')

    def eval(self, bytecode):

        with torch.no_grad():

            # convert the sequence into sequence of ids    
            bytecode_ids_sequence = self.sequence_builder.build_seq_from_bytecode(bytecode)
        
            data = torch.tensor([bytecode_ids_sequence]), [], torch.tensor([len(bytecode_ids_sequence)])  # [] is not used, it is supposed to be the labels of the batch

            pred = self.model(data).argmax(dim=1).item()

            return pred

def example(model_filename):
    bc=  "PUSH 2 SSTORE PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP3 AND PUSH 0 SWAP1 DUP2 MSTORE PUSH 20 DUP2 DUP2 MSTORE PUSH 40 SWAP1 SWAP2 KECCAK256 SLOAD PUSH [tag] 80 SWAP2 DUP4 SWAP1 PUSH [tag] 18446744073709551971 PUSH [tag] 79 DUP3 SHL OR SWAP1 SHR"
    
    query = ModelQuery(model_filename)
    c = query.eval(bc)
    print(f'Class: {c}')


# Usage example:
#
#   python3 bound_predictor.py -m saved_models/bound_predictor_size_01112022_0645_costa2.pyt
#
if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument('-m', '--model', type=str, required=True)
    args = parser.parse_args()

    example(args.model)
