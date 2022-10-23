
import torch
from torch_geometric.data import Data
from .opcodes import *
from .gasol_utils import split_bytecode, split_bytecode_

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

# [in_var, out_var, commutative, opcode_0, opcode_2, ..., opcode_255] -- do we really need 255?
def features_generator_1_multipush(type,v=None,instr=None):
    if type == "empty":
        return [0]*(len(vocab_)+3)
    elif type == "in_var":
        v[0] = 1
    elif type == "out_var":
        v[1] = 1
    elif type == "instr":
        if instr["commutative"]:
            v[ 2 ] = 1
        i = instr["disasm"];
        if i == "PUSH":
            size = instr["size"]-1
            assert size >=1 and size <= 32
            i = f'{i}{size}'
        v[ vocab_.index(i)+3 ] = 1
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

def class_generator_11(block_info, block_sfs):    
        return float(block_info["optimized_n_instrs"]);


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
def class_generator_4_size(block_info, block_sfs):
    if int(block_info["saved_size"]) > 0:
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
                 num_nodes = True,
                 features_gen=features_generator_1_multipush,
                 class_gen=class_generator_1,
                 regression=False):
        self.out_stk_order = out_stk_order
        self.in_stk_order = in_stk_order
        self.num_nodes = num_nodes
        self.features_gen = features_gen
        self.class_gen = class_gen
        self.regression = regression
            
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
        for node_id in block_sfs["src_ws"]:
            features = self.features_gen("empty")
            self.features_gen("in_var",features)
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
        for i in range(len(block_sfs["tgt_ws"])):
            features = self.features_gen("empty")
            self.features_gen("out_var",features)
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



        if self.num_nodes:

            # extend all featues vectors
            for fv in node_features_list:
                fv.append(0)

            # add number edges
            nums = {}
            i = 0
            for instr in block_sfs["user_instrs"]:
                if instr["disasm"] == "PUSH":
                    b = instr["value"][0]
                    if nums.get(b) is None:
                        nums[b]=[ nodes_map[instr["id"]] ]
                    else:
                        nums[b].append( nodes_map[instr["id"]] )
                else:
                    i=i+1
            for n in nums:
                features = self.features_gen("empty")
                features.append(1)
                node_features_list.append(features)
                j = len(node_features_list)-1
                for k in nums[n]:
                    edges_list.append([j,k])


        # n = len(node_features_list)
        # for fv in node_features_list:
        #     fv.append(n)

        # compute class
        c = self.class_gen(block_info,block_sfs)

        x = torch.tensor(node_features_list, dtype=torch.long).to(torch.float)
        # normalizing to 0-1 ---- not used for now
        #        for i in range(len(x)):
        #     x[i] = (x[i] - x[i].mean()) / x[i].std()
        edge_index = torch.tensor(edges_list, dtype=torch.long).t()
        if self.regression:
            y = torch.tensor([[c]]).to(torch.float)
        else:
            y = torch.tensor(c).to(torch.long)            
        d = Data(x=x, edge_index=edge_index, y=y)
        d.initial_n_instrs = torch.tensor(int(block_info["initial_n_instrs"]))
        return d

    # [in_var, out_var, commutative, opcode_0, opcode_2, ..., opcode_255] -- do we really need 255?
    
