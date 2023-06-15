import os
import csv
import json
import torch
from typing import Dict
from torch_geometric.data import download_url, extract_zip, Data
from sequence_dataset import SequenceDataset
from basic_block_filters import AlwaysTrueFilter
from bytecode_sequence import BytecodeSequence
from gasol_env import GasolEnv


class SequenceBasedBasicSplitDataset(SequenceDataset):
    
    url = 'https://samir.fdi.ucm.es/download/costa_ml'
    
    def __init__(self, root, name, tag):
        self.root = root
        self.name = name
        self.tag = tag
        self.sequence_builder = BytecodeSequence(encoding = 'multi_push')
        super().__init__()

    @property
    def raw_dir(self) -> str:
        return os.path.join(self.root, self.name, 'raw')

    @property
    def processed_dir(self) -> str:
        return os.path.join(self.root, self.name, 'processed')

    @property
    def raw_file_names(self):
        return ['hierarchy.txt']

    @property
    def processed_file_names(self):
        return [f'data_{self.tag}.pt']

    def download(self):
        path = download_url(f'{self.url}/{self.name}.zip', self.raw_dir)
        extract_zip(path, self.raw_dir)
        os.unlink(path)

    def process(self):
        print("Loading environment ...")
        env = GasolEnv(source_path=self.raw_dir)
        print("Constructing all sequences ...")
        env.calculate_state_values(gen_sequences=True)
        ts = len(env.sequences_store)
        print(f'Encoding {ts} sequences ...')
        
        
        data_list = []
        labels_list = []
        info_list = []

        i = 0
        for (left,right,value,action) in env.sequences_store:
            print(f'encoding sequence {i} out of {ts}')
            i += 1
            left_s = self.sequence_builder.build_seq_from_bytecode( ' '.join(left) )
            right_s = self.sequence_builder.build_seq_from_bytecode( ' '.join(right) )
            seq = []
            seq.extend(left_s)
            seq.append(1) # we use 1 as a separator
            seq.extend(right_s)
            x = torch.tensor(seq, dtype=torch.long)
            y = torch.tensor(action, dtype=torch.long)
            data_list.append(x)
            labels_list.append(y)
            info_list.append({})

        torch.save((data_list, labels_list, info_list, self.sequence_builder.vocab_size()+1), self.processed_paths[0])

    def extract_label(d):
        return d[2]
        
