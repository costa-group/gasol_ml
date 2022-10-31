
import torch
from torch_geometric.data import Data
import networkx as nx

# from opcodes import vocab  as single_push_vocab, vocab_ as multi_push_vocab, is_push_instr, is_memory_instr, is_store_instr
from opcodes import vocab as single_push_vocab, vocab_ as multi_push_vocab, is_push_instr, is_memory_read_instr, is_memory_write_instr, is_store_read_instr, is_store_write_instr, is_swap_instr, is_dup_instr, is_comm_instr, split_bytecode_


# one-hot vector
#
#  [in_var, out_var, commutative, opcode_0, opcode_1, ..., ...] 
#
#  - valid input: "empty", "in_var", "out_var" or a dictionary that corresponds to an instruction from the sfs
#  - all PUSHi are considered PUSH
#  - call with "empty" to get an empty vector
#
def node_features_iovar_com_single_push(node_info):

    vocab = single_push_vocab

    v = [0]*(len(vocab)+3) # size of the vocabulary + 3 for in/out/comm

    if node_info == "empty":
        pass
    elif node_info == "in_var":
        v[0] = 1
    elif node_info == "out_var":
        v[1] = 1
    elif type(node_info) == dict: #
        if node_info["commutative"]:
            v[ 2 ] = 1
        v[ vocab.index(node_info["disasm"])+3 ] = 1
    else:
        raise Exception(f'Invalid value for node_info: {node_info}')
    
    return v

# one-hot vector
#
#  [in_var, out_var, commutative, opcode_0, opcode_1, ..., ...] 
#
#  - valid input: "empty", "in_var", "out_var" or a dictionary that corresponds to an instruction from the sfs
#  - PUSHi treated as different instructions
#  - call with "empty" to get an empty vector
#
def node_features_iovar_com_multi_push(node_info):

    vocab = multi_push_vocab

    v = [0]*(len(vocab)+3) # size of the vocabulary + 3 for in/out/comm

    if node_info == "empty":
        pass
    elif node_info == "in_var":
        v[0] = 1
    elif node_info == "out_var":
        v[1] = 1
    elif type(node_info) == dict: #
        if node_info["commutative"]:
            v[ 2 ] = 1
        i = node_info["disasm"];
        if i == "PUSH":
            size = node_info["size"]-1
            assert size >=1 and size <= 32
            i = f'{i}{size}'
        v[ vocab.index(i)+3 ] = 1
    else:
        raise Exception(f'Invalid value for node_info: {node_info}')

    return v

# one-hot vector:
#
#  [in_var, out_var, commutative, mem_read_inst, mem_write_instr, store_read_inst, store_write_instr, push_inst, other_inst]
#
#  - valid input: "empty", "in_var", "out_var" or a dictionary that corresponds to an instruction from the sfs
#  - we just distinguish the class of the instruction push/memory/store/other (swap and dup never appear since we are using the sfs)
#  - call with "empty" to get an empty vector
#  
def node_feature_iovar_com_category(node_info):
    v = [0]*9

    if node_info == "empty":
        pass
    elif node_info == "in_var":
        v[0] = 1
    elif node_info == "out_var":
        v[1] = 1
    elif type(node_info) == dict: #
        if node_info["commutative"]:
            v[2] = 1
        elif is_memory_read_instr(node_info["disasm"]):
            v[3] = 1
        elif is_memory_write_instr(node_info["disasm"]):
            v[4] = 1
        elif is_store_read_instr(node_info["disasm"]):
            v[5] = 1
        elif is_store_write_instr(node_info["disasm"]):
            v[6] = 1
        elif is_push_instr(node_info["disasm"]):
            v[7] = 1
        else:
            v[8] = 1
    else:
        raise Exception(f'Invalid value for node_info: {node_info}')

    return v





