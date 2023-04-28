from sfs_graph import SFSGraph
from bytecode_sequence import BytecodeSequence  

from pathlib import Path
import torch
import json
import argparse
import os
import csv
import json
import time
import Pyro4

builders = {}
# for models in 211, 231
builders[0] = 'pyg', SFSGraph(node_features='multi_push',regression=True)
# for models in 212, 232
builders[1] = 'pyg', SFSGraph(node_features='multi_push',in_stk_order=True,out_stk_order=True,regression=True)
# for models in 213, 233
builders[2] = 'pyg', SFSGraph(node_features='multi_push',edges='forward',in_stk_order=True,out_stk_order=True,regression=True)
# for models in 214, 234
builders[3] = 'pyg', SFSGraph(node_features='multi_push',edges='backwards',in_stk_order=True,out_stk_order=True,regression=True)
# for set 215, 235
builders[4] = 'seq', BytecodeSequence(encoding='multi_push',regression=True)
# for models in 216, 236
builders[5] = 'seq', BytecodeSequence(encoding='multi_push',encode_consts=False,regression=True)


@Pyro4.expose
class ModelQuery:
    def __init__(self,model_filename,builder_id=0,to_int=round):
        # torch.set_num_threads(1)
        # torch.set_num_interop_threads(1)
        self.to_int = to_int
        self.model = torch.load(Path(__file__).parent.joinpath(Path(model_filename)).resolve())
        self.model.eval()
        self.builder = builders[builder_id][1]
        if builders[builder_id][0] == 'pyg':
            self.eval_fun = self._eval_from_sfs
        elif builders[builder_id][0] == 'seq':
            self.eval_fun = self._eval_from_bytecode
        else:
            raise Exception(f'uknown builder tag: {builders[builder_id][0]}')


    def _eval_from_sfs(self, block_sfs):
        with torch.no_grad():

            if len(block_sfs["user_instrs"])==0:
                return block_sfs["min_length"]

            x, edge_index = self.builder.build_graph_from_sfs(block_sfs)

            data = ('pyg', {}, x, [], edge_index,torch.zeros(len(x),dtype=torch.int64))
            out = self.model(data)
            
            bound = self.to_int(out.item()) + block_sfs["min_length"]

            return bound

    def _eval_from_bytecode(self, block_sfs):
        with torch.no_grad():

            bytecode = block_sfs["original_instrs"]
            bytecode_ids_sequence = self.builder.build_seq_from_bytecode(bytecode)
        
            data = 'seq', {}, torch.tensor([bytecode_ids_sequence]), [], torch.tensor([len(bytecode_ids_sequence)])  # [] is not used, it is supposed to be the labels of the batch

            out = self.model(data)
            
            bound = self.to_int(out.item()) + block_sfs["min_length"]

            return bound

        
    def eval(self, block_sfs):
        return self.eval_fun(block_sfs)

