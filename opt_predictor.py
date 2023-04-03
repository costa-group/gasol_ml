from bytecode_sequence import BytecodeSequence  

from pathlib import Path
import torch
import json
import os
import csv
import time
import argparse
import Pyro4

builders = {}
# for models in 221, 241
builders[0] = 'seq', BytecodeSequence(encoding='multi_push',regression=True)
# for models in 222, 242
builders[1] = 'seq', BytecodeSequence(encoding='multi_push',encode_consts=False,regression=True)


@Pyro4.expose
class ModelQuery:
    def __init__(self,model_filename,builder_id=0):
        torch.set_num_threads(1)
        torch.set_num_interop_threads(1)
        self.model = torch.load(Path(__file__).parent.joinpath(Path(model_filename)).resolve())
        self.model.eval()
        self.builder = builders[builder_id][1]
        if builders[builder_id][0] == 'seq':
            self.eval_fun = self._eval_from_bytecode
        else:
            raise Exception(f'uknown builder tag: {builders[builder_id][0]}')

    def _eval_from_bytecode(self, bytecode, p):

        with torch.no_grad():

            # convert the sequence into sequence of ids    
            bytecode_ids_sequence = self.builder.build_seq_from_bytecode(bytecode)
        
            data = 'seq', {}, torch.tensor([bytecode_ids_sequence]), [], torch.tensor([len(bytecode_ids_sequence)])  # [] is not used, it is supposed to be the labels of the batch

            pred_t = self.model(data)
            if p is None:
                pred = pred_t.argmax(dim=1).item()
            else:
                pred = 0 if self.model(data).softmax(1)[0][0] > p else 1  # we answer 0, only if the probability is > p

                
            return pred

    def eval(self, bytecode, p=None):
        return self.eval_fun(bytecode,p)

def example(model_filename,builder_id):
    bc=  "PUSH 2 SSTORE PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP3 AND PUSH 0 SWAP1 DUP2 MSTORE PUSH 20 DUP2 DUP2 MSTORE PUSH 40 SWAP1 SWAP2 KECCAK256 SLOAD PUSH [tag] 80 SWAP2 DUP4 SWAP1 PUSH [tag] 18446744073709551971 PUSH [tag] 79 DUP3 SHL OR SWAP1 SHR"

    query = ModelQuery(model_filename,builder_id=builder_id)
    c = query.eval(bc)
    print(f'Class: {c}')



def testall(model_filename,builder_id,raw_dir):
    #raw_dir = 'data/jul22-0xa-8-17/raw'

    query = ModelQuery(model_filename,builder_id=builder_id)
    #query = Pyro4.Proxy(f"PYRONAME:opt_predictor.server")  # 


    i=0
    total = total0 = total1 = wrong0 = wrong1 = 0
    for d in raw_dir:
        rd = f'data/gasol/raw/{d}'
        csv_dir = f'{rd}/csv'
        for csv_filename in os.listdir(csv_dir):
            csv_filename_noext = os.path.splitext(csv_filename)[0]
            with open(f'{csv_dir}/{csv_filename}', newline='') as csvfile:
                csv_reader = csv.DictReader(csvfile)
                for block_info in csv_reader:

                    if block_info["model_found"]=="True":

                        bc = block_info['previous_solution']
                    
                        c = query.eval(bc) # ,p=0.75
                        #print(f'Class {c}')

                        if float(block_info['saved_size']) > 0:  # should be changed to the desired classification parameter
                            total1 += 1
                            if c == 0:
                                wrong1 += 1
                        else:
                            total0 += 1
                            if c == 1:
                                wrong0 += 1

                        total += 1

                    i += 1
                    if i % 1000 == 0:
                        print(f'stats {i}: {total} {total0} ({wrong0}) {total1} ({wrong1})')
 
    print(f'stats {i}: {total} {total0} ({wrong0}) {total1} ({wrong1})')

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
    uri = daemon.register(ModelQuery(model_name,builder_id=builder_id))
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