# builds a graph from the SFS
#
#
class SFSGraph:
    
    def __init__(self,
                 in_stk_order=False,    # connect in_stk nodes with edges
                 out_stk_order=False,   # connect out_stk nodes with edges
                 add_const_nodes=True, # add nodes for constants (the input to push, several push might share the same number)
                 add_dep_edges=True,   # add egdes between instruction that are declared dependent in the sfs
                 node_features='category', #  node features builder (single_push, multi_push, category)
                 label_f=None,         # function for calculating the label
                 edges='both',      # can be 'forward', 'backwards' or 'both'                 
                 regression=False):    # if it is a regression problem (should be eliminated at some point, it is ugly)

        if node_features == 'single_push':
            self.node_features_f = node_features_iovar_com_single_push
        elif node_features == 'multi_push':
            self.node_features_f = node_features_iovar_com_multi_push
        elif node_features == 'category':
            self.node_features_f = node_feature_iovar_com_category
        else:
            raise Exception(f"Invalid value for node_features: {node_features}")

        self.in_stk_order = in_stk_order
        self.out_stk_order = out_stk_order
        self.add_const_nodes = add_const_nodes
        self.add_dep_edges = add_dep_edges
        self.label_f = label_f
        self.edges = edges
        self.regression = regression


    def build_graph_from_sfs(self, block_sfs):
 
        number_of_nodes = 0           # node identifiers should start from zero and be consecutive
        nodes_map = {}                # s(i) -> idx, "PUSH_0" -> idx, ...
        edges_list = []               # [ [src,tgt],.... ]
        node_features_list = []       # the i-th element is the feasters vector of node i
        inverse_map = {}              # maps the output variable of an instructions to its 'id', used to avoid temporal variable nodes 


        # node 0/1 is an auxiliary node connected to all input/output
        node_features_list.append(self.node_features_f("empty"))
        node_features_list.append(self.node_features_f("empty"))
        number_of_nodes += 2
        
        # create the the input variable nodes 
        for node_id in block_sfs["src_ws"]:
            if not node_id in nodes_map:  # this check is because the data might have some duplicates
                nodes_map[node_id] = number_of_nodes
                edges_list.append( [0, number_of_nodes] )
                number_of_nodes = number_of_nodes + 1
                node_features_list.append(self.node_features_f("in_var"))
            else:
                raise Exception('duplicates in the input stack')

        # connect all input variables (trying to make order important ...)
        if self.in_stk_order:
            for i in range(number_of_nodes-1):
                edges_list.append( [i,i+1] )

        # create output variable nodes (one for each position in the output stack)
        for i in range(len(block_sfs["tgt_ws"])):
            nodes_map[f"o({i})"] = number_of_nodes
            edges_list.append( [number_of_nodes,1] )
            number_of_nodes = number_of_nodes + 1
            node_features_list.append(self.node_features_f("out_var"))

        # connect all output variables (trying to make order important ...)
        if self.out_stk_order:
            for i in range(len(block_sfs["tgt_ws"])-1):
                edges_list.append( [nodes_map[f"o({i})"],nodes_map[f"o({i+1})"]] )

        # add instruction nodes
        for instr in block_sfs["user_instrs"]:
            instr_id = instr["id"]
            if not instr_id in nodes_map:  # this check is becuase the data might have some duplicates
                nodes_map[instr_id] = number_of_nodes
                number_of_nodes = number_of_nodes + 1
                node_features_list.append(self.node_features_f(instr))

        # construct a map from temporal variables to their respective instructions
        for instr in block_sfs["user_instrs"]:
            out_vars = instr["outpt_sk"]
            if len(out_vars) > 0:
                if len(out_vars) == 1:
                    inverse_map[out_vars[0]] = nodes_map[instr["id"]]
                else:
                    raise Exception('outpt_sk is of size >1')

        # construct edges from instructions/in-vars to output variables        
        for i in range(len(block_sfs["tgt_ws"])):
            out_var = block_sfs["tgt_ws"][i]
            if nodes_map.get(out_var) is not None:
                edges_list.append( [nodes_map[out_var], nodes_map[f"o({i})"]] )    # we found an input variables in the out stack, create corresponding edge
            else:
                edges_list.append( [inverse_map[out_var], nodes_map[f"o({i})"]] )  # we found temporal variable in the out stack, create corresponding edge

        # construct edges from in-vars/instructions to to instructions
        for instr in block_sfs["user_instrs"]:
            node_id = nodes_map[instr["id"]]
            for in_var in instr["inpt_sk"]:
                if nodes_map.get(in_var) is not None:
                    edges_list.append( [nodes_map[in_var],node_id] )     # we found an input variables in the instruction's input, create corresponding edge
                else:
                    edges_list.append( [inverse_map[in_var],node_id] )   # we found temporal variable in the instruction's input, create corresponding edge
 

        if self.add_const_nodes:

            # extend all featues vectors, adding zero at the end
            for fv in node_features_list:
                fv.append(0)

            # create a map from constants to lists of their corresponding instructions
            nums = {}
            i = 0
            for instr in block_sfs["user_instrs"]:
                if instr.get("value") is not None:
                    b = instr["value"][0]
                    if nums.get(b) is None: # constant that we have not seen before
                        nums[b]=[ nodes_map[instr["id"]] ]
                    else:
                        nums[b].append( nodes_map[instr["id"]] ) # the constant is already in th etable

            # build nodes for constants and connect them to their corresponding (PUSH) instructions
            for n in nums:
                features = self.node_features_f("empty")
                features.append(1)
                node_features_list.append(features)
                this_node_id = number_of_nodes
                number_of_nodes = number_of_nodes + 1
                edges_list.append([0,this_node_id])
                for k in nums[n]:
                    edges_list.append([this_node_id,k])

#        print(f'> {len(block_sfs["tgt_ws"])}')
        # if len(block_sfs["tgt_ws"]) > 0 and len(block_sfs["src_ws"])>0:
        #     G = nx.Graph(edges_list)
        #     d1 = nx.algorithms.connectivity.connectivity.local_edge_connectivity(G,0,1)
        #     d2 = nx.algorithms.connectivity.connectivity.local_node_connectivity(G,0,1)
        # else:
        #     d1 = d2 = 0
        # n = len(node_features_list)
        # for v in node_features_list:
        #     # v.append(n)
        #     v.append(d1) 
        #     v.append(d2)            

        # add dependency edges
        if self.add_dep_edges:
            for e in block_sfs["storage_dependences"]:
                edges_list.append([nodes_map[e[0]],nodes_map[e[1]]])
            for e in block_sfs["memory_dependences"]:
                edges_list.append([nodes_map[e[0]],nodes_map[e[1]]])

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

        # ignore those with empty sfs -- should have been eliminated earlier
        if len(block_sfs["user_instrs"])==0:
            return None

        x, edge_index = self.build_graph_from_sfs(block_sfs)
        
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

        return d

