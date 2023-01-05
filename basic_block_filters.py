from typing import Dict

# block_info and block_sfs are of type Dict

class AlwaysTrueFilter:
    def inlude(self,block_info, block_sfs):
        return True


class MinSizeOfInputBlockFilter:
    def __init__(self,min_size):
        self.min_size = min_size

    def inlude(self,block_info, block_sfs):
        return float(block_info["initial_n_instrs"]) >= self.min_size # using float because it appears as float in the data files


class OptimalModelFound:
    def __init__(self):
        pass
    
    def include(self,block_info, block_sfs):
        return block_info["shown_optimal"] == "True" # using float because it appears as float in the data files
