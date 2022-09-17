
import torch
from torch_geometric.data import Data
from .opcodes import *
from .gasol_utils import split_bytecode

# [in_var, out_var, commutative, opcode_0, opcode_2, ..., opcode_255] -- do we really need 255?
def features_generator_1(type,v=None,instr=None):
    if type == "empty":
        return [0]*(len(vocab)+1)
    elif type == "in_var":
        v[0] = 1
    elif type == "out_var":
        v[1] = 1
    elif type == "instr":
        if instr["commutative"]:
            v[ 2 ] = 1
        #v[ int(instr["opcode"],base=16)+3 ] = 1
        v[ vocab.index(instr["disasm"])+3 ] = 1
    else:
        raise Exception('Unknown type in features_1')


# [in_var, out_var, commutative, mem_inst, store_inst, push_inst, other_inst] -- do we really need 255?
def features_generator_2(type,v=None,instr=None):
    if type == "empty":
        return [0]*7
    elif type == "in_var":
        v[0] = 1
    elif type == "out_var":
        v[1] = 1
    elif type == "instr":
        if instr["commutative"]:
            v[2] = 1
        if is_memory_instr(instr["disasm"]):
            v[3] = 1
        elif is_store_instr(instr["disasm"]):
            v[4] = 1
        elif is_push_instr(instr["disasm"]):
            v[5] = 1
        else:
            v[6] = 1
    else:
        raise Exception('Unknown type in features_2')


def class_generator_1(block_info, block_sfs):    
        c = int(float(block_info["optimized_n_instrs"]))-len(block_sfs["user_instrs"])
        c = min(20,c)
        return c

def class_generator_2(block_info, block_sfs):    
        c = int(float(block_info["optimized_n_instrs"]))-len(block_sfs["user_instrs"])
        c = min(1,c)
        return c

def class_generator_3(block_info, block_sfs):    
        f = float(block_info["optimized_n_instrs"])/float(block_info["initial_n_instrs"])
        c = int(max(f,0.6)*10)-6
        return c

def class_generator_4(block_info, block_sfs):
    if int(block_info["saved_gas"]) > 0:
        c = 0
    else:
        c = 1
    return c


def class_generator_5(block_info, block_sfs):    
    if float(block_info["optimized_n_instrs"]) < float(block_info["initial_n_instrs"]):
        c = 0
    else:
        c = 1
    return c


class GraphBuilder_1:
    
    def __init__(self,
                 in_stk_order=True,   # connect out_stk nodes
                 out_stk_order=True,  # connect in_stk nodes
                 features_gen=features_generator_1,
                 class_gen=class_generator_1):
        self.out_stk_order = out_stk_order
        self.in_stk_order = in_stk_order
        self.features_gen = features_gen
        self.class_gen = class_gen
        
    def build_graph(self, block_info, block_sfs):

        # we only handle benchamrks for which a model was found
        if not block_info["model_found"]=="True":
            return None

        # ignore those with empty sfs
        if len(block_sfs["user_instrs"])==0:
            return None

        number_of_nodes = 0           # nodes identifiers should start from zero and be consecutive
        nodes_map = {}                # s(i) -> idx, "PUSH_0" -> idx, ...
        edges_list = []               # [ [src,tgt],.... ]
        node_features_list = []       # the i-th element is the feasters vector of node i
        inverse_map = {}              # maps the output variable of an instructions to its 'id', use when tmp variables are eliminated

        
        # create the the input variable nodes 
        features = self.features_gen("empty")
        self.features_gen("in_var",features)
        for node_id in block_sfs["src_ws"]:
            if not node_id in nodes_map:  # this check is becuase the data might have some duplicates
                nodes_map[node_id] = number_of_nodes
                number_of_nodes = number_of_nodes + 1
                node_features_list.append(features)
            else:
                raise Exception('duplicates in the input stack')

        # connect all input variables (trying to make order important ...)
        if self.in_stk_order:
            for i in range(number_of_nodes-1):
                edges_list.append( [i,i+1] )

        # create output variable node (one for each position in the output stack)
        features = self.features_gen("empty")
        self.features_gen("out_var",features)
        for i in range(len(block_sfs["tgt_ws"])):
            nodes_map[f"o({i})"] = number_of_nodes
            number_of_nodes = number_of_nodes + 1
            node_features_list.append(features)

        # connect all output variables (trying to make order important ...)
        if self.out_stk_order:
            for i in range(len(block_sfs["tgt_ws"])-1):
                edges_list.append( [nodes_map[f"o({i})"],nodes_map[f"o({i+1})"]] )

        # add the instructions nodes
        for instr in block_sfs["user_instrs"]:
            features = self.features_gen("empty")
            instr_id = instr["id"]
            if not instr_id in nodes_map:  # this check is becuase the data might have some duplicates
                nodes_map[instr_id] = number_of_nodes
                number_of_nodes = number_of_nodes + 1
                self.features_gen("instr",features,instr=instr)
                node_features_list.append(features)

        # construct a map from temporal variables to their respective instructions
        for instr in block_sfs["user_instrs"]:
            out_vars = instr["outpt_sk"]
            if len(out_vars) > 0:
                if len(out_vars) == 1:
                    inverse_map[out_vars[0]] = nodes_map[instr["id"]]
                else:
                    raise Exception('outpt_sk is of size >1')

        # construct edges to output variables        
        for i in range(len(block_sfs["tgt_ws"])):
            out_var = block_sfs["tgt_ws"][i]
            if nodes_map.get(out_var) != None:
                edges_list.append( [nodes_map[out_var], nodes_map[f"o({i})"]] )  # input variables
            else:
                edges_list.append( [inverse_map[out_var], nodes_map[f"o({i})"]] )  # temporal variable, connect to correcponding instructions

        # construct edges from instructions
        for instr in block_sfs["user_instrs"]:
            node_id = nodes_map[instr["id"]]
            for in_var in instr["inpt_sk"]:
                if nodes_map.get(in_var) != None:
                    edges_list.append( [nodes_map[in_var],node_id] )
                else:
                    edges_list.append( [inverse_map[in_var],node_id] )

            for out_var in instr["outpt_sk"]:
                if nodes_map.get(out_var) != None:
                    edges_list.append( [node_id,nodes_map[out_var]] )

        # compute class
        c = self.class_gen(block_info,block_sfs)

        # print()
        # print(block_sfs)
        # print(nodes_map)
        # print(inverse_map)
        # print(edges_list)
        # print(c)
        # create tensors from graph data, and return a corresponding Data object
        x = torch.tensor(node_features_list, dtype=torch.long).to(torch.float)
        edge_index = torch.tensor(edges_list, dtype=torch.long).t()
        y = torch.tensor(c,dtype=torch.long)
        d = Data(x=x, edge_index=edge_index, y=y)
        return d



    # [in_var, out_var, commutative, opcode_0, opcode_2, ..., opcode_255] -- do we really need 255?
    
