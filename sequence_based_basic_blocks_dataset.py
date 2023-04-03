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
    
    def __init__(self, root, zips, tag, sequence_builder, basic_block_filter=AlwaysTrueFilter()):
        self.root = root
        self.zips = zips
        self.tag = tag
        self.sequence_builder = sequence_builder
        self.basic_block_filter = basic_block_filter
        super().__init__()

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
        data_list = []
        labels_list = []
        info_list = []
        csv_dir = f'{self.raw_dir}/csv'
        i=j=k=0
        for d in self.zips:
            csv_dir = f'{self.raw_dir}/{d}/csv'
            json_dir = f'{self.raw_dir}/{d}/jsons'
            for csv_filename in os.listdir(csv_dir):
                csv_filename_noext = os.path.splitext(csv_filename)[0]
                with open(f'{csv_dir}/{csv_filename}', newline='') as csvfile:
                    csv_reader = csv.DictReader(csvfile)
                    for block_info in csv_reader:
                        block_id = block_info['block_id']
                        try:
                            with open(f'{json_dir}/{csv_filename_noext}/{block_id}_input.json', 'r') as f:
                                i += 1
                                if not block_info["model_found"]=="True":
                                    k += 1
                                block_sfs = json.load(f)
                                if self.basic_block_filter.include(block_info,block_sfs):
                                    out = self.sequence_builder.build_seq(block_info,block_sfs)
                                    if out != None:
                                        j += 1
                                        for o in out:
                                            data_list.append(o["data"])
                                            labels_list.append(o["label"])
                                            info_list.append(o["info"])
                        except Exception as e:
                            print(block_id)
                                            
        torch.save((data_list, labels_list, info_list, self.sequence_builder.vocab_size()), self.processed_paths[0])
        print(i,":",j,":",k)
    def extract_label(d):
        return d[2]
        
