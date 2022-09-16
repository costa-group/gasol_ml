import copy
import os.path as osp
import re
import sys
import warnings
from collections.abc import Sequence
from typing import Any, Callable, List, Optional, Tuple, Union

import numpy as np
import torch.utils.data
from torch import Tensor
import torch

from torch_geometric.data import Data
from torch_geometric.data.makedirs import makedirs

def files_exist(files):
    return len(files) != 0 and all([osp.exists(f) for f in files])

class CustomDataSet(torch.utils.data.Dataset):

    def __init__(self):
        super().__init__()

        self.data = []
        self.labels = []
        self._download()
        self._process()

        self.data, self.labels = torch.load(self.processed_paths[0])

        # pad sequences
        self.lengths = [ len(l) for l in self.data ]
        self.data = torch.nn.utils.rnn.pad_sequence(self.data, batch_first=True)
        self.input_size = len(self.data[0][0])
        self.num_classes = max(self.labels)+1

    def to_list(self):
         l = []
         for i in range(len(self.data)):
             l.append( (self.data[i],self.labels[i],self.lengths[i]) )
         return l
#        return [ (data,label,length) for (data,label,length) in (self.data,self.labels,self.lengths) ]
        
    def _download(self):
        if files_exist(self.raw_paths):  
            return

        makedirs(self.raw_dir)
        self.download()

    def _process(self):

        if files_exist(self.processed_paths):  # pragma: no cover
            return

        print('Processing...', file=sys.stderr)

        makedirs(self.processed_dir)
        self.process()

        print('Done!', file=sys.stderr)
        
    def __len__(self):
        return len(self.data)

    def __getitem__(self, idx):
        if torch.is_tensor(idx):
            idx = idx.tolist()

        return self.data[idx], self.labels[idx], self.lengths[idx]

    @property
    def raw_paths(self) -> List[str]:
        r"""The absolute filepaths that must be present in order to skip
        downloading."""
        files = self.raw_file_names
        return [osp.join(self.raw_dir, f) for f in files]

    @property
    def processed_paths(self) -> List[str]:
        files = self.processed_file_names
        return [osp.join(self.processed_dir, f) for f in files]

    @property
    def raw_dir(self) -> str:
        raise Exception('raw_dir not defined')

    @property
    def processed_dir(self) -> str:
        raise Exception('processed_dir not defined')

    @property
    def raw_file_names(self):
        raise Exception('raw_file_names not defined')

    @property
    def processed_file_names(self):
        raise Exception('processed_file_names not defined')

