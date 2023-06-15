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

class SequenceDataset(torch.utils.data.Dataset):
    
    # all should get values ... 
    _data = []
    _labels = []
    _lengths = []
    _info = []
    vocab_size = 0   # gets value in subclass
    num_classes = 0
    
    def __init__(self):

        super().__init__()

        self._download()
        self._process()
        self._data, self._labels, self._info, self.vocab_size = torch.load(self.processed_paths[0])
        self._indices =  [ idx for idx in range(len(self._data)) ]

        # pad sequences
        self._lengths = [ len(l) for l in self._data ]
        self._data = torch.nn.utils.rnn.pad_sequence(self._data, batch_first=True)
        
        self.num_classes = max(self._labels)+1

    # def to_list(self):
    #      l = []
    #      for i in range(len(self._data)):
    #          l.append( (self._data[i],self._labels[i],self._lengths[i]) )
    #      return l
#        return [ (data,label,length) for (data,label,length) in (self._data,self.labels,self.lengths) ]
        
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
        return len(self._indices)

    def __getitem__(self, idx):
        if (isinstance(idx, (int, np.integer))
                or (isinstance(idx, Tensor) and idx.dim() == 0)
                or (isinstance(idx, np.ndarray) and np.isscalar(idx))):
            i = self._indices[idx]
            return self._data[i], self._labels[i], self._lengths[i], self._info[i]
        elif isinstance(idx, slice):
            indices = self._indices[idx]
            dataset = copy.copy(self)
            dataset._indices = indices
            return dataset
        else:
            raise Exception('unknown idx')

    def __repr__(self) -> str:
        arg_repr = str(len(self)) if len(self) > 1 else ''
        return f'{self.__class__.__name__}({arg_repr})'

    def shuffle(self):
        dataset = copy.copy(self)
        dataset._indices = [ self._indices[idx] for idx in torch.randperm(len(self._indices)) ]
        return dataset

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