class GraphBuilder_2:
    def __init__(self,
                 class_gen=class_generator_1,
                 num_nodes = True,
                 single_push = False,
                 regression=False):
        self.class_gen = class_gen
        self.regression = regression
        self.num_nodes = num_nodes
        self.single_push = single_push
        if single_push:
            self.split_bytecode = split_bytecode
            self.vocab = vocab
            self.fvec_size = len(vocab)
        else:
            self.split_bytecode = split_bytecode_
            self.vocab = vocab_
            if num_nodes:
                self.fvec_size = len(vocab_)+1
            else:
                self.fvec_size = len(vocab_)

    def __build_features_vec(self,bytecode):
        features = [0]*self.fvec_size
        features[ self.vocab.index(bytecode) ] = 1
        return features

    def __num_features_vec(self,num):
        assert not self.single_push and self.num_nodes
        features = [0]*self.fvec_size
        features[ self.fvec_size - 1 ] = 1
        return features

    def build_graph_for_evaluation(self, bytecode):
        bytecode_sequence_orig =  self.split_bytecode(block_sfs["original_instrs"])
        bytecode_sequence = list(filter(lambda x: not x.startswith("#"),bytecode_sequence_orig))
        
        node_features_list = [ self.__build_features_vec(b) for b in bytecode_sequence ]
        edges_list = [ [i,i+1] for i in range(len(bytecode_sequence)-1) ]

        if not self.single_push and self.num_nodes:
            # add number edges
            nums = {}
            i = 0
            for b in bytecode_sequence_orig:
                if b.startswith("#"):
                    if nums.get(b) is None:
                        nums[b]=[i]
                    else:
                        nums[b].append(i)
                else:
                    i=i+1
            for n in nums:
                node_features_list.append(self.__num_features_vec(n))
                j = len(node_features_list)-1
                for k in nums[n]:
                    edges_list.append([j,k])

        x = torch.tensor(node_features_list, dtype=torch.long).to(torch.float)
        edge_index = torch.tensor(edges_list, dtype=torch.long).t()
        d = Data(x=x, edge_index=edge_index)
        return d

    def build_graph(self, block_info, block_sfs):

        # we only handle benchamrks for which a model was found
        if not block_info["model_found"]=="True":
            return None
        
        bytecode_sequence_orig =  self.split_bytecode(block_sfs["original_instrs"])
        bytecode_sequence = list(filter(lambda x: not x.startswith("#"),bytecode_sequence_orig))
        
        node_features_list = [ self.__build_features_vec(b) for b in bytecode_sequence ]
        edges_list = [ [i,i+1] for i in range(len(bytecode_sequence)-1) ]

        if not self.single_push and self.num_nodes:
            # add number edges
            nums = {}
            i = 0
            for b in bytecode_sequence_orig:
                if b.startswith("#"):
                    if nums.get(b) is None:
                        nums[b]=[i]
                    else:
                        nums[b].append(i)
                else:
                    i=i+1
            for n in nums:
                node_features_list.append(self.__num_features_vec(n))
                j = len(node_features_list)-1
                for k in nums[n]:
                    edges_list.append([j,k])

        for n in node_features_list:
            has = 0
            for i in n:
                if i>=136 and i<=167:
                    has=True
            n.append(has)
            

        # compute class
        c = self.class_gen(block_info,block_sfs)

        x = torch.tensor(node_features_list, dtype=torch.long).to(torch.float)
        edge_index = torch.tensor(edges_list, dtype=torch.long).t()

        if self.regression:
            y = torch.tensor([[c]]).to(torch.float)
        else:
            y = torch.tensor(c).to(torch.long)            

        d = Data(x=x, edge_index=edge_index, y=y)
        d.time = torch.tensor(float(block_info["solver_time_in_sec"]))
        d.gas_saved = torch.tensor(float(block_info["saved_gas"]))
        d.size_saved = torch.tensor(float(block_info["saved_size"]))
        return d




class SequenceBuilder_1:
    def __init__(self,
                 class_gen=class_generator_1,
                 encode_nums = False,
                 single_push = False,
                 regression=False):
        self.class_gen = class_gen
        self.regression = regression
        self.encode_nums = encode_nums
        self.single_push = single_push

        if single_push:
            self.split_bytecode = split_bytecode
            self.vocab = vocab.copy()
        else:
            self.split_bytecode = split_bytecode_
            self.vocab = vocab_.copy()

        if encode_nums:
            self.vocab.extend(['#','0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'])

        self.fvec_size = len(self.vocab)


#    def __build_features_vec(self,bytecode):
#        features = [0]*len(vocab)
#        features[ vocab.index(bytecode) ] = 1
#        return features

    def vocab_size(self):
        return len(self.vocab)

    def build_seq_for_evaluation(self, bytecode):
        # sequence of bytecodes to sequence of feature vectors (each vector represents a bytecode)
        bytecode_sequence_orig =  self.split_bytecode(block_sfs["original_instrs"])
        if self.encode_nums:
            bytecode_sequence = []
            for t in bytecode_sequence_orig:
                if t.startswith("#"):
                    for c in t:
                        bytecode_sequence.append(c.upper())
                else:
                    bytecode_sequence.append(t)
        else:
            bytecode_sequence = list(filter(lambda x: not x.startswith("#"),bytecode_sequence_orig))

        
        #print(bytecode_sequence)
        features_sequence = [ self.vocab.index(b) for b in bytecode_sequence ]

        x = torch.tensor(features_sequence, dtype=torch.long).to(torch.long)
        return {"data": x}

    
    def build_seq(self, block_info, block_sfs):

        # we only handle benchamrks for which a model was found
        if not block_info["model_found"]=="True":
            return None


        # sequence of bytecodes to sequence of feature vectors (each vector represents a bytecode)
        bytecode_sequence_orig =  self.split_bytecode(block_sfs["original_instrs"])
        if self.encode_nums:
            bytecode_sequence = []
            for t in bytecode_sequence_orig:
                if t.startswith("#"):
                    for c in t:
                        bytecode_sequence.append(c.upper())
                else:
                    bytecode_sequence.append(t)
        else:
            bytecode_sequence = list(filter(lambda x: not x.startswith("#"),bytecode_sequence_orig))

        
        #print(bytecode_sequence)
        features_sequence = [ self.vocab.index(b) for b in bytecode_sequence ]

        # compute class
        c = self.class_gen(block_info,block_sfs)

        x = torch.tensor(features_sequence, dtype=torch.long).to(torch.long)
        if self.regression:
            y = torch.tensor([c]).to(torch.float)
        else:
            y = torch.tensor(c).to(torch.long)            
        return {"data": x, "label": y, "info": { "size_saved": torch.tensor(float(block_info["saved_size"])), "gas_saved": torch.tensor(float(block_info["saved_gas"])), "time": torch.tensor(float(block_info["solver_time_in_sec"])), "initial_n_instrs": torch.tensor(int(block_info["initial_n_instrs"]))}}
