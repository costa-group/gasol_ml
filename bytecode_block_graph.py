import re
import torch
from torch_geometric.data import Data
from opcodes import vocab as single_push_vocab, vocab_ as multi_push_vocab, is_push_instr, is_memory_read_instr, is_memory_write_instr, is_store_read_instr, is_store_write_instr, is_swap_instr, is_dup_instr, is_comm_instr, split_bytecode_


# one-hot vector
#
#  [commutative, opcode_0, opcode_1, ..., ...] 
#
#  - valid input: "empty", "in_var", "out_var" or a dictionary that corresponds to an instruction from the sfs
#  - all PUSHi are considered PUSH
#  - call with "empty" to get an empty vector
#
def node_features_com_single_push(opcode):

    vocab = single_push_vocab

    v = [0]*(len(vocab)+1) # size of the vocabulary + 1 for commutativity

    if opcode == "empty":
        pass
    else:
        v[0] = 1 if is_comm_instr(opcode) else 0

        # remove the 'i' from PUSHi
        if re.fullmatch("PUSH([0-9]+)", opcode) is not None:
            opcode = "PUSH"
            
        v[ vocab.index(opcode)+1 ] = 1
    
    return v

# one-hot vector
#
#  [commutative, opcode_0, opcode_1, ..., ...] 
#
#  - valid input: "empty", opcode
#  - PUSHi treated as different instructions
#  - call with "empty" to get an empty vector
#
def node_features_com_multi_push(opcode):

    vocab = multi_push_vocab

    v = [0]*(len(vocab)+1) # size of the vocabulary + 1 for commutativity

    if opcode == "empty":
        pass
    else:
        v[0] = 1 if is_comm_instr(opcode) else 0
        v[ vocab.index(opcode)+1 ] = 1

    return v

# one-hot vector:
#
#  [commutative, mem_read_inst, mem_write_inst, store_read_inst, store_write_inst, push_inst, pop, swap_inst, dup_inst, other_inst]
#
#  - valid input: "empty", opcode
#  - we just distinguish the class of the instruction swap/dup/push/memory/store/other (swap and dup never appear since we are using the sfs)
#  - call with "empty" to get an empty vector
#  
def node_feature_com_category(opcode):
    v = [0]*10

    if opcode == "empty":
        pass
    else:
        if is_comm_instr(opcode):
            v[0] = 1
        elif is_memory_read_instr(opcode):
            v[1] = 1
        elif is_memory_write_instr(opcode):
            v[2] = 1
        elif is_store_read_instr(opcode):
            v[3] = 1
        elif is_store_write_instr(opcode):
            v[4] = 1
        elif opcode == "POP":
            v[5] = 1
        elif is_push_instr(opcode):
            v[6] = 1
        elif is_swap_instr(opcode):
            v[7] = 1
        elif is_dup_instr(opcode):
            v[8] = 1
        else:
            v[9] = 1

    return v





# builds a linear graph from the bytecode sequence
#
class BytecodeBlockGraph:
    def __init__(self,
                 add_const_nodes=True, # add nodes for constants (the input to push, several push might share the same number)
                 node_features='single_push', #  node features builder (single_push, multi_push, instr_cat)
                 label_f=None,         # function for calculating the label
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
        self.regression = regression


    def build_graph(self, block_info, block_sfs):

        # we only handle benchamrks for which a model was found - should have been eliminated earlier
        if not block_info["model_found"]=="True":
            return None

        # this a list of tokens, for bytecodes and operands (of PUSH). The operands have a prefix '#'
        bytecode_sequence_orig =  split_bytecode_(block_sfs["original_instrs"])

        # remove operands from the bytecode sequence
        bytecode_sequence = list(filter(lambda x: not x.startswith("#"),bytecode_sequence_orig))

        # a list of feature vectors, one for each bytecode
        node_features_list = [ self.node_features_f(b) for b in bytecode_sequence ]

        # we connect them linearly
        edges_list = [ [i,i+1] for i in range(len(bytecode_sequence)-1) ]

        if self.add_const_nodes:

            # extend all featues vectors, adding zero at the end
            for fv in node_features_list:
                fv.append(0)

            # create a map from constants to lists of their corresponding instructions' indices
            nums = {}
            i = 0
            for b in bytecode_sequence_orig:
                if b.startswith("#"):
                    if nums.get(b) is None: # first time we see 'b'
                        nums[b]=[i]
                    else:
                        nums[b].append(i)
                else:
                    i=i+1

                    
            # build nodes for constants and connect them to their corresponding (PUSH) instructions
            for n in nums:
                features = self.node_features_f("empty")
                features.append(1)
                node_features_list.append(features)
                j = len(node_features_list)-1
                for k in nums[n]:
                    edges_list.append([j,k])


        # tensor for nodes
        x = torch.tensor(node_features_list, dtype=torch.long).to(torch.float)

        # tensor for edges
        edge_index = torch.tensor(edges_list, dtype=torch.long).t()
        
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

        return d

