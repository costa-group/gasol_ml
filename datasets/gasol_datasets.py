import os
import csv
import json
import torch
from typing import Dict
from torch_geometric.data import InMemoryDataset, download_url, extract_zip, Data
from .graph_builders import GraphBuilder_1, SequenceBuilder_1
from .CustomDataSets import SeqDataSet

# Questions to alejandor/pablo:
#
# - Is it possible that values appear in tgt_ws, inpt_sk, and outpt_sk?
# - there are some graphs with no edges, I

def select_sample(block_info: Dict, block_sfs: Dict, data: Data) -> bool:
    return data is not None and len(data.edge_index) == 2 and len(data.edge_index[0]) > 0 # recall that edges list is transposed

def select_sample_1(block_info: Dict, block_sfs: Dict, data: Data) -> bool:
    # if data is not None:
    #     print(len(data.edge_index))
    return data is not None and len(data.edge_index) == 2 and len(data.edge_index[0]) > 0 # recall that edges list is transposed


# dataset that is based on pytorch geometring InMemoryDataset, it stores graphs
# and their classes
#
class GasolBasicBlocks(InMemoryDataset):

    url = 'https://samir.fdi.ucm.es/download/costa_ml'
    
    def __init__(self, root, name, tag=0, graph_builder=GraphBuilder_1(), transform=None, pre_transform=None, pre_filter=None):
        self.name = name
        self.tag = tag
        self.graph_builder = graph_builder
        super().__init__(root, transform, pre_transform, pre_filter)
        self.data, self.slices = torch.load(self.processed_paths[0])

    @property
    def raw_dir(self) -> str:
        return os.path.join(self.root, self.name, 'raw')

    @property
    def processed_dir(self) -> str:
        return os.path.join(self.root, self.name, 'processed')

    @property
    def raw_file_names(self):
        return ['README']

    @property
    def processed_file_names(self):
        return [f'data_{self.tag}.pt']

    def download(self):
        path = download_url(f'{self.url}/{self.name}.zip', self.raw_dir)
        extract_zip(path, self.raw_dir)
        os.unlink(path)

    def process(self):
        # Read data into huge `Data` list.

        i=0
        data_list = []
        csv_dir = f'{self.raw_dir}/csv'
        for csv_filename in os.listdir(csv_dir):
            csv_filename_noext = os.path.splitext(csv_filename)[0]
            with open(f'{csv_dir}/{csv_filename}', newline='') as csvfile:
                csv_reader = csv.DictReader(csvfile)
                for block_info in csv_reader:
                    block_id = block_info['block_id']
                    with open(f'{self.raw_dir}/jsons/{csv_filename_noext}/{block_id}_input.json', 'r') as f:
                        block_sfs = json.load(f)
                        data = self.graph_builder.build_graph(block_info,block_sfs)
                        # remove empty graphs as well -- check with Alejandro why we have empty graphs?
                        if select_sample_1(block_info, block_sfs, data):
                            data_list.append(data)
                        
        if self.pre_filter is not None:
            data_list = [data for data in data_list if self.pre_filter(data)]

        if self.pre_transform is not None:
            data_list = [self.pre_transform(data) for data in data_list]

        data, slices = self.collate(data_list)

                
        torch.save((data, slices), self.processed_paths[0])


# dataset that is based on pytorch geometring InMemoryDataset, it stores graphs
# and their classes
class GasolBytecodeSeq(SeqDataSet):
    
    url = 'https://samir.fdi.ucm.es/download/costa_ml'
    
    def __init__(self, root, name, tag=0, sequence_builder=SequenceBuilder_1()):
        self.root = root
        self.name = name
        self.tag = tag
        self.sequence_builder = sequence_builder
        super().__init__()

    @property
    def raw_dir(self) -> str:
        return os.path.join(self.root, self.name, 'raw')

    @property
    def processed_dir(self) -> str:
        return os.path.join(self.root, self.name, 'processed')

    @property
    def raw_file_names(self):
        return ['README']

    @property
    def processed_file_names(self):
        return [f'data_{self.tag}.pt']

    def download(self):
        path = download_url(f'{self.url}/{self.name}.zip', self.raw_dir)
        extract_zip(path, self.raw_dir)
        os.unlink(path)

    def __build_seq(self, block_info, block_sfs):

        # we only handle benchamrks for which a model was found
        if not block_info["model_found"]=="True":
            return None

        bytecode_sequence = split_bytecode(block_sfs["original_instrs"])
        features_sequence = [ self.__build_features_vec(b) for b in bytecode_sequence ]

        # compute class
        c = self.class_gen(block_info,block_sfs)

        x = torch.tensor(node_features_list, dtype=torch.long).to(torch.float)
        edge_index = torch.tensor(edges_list, dtype=torch.long).t()
        y = torch.tensor(c,dtype=torch.long)
        d = Data(x=x, edge_index=edge_index, y=y)
        return d

    def process(self):
        data_list = []
        labels_list = []
        csv_dir = f'{self.raw_dir}/csv'
        for csv_filename in os.listdir(csv_dir):
            csv_filename_noext = os.path.splitext(csv_filename)[0]
            with open(f'{csv_dir}/{csv_filename}', newline='') as csvfile:
                csv_reader = csv.DictReader(csvfile)
                for block_info in csv_reader:
                    block_id = block_info['block_id']
                    with open(f'{self.raw_dir}/jsons/{csv_filename_noext}/{block_id}_input.json', 'r') as f:
                        block_sfs = json.load(f)
                        out = self.sequence_builder.build_seq(block_info,block_sfs)
                        if out != None and len(out["data"]) > 0:
                            data_list.append(out["data"])
                            labels_list.append(out["label"])

        torch.save((data_list, labels_list, self.sequence_builder.vocab_size()), self.processed_paths[0])
