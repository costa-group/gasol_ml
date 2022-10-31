import os
import csv
import json
import torch
from typing import Dict
from torch_geometric.data import download_url, extract_zip, Data
from sequence_dataset import SequenceDataset
from basic_block_filters import AlwaysTrueFilter




class SequenceBasedBasicBlocksDataset(SequenceDataset):
    
    url = 'https://samir.fdi.ucm.es/download/costa_ml'
    
    def __init__(self, root, name, tag, sequence_builder, basic_block_filter=AlwaysTrueFilter()):
        self.root = root
        self.name = name
        self.tag = tag
        self.sequence_builder = sequence_builder
        self.basic_block_filter = basic_block_filter
        super().__init__()

    @property
    def raw_dir(self) -> str:
        return os.path.join(self.root, self.name, 'raw')

    @property
    def processed_dir(self) -> str:
        return os.path.join(self.root, self.name, 'processed')

    @property
    def raw_file_names(self):
        return ['csv']

    @property
    def processed_file_names(self):
        return [f'data_{self.tag}.pt']

    def download(self):
        path = download_url(f'{self.url}/{self.name}.zip', self.raw_dir)
        extract_zip(path, self.raw_dir)
        os.unlink(path)

    def process(self):
        data_list = []
        labels_list = []
        info_list = []
        csv_dir = f'{self.raw_dir}/csv'
        i=0
        for csv_filename in os.listdir(csv_dir):
            csv_filename_noext = os.path.splitext(csv_filename)[0]
            with open(f'{csv_dir}/{csv_filename}', newline='') as csvfile:
                csv_reader = csv.DictReader(csvfile)
                for block_info in csv_reader:
                    block_id = block_info['block_id']
                    with open(f'{self.raw_dir}/jsons/{csv_filename_noext}/{block_id}_input.json', 'r') as f:
                        block_sfs = json.load(f)
                        if self.basic_block_filter.inlude(block_info,block_sfs):
                            out = self.sequence_builder.build_seq(block_info,block_sfs)
                            if out != None:
                                data_list.append(out["data"])
                                labels_list.append(out["label"])
                                info_list.append(out["info"])

        torch.save((data_list, labels_list, info_list, self.sequence_builder.vocab_size()), self.processed_paths[0])

    def extract_label(d):
        return d[2]
        