def example(model_filename,builder_id):
    input_json = '{"init_progr_len": 33, "max_progr_len": 33, "max_sk_sz": 14, "vars": ["s(0)", "s(1)", "s(10)", "s(11)", "s(12)", "s(13)", "s(14)", "s(15)", "s(16)", "s(2)", "s(6)", "s(7)", "s(8)", "s(9)", "s(18)", "s(19)", "s(20)", "s(21)", "s(22)", "s(23)"], "src_ws": ["s(0)", "s(1)", "s(2)"], "tgt_ws": ["s(6)", "s(1)", "s(12)", "s(13)", "s(1)", "s(2)"], "user_instrs": [{"id": "PUSH [tag]_0", "opcode": "00", "disasm": "PUSH [tag]", "inpt_sk": [], "outpt_sk": ["s(10)"], "gas": 3, "commutative": false, "storage": false, "value": [114598615266301018708337], "size": 5}, {"id": "KECCAK256_0", "opcode": "20", "disasm": "KECCAK256", "inpt_sk": ["s(18)", "s(19)"], "outpt_sk": ["s(11)"], "gas": 30, "commutative": false, "storage": false, "size": 1}, {"id": "SLOAD_0", "opcode": "54", "disasm": "SLOAD", "inpt_sk": ["s(11)"], "outpt_sk": ["s(12)"], "gas": 700, "commutative": false, "storage": false, "size": 1}, {"id": "PUSH [tag]_1", "opcode": "00", "disasm": "PUSH [tag]", "inpt_sk": [], "outpt_sk": ["s(13)"], "gas": 3, "commutative": false, "storage": false, "value": [128], "size": 5}, {"id": "AND_0", "opcode": "16", "disasm": "AND", "inpt_sk": ["s(2)", "s(15)"], "outpt_sk": ["s(14)"], "gas": 3, "commutative": true, "storage": false, "size": 1}, {"id": "SUB_0", "opcode": "03", "disasm": "SUB", "inpt_sk": ["s(16)", "s(20)"], "outpt_sk": ["s(15)"], "gas": 3, "commutative": false, "storage": false, "size": 1}, {"id": "SHL_0", "opcode": "1b", "disasm": "SHL", "inpt_sk": ["s(21)", "s(20)"], "outpt_sk": ["s(16)"], "gas": 3, "commutative": false, "storage": false, "size": 1}, {"id": "SHR_0", "opcode": "1c", "disasm": "SHR", "inpt_sk": ["s(22)", "s(7)"], "outpt_sk": ["s(6)"], "gas": 3, "commutative": false, "storage": false, "size": 1}, {"id": "OR_0", "opcode": "17", "disasm": "OR", "inpt_sk": ["s(8)", "s(10)"], "outpt_sk": ["s(7)"], "gas": 3, "commutative": true, "storage": false, "size": 1}, {"id": "SHL_1", "opcode": "1b", "disasm": "SHL", "inpt_sk": ["s(22)", "s(9)"], "outpt_sk": ["s(8)"], "gas": 3, "commutative": false, "storage": false, "size": 1}, {"id": "PUSH [tag]_2", "opcode": "00", "disasm": "PUSH [tag]", "inpt_sk": [], "outpt_sk": ["s(9)"], "gas": 3, "commutative": false, "storage": false, "value": [121], "size": 5}, {"id": "SSTORE_0", "opcode": "55", "disasm": "SSTORE", "inpt_sk": ["s(23)", "s(0)"], "sto_var": ["sto0"], "outpt_sk": [], "gas": 5000, "commutative": false, "storage": true, "size": 1}, {"id": "MSTORE_0", "opcode": "52", "disasm": "MSTORE", "inpt_sk": ["s(18)", "s(14)"], "mem_var": ["mem0"], "outpt_sk": [], "gas": 3, "size": 1, "commutative": false, "storage": true}, {"id": "MSTORE_1", "opcode": "52", "disasm": "MSTORE", "inpt_sk": ["s(22)", "s(18)"], "mem_var": ["mem1"], "outpt_sk": [], "gas": 3, "size": 1, "commutative": false, "storage": true}, {"id": "PUSH_0", "opcode": "60", "disasm": "PUSH", "inpt_sk": [], "value": [0], "outpt_sk": ["s(18)"], "gas": 3, "commutative": false, "storage": false, "size": 2}, {"id": "PUSH_1", "opcode": "60", "disasm": "PUSH", "inpt_sk": [], "value": [64], "outpt_sk": ["s(19)"], "gas": 3, "commutative": false, "storage": false, "size": 2}, {"id": "PUSH_2", "opcode": "60", "disasm": "PUSH", "inpt_sk": [], "value": [1], "outpt_sk": ["s(20)"], "gas": 3, "commutative": false, "storage": false, "size": 2}, {"id": "PUSH_3", "opcode": "60", "disasm": "PUSH", "inpt_sk": [], "value": [160], "outpt_sk": ["s(21)"], "gas": 3, "commutative": false, "storage": false, "size": 2}, {"id": "PUSH_4", "opcode": "60", "disasm": "PUSH", "inpt_sk": [], "value": [32], "outpt_sk": ["s(22)"], "gas": 3, "commutative": false, "storage": false, "size": 2}, {"id": "PUSH_5", "opcode": "60", "disasm": "PUSH", "inpt_sk": [], "value": [2], "outpt_sk": ["s(23)"], "gas": 3, "commutative": false, "storage": false, "size": 2}], "current_cost": 5820, "storage_dependences": [["SSTORE_0", "SLOAD_0"]], "memory_dependences": [["MSTORE_1", "KECCAK256_0"], ["MSTORE_0", "KECCAK256_0"]], "is_revert": false, "rules_applied": false, "rules": [], "original_instrs": "PUSH 2 SSTORE PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP3 AND PUSH 0 SWAP1 DUP2 MSTORE PUSH 20 DUP2 DUP2 MSTORE PUSH 40 SWAP1 SWAP2 KECCAK256 SLOAD PUSH [tag] 80 SWAP2 DUP4 SWAP1 PUSH [tag] 18446744073709551971 PUSH [tag] 79 DUP3 SHL OR SWAP1 SHR"}'
    block_sfs = json.loads(input_json)
    query = ModelQuery(model_filename,builder_id=builder_id)
    bound = query.eval(block_sfs)
    print(f'Bound: {bound}')

