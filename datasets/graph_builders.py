
import torch
from torch_geometric.data import Data
from .opcodes import *

class GraphBuilder_1:    
    # def __init__(self):
        
    # is_in_var, is_out_var, is_tmp_var, is_instr, is_commutative, is_memory_inst, is_store_inst, is_push_instr 
    def __empty_featrues_vector(self):
        return [0]*8

    # 0,1,2,3,4,5,more
    def __empty_classes_vector(self):
        return [0]*6

    def build_graph(self, block_info, block_sfs):

        # we only handle benchamrks for which we found a model
        if not block_info["model_found"]=="True":
            return None
        
        number_of_nodes = 0
        nodes_map = {}
        edges_list = []
        node_features_list = []
        classes = []
        
        # add the input variable nodes to nodes_map, and also store their indexes range
        features = self.__empty_featrues_vector()
        features[0] = 1
        for node_id in block_sfs["src_ws"]:
            if not node_id in nodes_map:  # this check is becuase the data might have some duplicates
                nodes_map[node_id] = number_of_nodes
                number_of_nodes = number_of_nodes + 1
                node_features_list.append(features)
            
        # add the output variable nodes to nodes_map, and also store their indexes range
        features = self.__empty_featrues_vector()
        features[1] = 1
        for node_id in block_sfs["tgt_ws"]:
            if not node_id in nodes_map:  # this check is becuase the data might have some duplicates
                nodes_map[node_id] = number_of_nodes
                number_of_nodes = number_of_nodes + 1
                node_features_list.append(features)
                
        # add the temporal variable nodes to nodes_map, and also store their indexes range
        features = self.__empty_featrues_vector()
        features[2] = 1
        for node_id in block_sfs["vars"]:
            if not node_id in nodes_map:  # this check is becuase the data might have some duplicates
                nodes_map[node_id] = number_of_nodes
                number_of_nodes = number_of_nodes + 1
                last_temp_var = number_of_nodes-1
                node_features_list.append(features)

        # add the instructions nodes
        for instr in block_sfs["user_instrs"]:
            features = self.__empty_featrues_vector()
            features[3] = 1
            instr_id = instr["id"]
            if not instr_id in nodes_map:  # this check is becuase the data might have some duplicates
                nodes_map[instr_id] = number_of_nodes
                number_of_nodes = number_of_nodes + 1
                if instr["commutative"]:
                    features[4] = 1
                if is_memory_instr(instr["disasm"]):
                    features[5] = 1
                elif is_store_instr(instr["disasm"]):
                    features[6] = 1
                elif is_push_instr(instr["disasm"]):
                    features[7] = 1
                node_features_list.append(features)

        # construct edges        
        for instr in block_sfs["user_instrs"]:
            node_id = nodes_map[instr["id"]]
            for in_var in instr["inpt_sk"]:
                edges_list.append( [nodes_map[in_var],node_id] )
            for out_var in instr["outpt_sk"]:
                edges_list.append( [node_id,nodes_map[out_var]] )


        # compute class -
        #
        # - a number between 0 and 6
        # - i means i instructions where added (optimized wrt sfs size)
        # - 5 means >= 5

        c = int(float(block_info["optimized_n_instrs"]))-len(block_sfs["user_instrs"])
        c = min(20,c)
        
        x = torch.tensor(node_features_list, dtype=torch.long).to(torch.float)
        edge_index = torch.tensor(edges_list, dtype=torch.long).t()
        y = torch.tensor(c,dtype=torch.long)

        return Data(x=x, edge_index=edge_index, y=y)
