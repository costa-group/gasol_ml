import os
import csv
import json
import torch
from torch_geometric.data import InMemoryDataset, download_url, extract_zip, Data
from .graph_builders import GraphBuilder_1

class GasolBasicBlocks(InMemoryDataset):

    url = 'https://samir.fdi.ucm.es/download/costa_ml'
    
    def __init__(self, root, name, graph_builder=GraphBuilder_1(), transform=None, pre_transform=None, pre_filter=None):
        self.name = name
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
        return ['data.pt']

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
                        if (data and len(data.edge_index)>0): 
                            data_list.append(data)
                        
            
        if self.pre_filter is not None:
            data_list = [data for data in data_list if self.pre_filter(data)]

        if self.pre_transform is not None:
            data_list = [self.pre_transform(data) for data in data_list]

        data, slices = self.collate(data_list)
        
        torch.save((data, slices), self.processed_paths[0])