class GraphBuilder_2:
    def __init__(self,
                 class_gen=class_generator_1):
        self.class_gen = class_gen
        

    def __build_features_vec(self,bytecode):
        features = [0]*len(vocab)
        features[ vocab.index(bytecode) ] = 1
        return features

    def build_graph_for_evaluation(self, bytecode):
        bytecode_sequence =  split_bytecode(bytecode)
        node_features_list = [ self.__build_features_vec(b) for b in bytecode_sequence ]
        edges_list = [ [i,i+1] for i in range(len(bytecode_sequence)-1) ]

        x = torch.tensor(node_features_list, dtype=torch.long).to(torch.float)
        edge_index = torch.tensor(edges_list, dtype=torch.long).t()
        d = Data(x=x, edge_index=edge_index)
        return d

    def build_graph(self, block_info, block_sfs):

        # we only handle benchamrks for which a model was found
        if not block_info["model_found"]=="True":
            return None

        bytecode_sequence =  split_bytecode(block_sfs["original_instrs"])
        node_features_list = [ self.__build_features_vec(b) for b in bytecode_sequence ]
        edges_list = [ [i,i+1] for i in range(len(bytecode_sequence)-1) ]

        # compute class
        c = self.class_gen(block_info,block_sfs)

        x = torch.tensor(node_features_list, dtype=torch.long).to(torch.float)
        edge_index = torch.tensor(edges_list, dtype=torch.long).t()
        y = torch.tensor(c,dtype=torch.long)
        d = Data(x=x, edge_index=edge_index, y=y)
        return d




class SequenceBuilder_1:
    def __init__(self,
                 class_gen=class_generator_1):
        self.class_gen = class_gen
        

#    def __build_features_vec(self,bytecode):
#        features = [0]*len(vocab)
#        features[ vocab.index(bytecode) ] = 1
#        return features

    def vocab_size(self):
        return len(vocab)

    def build_seq(self, block_info, block_sfs):

        # we only handle benchamrks for which a model was found
        if not block_info["model_found"]=="True":
            return None

        # sequence of bytecodes to sequence of feature vectors (each vector represents a bytecode)
        bytecode_sequence = split_bytecode(block_sfs["original_instrs"])
        #print(bytecode_sequence)
        features_sequence = [ vocab.index(b) for b in bytecode_sequence ]

        # compute class
        c = self.class_gen(block_info,block_sfs)

        x = torch.tensor(features_sequence, dtype=torch.long).to(torch.long)
        y = torch.tensor(c,dtype=torch.long)
        return {"data": x, "label": y}
