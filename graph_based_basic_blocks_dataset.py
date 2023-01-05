import os
import csv
import json
import torch
from torch_geometric.data import InMemoryDataset, download_url, extract_zip, Data
from basic_block_filters import AlwaysTrueFilter

# Dataset that is based on pytorch geometring InMemoryDataset, it stores graphs
# and their classes
#
class GraphBasedBasicBlocksDataset(InMemoryDataset):

    url = 'https://samir.fdi.ucm.es/download/costa_ml'
    
    def __init__(self, root, zips, tag, graph_builder,basic_block_filter=AlwaysTrueFilter()):
        self.zips = zips
        self.tag = tag
        self.graph_builder = graph_builder
        self.basic_block_filter = basic_block_filter
        super().__init__(root)
        self.data, self.slices = torch.load(self.processed_paths[0])

    @property
    def raw_dir(self) -> str:
        return os.path.join(self.root, 'raw')

    @property
    def processed_dir(self) -> str:
        return os.path.join(self.root, 'processed')

    @property
    def raw_file_names(self):
        return self.zips

    @property
    def processed_file_names(self):
        return [f'data_{self.tag}.pt']

    def download(self):
        for z in self.zips:
            if not os.path.exists(f'{self.raw_dir}/{z}'):
                path = download_url(f'{self.url}/{z}.zip', self.raw_dir)
                extract_zip(path, f'{self.raw_dir}/{z}')
                os.unlink(path)
            else:
                print(f'Skipping download of {self.raw_dir}/{z}, already available.')

    def process(self):
        # Read data into huge `Data` list.

        i=0
        data_list = []
        for d in self.zips:
            csv_dir = f'{self.raw_dir}/{d}/csv'
            json_dir = f'{self.raw_dir}/{d}/jsons'
            for csv_filename in os.listdir(csv_dir):
                csv_filename_noext = os.path.splitext(csv_filename)[0]
                with open(f'{csv_dir}/{csv_filename}', newline='') as csvfile:
                    csv_reader = csv.DictReader(csvfile)
                    for block_info in csv_reader:
                        block_id = block_info['block_id']
                        with open(f'{json_dir}/{csv_filename_noext}/{block_id}_input.json', 'r') as f:
                            block_sfs = json.load(f)
                            if self.basic_block_filter.include(block_info,block_sfs):
                                data = self.graph_builder.build_graph(block_info,block_sfs)
                                if data is not None:
                                    for d in data:
                                        data_list.append(d)

        data, slices = self.collate(data_list)

        torch.save((data, slices), self.processed_paths[0])
