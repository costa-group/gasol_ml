from sfs_graph import SFSGraph
from models import Model_1

from pathlib import Path
import torch
import json
import argparse

class Data():
    pass


class ModelQuery:
    def __init__(self,model_filename):
        model_args, model_state_dic = torch.load(Path(__file__).parent.joinpath(Path(model_filename)).resolve())
        self.model = Model_1(**model_args)
        self.model.load_state_dict(model_state_dic)
        self.model.eval()
        self.sfs_builder = SFSGraph(node_features='multi_push',regression=True)

    def eval(self, block_sfs):
        with torch.no_grad():

            x, edge_index = self.sfs_builder.build_graph_from_sfs(block_sfs)

            data = Data()
            data.x = x
            data.edge_index = edge_index
            data.batch = torch.zeros(len(x),dtype=torch.int64) # we have only one batch
            
            out = self.model(data)
            
            bound = round(out.item()) + len(block_sfs["user_instrs"])
            
            return bound

def example(model_filename):
    input_json = '{"init_progr_len": 33, "max_progr_len": 33, "max_sk_sz": 14, "vars": ["s(0)", "s(1)", "s(10)", "s(11)", "s(12)", "s(13)", "s(14)", "s(15)", "s(16)", "s(2)", "s(6)", "s(7)", "s(8)", "s(9)", "s(18)", "s(19)", "s(20)", "s(21)", "s(22)", "s(23)"], "src_ws": ["s(0)", "s(1)", "s(2)"], "tgt_ws": ["s(6)", "s(1)", "s(12)", "s(13)", "s(1)", "s(2)"], "user_instrs": [{"id": "PUSH [tag]_0", "opcode": "00", "disasm": "PUSH [tag]", "inpt_sk": [], "outpt_sk": ["s(10)"], "gas": 3, "commutative": false, "storage": false, "value": [114598615266301018708337], "size": 5}, {"id": "KECCAK256_0", "opcode": "20", "disasm": "KECCAK256", "inpt_sk": ["s(18)", "s(19)"], "outpt_sk": ["s(11)"], "gas": 30, "commutative": false, "storage": false, "size": 1}, {"id": "SLOAD_0", "opcode": "54", "disasm": "SLOAD", "inpt_sk": ["s(11)"], "outpt_sk": ["s(12)"], "gas": 700, "commutative": false, "storage": false, "size": 1}, {"id": "PUSH [tag]_1", "opcode": "00", "disasm": "PUSH [tag]", "inpt_sk": [], "outpt_sk": ["s(13)"], "gas": 3, "commutative": false, "storage": false, "value": [128], "size": 5}, {"id": "AND_0", "opcode": "16", "disasm": "AND", "inpt_sk": ["s(2)", "s(15)"], "outpt_sk": ["s(14)"], "gas": 3, "commutative": true, "storage": false, "size": 1}, {"id": "SUB_0", "opcode": "03", "disasm": "SUB", "inpt_sk": ["s(16)", "s(20)"], "outpt_sk": ["s(15)"], "gas": 3, "commutative": false, "storage": false, "size": 1}, {"id": "SHL_0", "opcode": "1b", "disasm": "SHL", "inpt_sk": ["s(21)", "s(20)"], "outpt_sk": ["s(16)"], "gas": 3, "commutative": false, "storage": false, "size": 1}, {"id": "SHR_0", "opcode": "1c", "disasm": "SHR", "inpt_sk": ["s(22)", "s(7)"], "outpt_sk": ["s(6)"], "gas": 3, "commutative": false, "storage": false, "size": 1}, {"id": "OR_0", "opcode": "17", "disasm": "OR", "inpt_sk": ["s(8)", "s(10)"], "outpt_sk": ["s(7)"], "gas": 3, "commutative": true, "storage": false, "size": 1}, {"id": "SHL_1", "opcode": "1b", "disasm": "SHL", "inpt_sk": ["s(22)", "s(9)"], "outpt_sk": ["s(8)"], "gas": 3, "commutative": false, "storage": false, "size": 1}, {"id": "PUSH [tag]_2", "opcode": "00", "disasm": "PUSH [tag]", "inpt_sk": [], "outpt_sk": ["s(9)"], "gas": 3, "commutative": false, "storage": false, "value": [121], "size": 5}, {"id": "SSTORE_0", "opcode": "55", "disasm": "SSTORE", "inpt_sk": ["s(23)", "s(0)"], "sto_var": ["sto0"], "outpt_sk": [], "gas": 5000, "commutative": false, "storage": true, "size": 1}, {"id": "MSTORE_0", "opcode": "52", "disasm": "MSTORE", "inpt_sk": ["s(18)", "s(14)"], "mem_var": ["mem0"], "outpt_sk": [], "gas": 3, "size": 1, "commutative": false, "storage": true}, {"id": "MSTORE_1", "opcode": "52", "disasm": "MSTORE", "inpt_sk": ["s(22)", "s(18)"], "mem_var": ["mem1"], "outpt_sk": [], "gas": 3, "size": 1, "commutative": false, "storage": true}, {"id": "PUSH_0", "opcode": "60", "disasm": "PUSH", "inpt_sk": [], "value": [0], "outpt_sk": ["s(18)"], "gas": 3, "commutative": false, "storage": false, "size": 2}, {"id": "PUSH_1", "opcode": "60", "disasm": "PUSH", "inpt_sk": [], "value": [64], "outpt_sk": ["s(19)"], "gas": 3, "commutative": false, "storage": false, "size": 2}, {"id": "PUSH_2", "opcode": "60", "disasm": "PUSH", "inpt_sk": [], "value": [1], "outpt_sk": ["s(20)"], "gas": 3, "commutative": false, "storage": false, "size": 2}, {"id": "PUSH_3", "opcode": "60", "disasm": "PUSH", "inpt_sk": [], "value": [160], "outpt_sk": ["s(21)"], "gas": 3, "commutative": false, "storage": false, "size": 2}, {"id": "PUSH_4", "opcode": "60", "disasm": "PUSH", "inpt_sk": [], "value": [32], "outpt_sk": ["s(22)"], "gas": 3, "commutative": false, "storage": false, "size": 2}, {"id": "PUSH_5", "opcode": "60", "disasm": "PUSH", "inpt_sk": [], "value": [2], "outpt_sk": ["s(23)"], "gas": 3, "commutative": false, "storage": false, "size": 2}], "current_cost": 5820, "storage_dependences": [["SSTORE_0", "SLOAD_0"]], "memory_dependences": [["MSTORE_1", "KECCAK256_0"], ["MSTORE_0", "KECCAK256_0"]], "is_revert": false, "rules_applied": false, "rules": [], "original_instrs": "PUSH 2 SSTORE PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP3 AND PUSH 0 SWAP1 DUP2 MSTORE PUSH 20 DUP2 DUP2 MSTORE PUSH 40 SWAP1 SWAP2 KECCAK256 SLOAD PUSH [tag] 80 SWAP2 DUP4 SWAP1 PUSH [tag] 18446744073709551971 PUSH [tag] 79 DUP3 SHL OR SWAP1 SHR"}'
    block_sfs = json.loads(input_json)
    query = ModelQuery(model_filename)
    bound = query.eval(block_sfs)
    print(f'Bound: {bound}')


# Usage example:
#
#   python3 bound_predictor.py -m saved_models/bound_predictor_size_01112022_0645_costa2.pyt
#
if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument('-m', '--model', type=str, required=True)
    args = parser.parse_args()

    example(args.model)
