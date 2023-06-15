import re
import torch
from torch_geometric.data import Data
import networkx as nx

# from opcodes import vocab  as single_push_vocab, vocab_ as multi_push_vocab, is_push_instr, is_memory_instr, is_store_instr
from opcodes import vocab as single_push_vocab, vocab_ as multi_push_vocab, is_push_instr, is_memory_read_instr, is_memory_write_instr, is_store_read_instr, is_store_write_instr, is_swap_instr, is_dup_instr, is_comm_instr, split_bytecode_


# one-hot vector
#
#
def node_features_com_single_push(opcode):

    vocab = single_push_vocab

    v = [0]*len(vocab) 

    if opcode != "empty":
        # remove the 'i' from PUSHi
        if re.fullmatch("PUSH([0-9]+)", opcode) is not None:
            opcode = "PUSH"

        v [ vocab.index(opcode) ] = 1

    return v

# one-hot vector
#
#
def node_features_com_multi_push(opcode):

    vocab = multi_push_vocab

    v = [0]*len(vocab) 

    if opcode != "empty":
        v [ vocab.index(opcode) ] = 1

    return v


# one-hot vector:
#
def node_feature_com_category(opcode):

    v = [0]*10 

    if opcode != "empty":
        if is_comm_instr(opcode):
            idx = 0
        elif is_memory_read_instr(opcode):
            idx = 1
        elif is_memory_write_instr(opcode):
            idx = 2
        elif is_store_read_instr(opcode):
            idx = 3
        elif is_store_write_instr(opcode):
            idx = 4
        elif opcode == "POP":
            idx = 5
        elif is_push_instr(opcode):
            idx = 6
        elif is_swap_instr(opcode):
            idx = 7
        elif is_dup_instr(opcode):
            idx = 8
        else:
            idx = 9

        v[idx] = 1

    return v

# one-hot vector: clasify instructions by the number of elements that they remove from the stack
#
#  
def node_feature_com_category2(opcode):
    v = [0]*10 

    if opcode != "empty":
        if is_comm_instr(opcode):
            idx = 0
        elif is_memory_read_instr(opcode):
            idx = 1
        elif is_memory_write_instr(opcode):
            idx = 2
        elif is_store_read_instr(opcode):
            idx = 3
        elif is_store_write_instr(opcode):
            idx = 4
        elif opcode == "POP":
            idx = 5
        elif is_push_instr(opcode):
            idx = 6
        elif is_swap_instr(opcode):
            idx = 7
        elif is_dup_instr(opcode):
            idx = 8
        else:
            try:
                idx = get_opcode(opcode)[1]+9
            except Exception as e:
                print(f'error: {opcode}')
                exit(1)
            
        v[idx] = 1
        
    return v





# builds a graph from the bytecode sequence
#
#
class BytecodeSequenceGraph:

    def __init__(self,
                 add_const_nodes=True, # add nodes for constants (the input to push, several push might share the same number)
                 node_features='category', #  node features builder (single_push, multi_push, category)
                 label_f=None,         # function for calculating the label
                 edges='forward',      # can be 'forward', 'backwards' or 'both'                 
                 regression=False):    # if it is a regression problem (should be eliminated at some point, it is ugly)

        if node_features == 'single_push':
            self.node_features_f = node_features_com_single_push
        elif node_features == 'multi_push':
            self.node_features_f = node_features_com_multi_push
        elif node_features == 'category':
            self.node_features_f = node_feature_com_category
        else:
            raise Exception(f"Invalid value for node_features: {node_features}")

        self.add_const_nodes = add_const_nodes
        self.label_f = label_f
        self.edges = edges
        self.regression = regression


    def build_graph_from_bytecode(self, bytecode):

        number_of_nodes = 0           # node identifiers should start from zero and be consecutive
        edges_list = []               # [ [src,tgt],.... ]
        node_features_list = []       # the i-th element is the feasters vector of node i

        # node 0 is an auxiliary node connected to the first instruction and all constants 
        node_features_list.append(self.node_features_f("empty"))
        edges_list.append([0,1])
        number_of_nodes += 1

        # tokenize the bytecode sequence
        bytecode_sequence_orig = split_bytecode_(bytecode)

        # create a node for each token in the bytecode sequence
        nums = {}
        for t in bytecode_sequence_orig:
            if t.startswith("#"):
                if nums.get(t) is None: # constant that we have not seen before
                    nums[t]=[ number_of_nodes ]
                else:
                    nums[t].append( number_of_nodes ) # the constant is already in th etable
            else:
                node_features_list.append(self.node_features_f(t))
                edges_list.append([number_of_nodes-1,number_of_nodes])
                number_of_nodes += 1

                
        # add and end node, connected to the last instruction
        node_features_list.append(self.node_features_f("empty"))
        edges_list.append([number_of_nodes-1,number_of_nodes])
        number_of_nodes += 1

        if self.add_const_nodes:

            # extend all featues vectors, adding zero at the end
            for fv in node_features_list:
                fv.append(0)

            # build nodes for constants and connect them to their corresponding (PUSH) instructions
            for n in nums:
                features = self.node_features_f("empty")
                features.append(1)
                node_features_list.append(features)
                this_node_id = number_of_nodes
                number_of_nodes += 1
                edges_list.append([0,this_node_id])
                for k in nums[n]:
                    edges_list.append([this_node_id,k])

                    
        if self.edges == 'backwards':
           edges_list = [ [t,s] for [s,t] in edges_list ]
        elif self.edges == 'both':
           edges_list.extend( [ [t,s] for [s,t] in edges_list ] )

        # tensor for nodes
        x = torch.tensor(node_features_list, dtype=torch.long).to(torch.float)

        # tensor for edges
        edge_index = torch.tensor(edges_list, dtype=torch.long).t()

        return (x, edge_index)
    
    def build_graph(self, block_info, block_sfs):

        # we only handle benchamrks for which a model was found -- should have been eliminated earlier
        if not block_info["model_found"]=="True":
            return None

        x, edge_index = self.build_graph_from_bytecode(block_info['previous_solution'])
        
        # compute label -- must get rid of self.regression, it is ugly!!
        label = self.label_f(block_info,block_sfs)
        if self.regression:
            y = torch.tensor([[label]]).to(torch.float)
        else:
            y = torch.tensor(label).to(torch.long)            

        # construct pyg Data object 
        d = Data(x=x, edge_index=edge_index, y=y)
        
        # fill in extra information in Data (to be used in precision evaluators)
        d.initial_n_instrs = torch.tensor(int(block_info["initial_n_instrs"]))
        d.sfs_size = torch.tensor(len(block_sfs["user_instrs"]))
        d.size_saved = torch.tensor(float(block_info["saved_size"]))
        d.time = torch.tensor(float(block_info["solver_time_in_sec"]))
        d.gas_saved = torch.tensor(float(block_info["saved_gas"]))

        return [d]

