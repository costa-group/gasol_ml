from bytecode_sequence import BytecodeSequence  
from fixed_models import Model_opt_classifier_size_03112022_1230_samirpc as Model

from pathlib import Path
import torch
import json
import os
import csv
import time
import argparse
import Pyro4



@Pyro4.expose
class ModelQuery:
    def __init__(self,model_filename):
        torch.set_num_threads(1)
        torch.set_num_interop_threads(1)
        self.model = torch.load(Path(__file__).parent.joinpath(Path(model_filename)).resolve())
        self.model.eval()
        self.sequence_builder = BytecodeSequence(encoding='multi_push')

    def eval(self, bytecode):

        with torch.no_grad():

            # convert the sequence into sequence of ids    
            bytecode_ids_sequence, bcs = self.sequence_builder.build_seq_from_bytecode(bytecode)
        
            data = 'seq', {}, torch.tensor([bytecode_ids_sequence]), [], torch.tensor([len(bytecode_ids_sequence)])  # [] is not used, it is supposed to be the labels of the batch

            pred = self.model(data).argmax(dim=1).item()

            return pred, bcs

def example(model_filename):
    bc=  "PUSH 2 SSTORE PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP3 AND PUSH 0 SWAP1 DUP2 MSTORE PUSH 20 DUP2 DUP2 MSTORE PUSH 40 SWAP1 SWAP2 KECCAK256 SLOAD PUSH [tag] 80 SWAP2 DUP4 SWAP1 PUSH [tag] 18446744073709551971 PUSH [tag] 79 DUP3 SHL OR SWAP1 SHR"
    
    query = ModelQuery(model_filename)
    c = query.eval(bc)
    print(f'Class: {c}')



def testall(model_filename,raw_dir):
    #raw_dir = 'data/jul22-0xa-8-17/raw'

    query = ModelQuery(model_filename)
    #query = Pyro4.Proxy(f"PYRONAME:opt_predictor.server")  # 

    total_time = 0.0

    i=0
    nm = ui = ex = 0
    csv_dir = f'{raw_dir}/csv'
    for csv_filename in os.listdir(csv_dir):
        csv_filename_noext = os.path.splitext(csv_filename)[0]
        with open(f'{csv_dir}/{csv_filename}', newline='') as csvfile:
            csv_reader = csv.DictReader(csvfile)
            for block_info in csv_reader:
                bc = block_info['previous_solution']
                    
                st = time.time()
                c, bcs = query.eval(bc)
                et = time.time()
                total_time += (et - st)
                # print(f'Class {c}')

                if c == 0 and float(block_info['saved_size']) > 0:
                    print(block_info['solver_time_in_sec']," : ",block_info['saved_size']," : ",block_info['previous_solution'])
                    print(bcs)

                # we only handle benchamrks for which a model was found -- should have been eliminated earlier
                if not block_info["model_found"]=="True":
                    nm += 1

                # i += 1
                # if i % 1000 == 0:
                #     print(f'stats {i}: {total_time} {nm} {ui} {ex}')

    print(f'stats: {total_time} {nm} {ui} {ex}')

    

#
def client_example():
    bc=  "PUSH 2 SSTORE PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP3 AND PUSH 0 SWAP1 DUP2 MSTORE PUSH 20 DUP2 DUP2 MSTORE PUSH 40 SWAP1 SWAP2 KECCAK256 SLOAD PUSH [tag] 80 SWAP2 DUP4 SWAP1 PUSH [tag] 18446744073709551971 PUSH [tag] 79 DUP3 SHL OR SWAP1 SHR"

    # This object should be created only once, and then call eval as many as you like
    server = Pyro4.Proxy(f"PYRONAME:opt_predictor.server") 

    for i in range(1000):
        c = server.eval(bc)
        print(c)
        
def start_server(model_name):
    daemon = Pyro4.Daemon()
    ns = Pyro4.locateNS()
    uri = daemon.register(ModelQuery(model_name))
    ns.register('opt_predictor.server', str(uri))
    print(f'Ready to listen')
    daemon.requestLoop()


# Usage example:
#
#   python3 bound_predictor.py -m saved_models/bound_predictor_size_01112022_0645_costa2.pyt
#
if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument('-m', '--model', type=str, default=None)
    parser.add_argument('-s', '--server', action='store_true')
    parser.add_argument('-c', '--client', action='store_true')
    parser.add_argument('-rd', '--raw_dir', type=str, default=None)
    args = parser.parse_args()

    if args.server:
        start_server(args.model)
    elif args.client:
        client_example()
    else:
        testall(args.model,args.raw_dir)