def testall(model_filename,builder_id,raw_dir):
    #raw_dir = 'data/jul22-0xa-8-17/raw'

    query = ModelQuery(model_filename,builder_id=builder_id)
    #query = Pyro4.Proxy(f"PYRONAME:bound_predictor.server")  # 


    i=0
    for d in raw_dir:
        rd = f'data/gasol/raw/{d}'
        csv_dir = f'{rd}/csv'
        for csv_filename in os.listdir(csv_dir):
            csv_filename_noext = os.path.splitext(csv_filename)[0]
            with open(f'{csv_dir}/{csv_filename}', newline='') as csvfile:
                csv_reader = csv.DictReader(csvfile)
                for block_info in csv_reader:
                    block_id = block_info['block_id']
                    with open(f'{rd}/jsons/{csv_filename_noext}/{block_id}_input.json', 'r') as f:
                        block_sfs = json.load(f)
                        
                        bound = query.eval(block_sfs)
                        print(f'Bound: {bound}')
                        
                        i += 1
                        if i % 1000 == 0:
                            print(f'stats {i}: ...')
                            
    print(f'stats {i}: ...')

#
def client_example():
        input_json = ' {"init_progr_len": 33, "max_progr_len": 33, "max_sk_sz": 14, "vars": ["s(0)", "s(1)", "s(10)", "s(11)", "s(12)", "s(13)", "s(14)", "s(15)", "s(16)", "s(2)", "s(6)", "s(7)", "s(8)", "s(9)", "s(18)", "s(19)", "s(20)", "s(21)", "s(22)", "s(23)"], "src_ws": ["s(0)", "s(1)", "s(2)"], "tgt_ws": ["s(6)", "s(1)", "s(12)", "s(13)", "s(1)", "s(2)"], "user_instrs": [{"id": "PUSH [tag]_0", "opcode": "00", "disasm": "PUSH [tag]", "inpt_sk": [], "outpt_sk": ["s(10)"], "gas": 3, "commutative": false, "storage": false, "value": [114598615266301018708337], "size": 5}, {"id": "KECCAK256_0", "opcode": "20", "disasm": "KECCAK256", "inpt_sk": ["s(18)", "s(19)"], "outpt_sk": ["s(11)"], "gas": 30, "commutative": false, "storage": false, "size": 1}, {"id": "SLOAD_0", "opcode": "54", "disasm": "SLOAD", "inpt_sk": ["s(11)"], "outpt_sk": ["s(12)"], "gas": 700, "commutative": false, "storage": false, "size": 1}, {"id": "PUSH [tag]_1", "opcode": "00", "disasm": "PUSH [tag]", "inpt_sk": [], "outpt_sk": ["s(13)"], "gas": 3, "commutative": false, "storage": false, "value": [128], "size": 5}, {"id": "AND_0", "opcode": "16", "disasm": "AND", "inpt_sk": ["s(2)", "s(15)"], "outpt_sk": ["s(14)"], "gas": 3, "commutative": true, "storage": false, "size": 1}, {"id": "SUB_0", "opcode": "03", "disasm": "SUB", "inpt_sk": ["s(16)", "s(20)"], "outpt_sk": ["s(15)"], "gas": 3, "commutative": false, "storage": false, "size": 1}, {"id": "SHL_0", "opcode": "1b", "disasm": "SHL", "inpt_sk": ["s(21)", "s(20)"], "outpt_sk": ["s(16)"], "gas": 3, "commutative": false, "storage": false, "size": 1}, {"id": "SHR_0", "opcode": "1c", "disasm": "SHR", "inpt_sk": ["s(22)", "s(7)"], "outpt_sk": ["s(6)"], "gas": 3, "commutative": false, "storage": false, "size": 1}, {"id": "OR_0", "opcode": "17", "disasm": "OR", "inpt_sk": ["s(8)", "s(10)"], "outpt_sk": ["s(7)"], "gas": 3, "commutative": true, "storage": false, "size": 1}, {"id": "SHL_1", "opcode": "1b", "disasm": "SHL", "inpt_sk": ["s(22)", "s(9)"], "outpt_sk": ["s(8)"], "gas": 3, "commutative": false, "storage": false, "size": 1}, {"id": "PUSH [tag]_2", "opcode": "00", "disasm": "PUSH [tag]", "inpt_sk": [], "outpt_sk": ["s(9)"], "gas": 3, "commutative": false, "storage": false, "value": [121], "size": 5}, {"id": "SSTORE_0", "opcode": "55", "disasm": "SSTORE", "inpt_sk": ["s(23)", "s(0)"], "sto_var": ["sto0"], "outpt_sk": [], "gas": 5000, "commutative": false, "storage": true, "size": 1}, {"id": "MSTORE_0", "opcode": "52", "disasm": "MSTORE", "inpt_sk": ["s(18)", "s(14)"], "mem_var": ["mem0"], "outpt_sk": [], "gas": 3, "size": 1, "commutative": false, "storage": true}, {"id": "MSTORE_1", "opcode": "52", "disasm": "MSTORE", "inpt_sk": ["s(22)", "s(18)"], "mem_var": ["mem1"], "outpt_sk": [], "gas": 3, "size": 1, "commutative": false, "storage": true}, {"id": "PUSH_0", "opcode": "60", "disasm": "PUSH", "inpt_sk": [], "value": [0], "outpt_sk": ["s(18)"], "gas": 3, "commutative": false, "storage": false, "size": 2}, {"id": "PUSH_1", "opcode": "60", "disasm": "PUSH", "inpt_sk": [], "value": [64], "outpt_sk": ["s(19)"], "gas": 3, "commutative": false, "storage": false, "size": 2}, {"id": "PUSH_2", "opcode": "60", "disasm": "PUSH", "inpt_sk": [], "value": [1], "outpt_sk": ["s(20)"], "gas": 3, "commutative": false, "storage": false, "size": 2}, {"id": "PUSH_3", "opcode": "60", "disasm": "PUSH", "inpt_sk": [], "value": [160], "outpt_sk": ["s(21)"], "gas": 3, "commutative": false, "storage": false, "size": 2}, {"id": "PUSH_4", "opcode": "60", "disasm": "PUSH", "inpt_sk": [], "value": [32], "outpt_sk": ["s(22)"], "gas": 3, "commutative": false, "storage": false, "size": 2}, {"id": "PUSH_5", "opcode": "60", "disasm": "PUSH", "inpt_sk": [], "value": [2], "outpt_sk": ["s(23)"], "gas": 3, "commutative": false, "storage": false, "size": 2}], "current_cost": 5820, "storage_dependences": [["SSTORE_0", "SLOAD_0"]], "memory_dependences": [["MSTORE_1", "KECCAK256_0"], ["MSTORE_0", "KECCAK256_0"]], "is_revert": false, "rules_applied": false, "rules": [], "original_instrs": "PUSH 2 SSTORE PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP3 AND PUSH 0 SWAP1 DUP2 MSTORE PUSH 20 DUP2 DUP2 MSTORE PUSH 40 SWAP1 SWAP2 KECCAK256 SLOAD PUSH [tag] 80 SWAP2 DUP4 SWAP1 PUSH [tag] 18446744073709551971 PUSH [tag] 79 DUP3 SHL OR SWAP1 SHR"}'

        # This object should be created only once, and then call eval as many as you like
        server = Pyro4.Proxy(f"PYRONAME:bound_predictor.server") 

        for i in range(1000):
            block_sfs = json.loads(input_json)
            bound = server.eval(block_sfs)
            print(bound)
    
def start_server(model_name,builder_id):
    daemon = Pyro4.Daemon()
    ns = Pyro4.locateNS()
    uri = daemon.register(ModelQuery(model_name,builder_id=builder_id))
    ns.register('bound_predictor.server', str(uri))
    print(f'Ready to listen')
    daemon.requestLoop()

    
        
# if you want to use it as client/server you should strat the pyro4 name server first:
#
#   python3 -m Pyro4.naming
#
# Usage example:
#
#   python3 bound_predictor.py -s -m saved_models/bound_predictor_size_01112022_0645_costa2.pyt
#   python3 bound_predictor.py -c
#
if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument('-m', '--model', type=str, default=None)
    parser.add_argument('-b', '--builder', type=int, default=0)
    parser.add_argument('-s', '--server', action='store_true')
    parser.add_argument('-c', '--client', action='store_true')
    parser.add_argument('-rd', '--raw_dir', type=str, default=None,nargs='+')
    args = parser.parse_args()
    
    if args.server:
        start_server(args.model,args.builder)
    elif args.client:
        client_example()
    else:
        testall(args.model,args.builder,args.raw_dir)
