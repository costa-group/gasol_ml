# from datasets import GasolBasicBlocks, GraphBuilder_2, GraphBuilder_1, class_generator_4
# from datasets import GasolBytecodeSeq, SequenceBuilder_1, class_generator_4
# from datasets import GasolBytecodeSeq, SequenceBuilder_1, class_generator_11

from graph_based_basic_blocks_dataset import GraphBasedBasicBlocksDataset
from graph_based_basic_blocks_ws_dataset import GraphBasedBasicBlocksWSDataset
from sfs_graph import SFSGraph
from bytecode_block_graph import BytecodeBlockGraph

from sequence_based_basic_blocks_dataset import SequenceBasedBasicBlocksDataset
from bytecode_sequence import BytecodeSequence  

from label_generators import block_label_gas_saved, block_label_size_saved, block_label_opt_ninstr, block_label_extra_instr, block_opt_minlen
from basic_block_filters import MinSizeOfInputBlockFilter, OptimalModelFound
from sequence_based_block_split_dataset import SequenceBasedBasicSplitDataset
from bytecode_seq_graph import BytecodeSequenceGraph
import torch



dataset_db={};


# Datasets to be used for predicting a bound on the size of the optimal block (optimality wrt. to the block size).
#
dataset_db[211] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['block_jan_23_8_17_size','block_jul_22_8_17_size','block_march_23_8_17_size'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',regression=True),
                                                           basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                           )
dataset_db[212] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['block_jan_23_8_17_size','block_jul_22_8_17_size','block_march_23_8_17_size'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',in_stk_order=True,out_stk_order=True,regression=True),
                                                           basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                           )
dataset_db[213] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['block_jan_23_8_17_size','block_jul_22_8_17_size','block_march_23_8_17_size'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',edges='forward',in_stk_order=True,out_stk_order=True,regression=True),
                                                           basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                           )
dataset_db[214] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['block_jan_23_8_17_size','block_jul_22_8_17_size','block_march_23_8_17_size'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',edges='backwards',in_stk_order=True,out_stk_order=True,regression=True),
                                                           basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                           )
dataset_db[215] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                              zips=['block_jan_23_8_17_size','block_jul_22_8_17_size','block_march_23_8_17_size'],
                                                              tag=tag,
                                                              sequence_builder=BytecodeSequence(label_f=block_label_extra_instr,encoding='multi_push',regression=True),
                                                              basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                              )
dataset_db[2150] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                               zips=['size_tout_10_no_b'],
                                                              tag=tag,
                                                              sequence_builder=BytecodeSequence(label_f=block_label_extra_instr,encoding='multi_push',regression=True),
                                                              basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                              )
dataset_db[2151] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                               zips=['size_tout_10_no_b_aux'],
                                                              tag=tag,
                                                              sequence_builder=BytecodeSequence(label_f=block_label_extra_instr,encoding='multi_push',regression=True),
                                                              basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                              )
dataset_db[216] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                              zips=['block_jan_23_8_17_size','block_jul_22_8_17_size','block_march_23_8_17_size'],
                                                              tag=tag,
                                                              sequence_builder=BytecodeSequence(label_f=block_label_extra_instr,encoding='multi_push',encode_consts=False,regression=True),
                                                              basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                              )
dataset_db[217] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                              zips=['block_jan_23_8_17_size','block_jul_22_8_17_size','block_march_23_8_17_size'],
                                                              tag=tag,
#                                                              sequence_builder=BytecodeSequence(label_f=block_label_extra_instr,encoding='multi_push',encode_consts=False,regression=True),
                                                              sequence_builder=BytecodeSequence(label_f=block_opt_minlen,encoding='multi_push',encode_consts=False),
                                                              basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                              )


# Datasets to be used for predicting if a given block is already optimal (optimality wrt. to the block size)
#
dataset_db[221] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                              zips=['block_jan_23_8_17_size','block_jul_22_8_17_size','block_march_23_8_17_size'],
                                                              tag=tag,
                                                              sequence_builder=BytecodeSequence(label_f=block_label_size_saved,encoding='multi_push'),
                                                              basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                              )
dataset_db[2210] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                               zips=['size_tout_10_no_b'],
                                                              tag=tag,
                                                              sequence_builder=BytecodeSequence(label_f=block_label_size_saved,encoding='multi_push'),
                                                              basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                              )
dataset_db[2211] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                               zips=['size_tout_10_no_b_aux'],
                                                              tag=tag,
                                                              sequence_builder=BytecodeSequence(label_f=block_label_size_saved,encoding='multi_push'),
                                                              basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                              )

dataset_db[222] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                              zips=['block_jan_23_8_17_size','block_jul_22_8_17_size','block_march_23_8_17_size'],
                                                              tag=tag,
                                                              sequence_builder=BytecodeSequence(label_f=block_label_size_saved,encode_consts=False,encoding='multi_push'),
                                                              basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                              )

# Datasets to be used for predicting a bound on the size of the optimal block (optimality wrt. to the gas consumption)
#
dataset_db[231] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['block_jan_23_8_17_gas','block_jul_22_8_17_gas','block_march_23_8_17_gas'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',regression=True),
                                                           basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                           )
dataset_db[232] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['block_jan_23_8_17_gas','block_jul_22_8_17_gas','block_march_23_8_17_gas'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',in_stk_order=True,out_stk_order=True,regression=True),
                                                           basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                           )
dataset_db[233] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['block_jan_23_8_17_gas','block_jul_22_8_17_gas','block_march_23_8_17_gas'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',edges='forward',in_stk_order=True,out_stk_order=True,regression=True),
                                                           basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                           )
dataset_db[234] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['block_jan_23_8_17_gas','block_jul_22_8_17_gas','block_march_23_8_17_gas'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',edges='backwards',in_stk_order=True,out_stk_order=True,regression=True),
                                                           basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                           )
dataset_db[235] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                              zips=['block_jan_23_8_17_gas','block_jul_22_8_17_gas','block_march_23_8_17_gas'],
                                                              tag=tag,
                                                              sequence_builder=BytecodeSequence(label_f=block_label_extra_instr,encoding='multi_push',regression=True),
                                                              basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                              )
dataset_db[236] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                              zips=['block_jan_23_8_17_gas','block_jul_22_8_17_gas','block_march_23_8_17_gas'],
                                                              tag=tag,
                                                              sequence_builder=BytecodeSequence(label_f=block_label_extra_instr,encoding='multi_push',encode_consts=False,regression=True),
                                                              basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                              )


# Datasets to be used for predicting if a given block is already optimal (optimality wrt. to the gas consumption)
#
dataset_db[241] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                              zips=['block_jan_23_8_17_gas','block_jul_22_8_17_gas','block_march_23_8_17_gas'],
                                                              tag=tag,
                                                              sequence_builder=BytecodeSequence(label_f=block_label_gas_saved,encoding='multi_push'),
                                                              basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                              )
dataset_db[242] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                              zips=['block_jan_23_8_17_gas','block_jul_22_8_17_gas','block_march_23_8_17_gas'],
                                                              tag=tag,
                                                              sequence_builder=BytecodeSequence(label_f=block_label_gas_saved,encode_consts=False,encoding='multi_push'),
                                                              basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                              )



# Datasets to be used for predicting a bound on the size of the optimal block (optimality wrt. to the gas consumption)
#
dataset_db[251] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['blocks_alternative_gas'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',regression=True),
                                                           basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                           )
dataset_db[252] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['blocks_alternative_gas'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',in_stk_order=True,out_stk_order=True,regression=True),
                                                           basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                           )
dataset_db[253] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['blocks_alternative_gas'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',edges='forward',in_stk_order=True,out_stk_order=True,regression=True),
                                                           basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                           )
dataset_db[254] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['blocks_alternative_gas'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',edges='backwards',in_stk_order=True,out_stk_order=True,regression=True),
                                                           basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                           )
dataset_db[255] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                              zips=['blocks_alternative_gas'],
                                                              tag=tag,
                                                              sequence_builder=BytecodeSequence(label_f=block_label_extra_instr,encoding='multi_push',regression=True),
                                                              basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                              )
dataset_db[2551] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                              zips=['gas_tout_10_no_b_aux'],
                                                              tag=tag,
                                                              sequence_builder=BytecodeSequence(label_f=block_label_extra_instr,encoding='multi_push',regression=True),
                                                              basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                              )
dataset_db[256] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                              zips=['blocks_alternative_gas'],
                                                              tag=tag,
                                                              sequence_builder=BytecodeSequence(label_f=block_label_extra_instr,encoding='multi_push',encode_consts=False,regression=True),
                                                              basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                              )


# Datasets to be used for predicting if a given block is already optimal (optimality wrt. to the gas consumption)
#
dataset_db[261] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                              zips=['blocks_alternative_gas'],
                                                              tag=tag,
                                                              sequence_builder=BytecodeSequence(label_f=block_label_gas_saved,encoding='multi_push'),
                                                              basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                              )
dataset_db[2611] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                              zips=['gas_tout_10_no_b_aux'],
                                                              tag=tag,
                                                              sequence_builder=BytecodeSequence(label_f=block_label_gas_saved,encoding='multi_push'),
                                                              basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                              )
dataset_db[262] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                              zips=['blocks_alternative_gas'],
                                                              tag=tag,
                                                              sequence_builder=BytecodeSequence(label_f=block_label_gas_saved,encode_consts=False,encoding='multi_push'),
                                                              basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                              )




#
dataset_db[1000] = lambda tag: SequenceBasedBasicSplitDataset(root='data/gasol',
                                                            zips=['hierarchy'],
                                                            tag=tag
                                                        )



#

#
#
def load_dataset(id):
    print(f'Loading dataset with id {id}')
    ds = dataset_db[id](id)
    return ds


# pyg graphs
#
def label_of_pyg_graph(d):
    return d[3]


def label_of_pyg_graph_for_balancing(d):
    return d.y.item()

def batch_transformer_for_pyg_graph(d):
    # TODO: remove size_save, it is not used anywhere
    return 'pyg', { 'initial_n_instrs' : d.initial_n_instrs, 'sfs_size': d.sfs_size, 'size_saved' : d.size_saved, 'min_length': d.min_length, "time": d.time}, d.x, d.y, d.edge_index, d.batch

def batch_transformer_for_pyg_ws_graph(d):
    # TODO: remove size_save, it is not used anywhere
    return 'pyg', { 'initial_n_instrs' : d.initial_n_instrs, 'sfs_size': d.sfs_size, 'size_saved' : d.size_saved, 'min_length': d.min_length, "time": d.time, "seq": d.seq if d.seq is not None else None}, d.x, d.y, d.edge_index, d.batch


# sequence of type 1
#
def label_of_sequence_1(d):
    return d[3] 

def label_of_sequence_11(d):
    def f(x):
        return [0.0,1.0] if x==1 else [1.0,0]

    return torch.tensor([ f(x) for x in d[3] ])

def label_of_sequence_1_for_balancing(d):
    return d[1]

def batch_transformer_for_sequence_1(d):
    seq_tensor = d[0]
    seq_labels = d[1]
    seq_lengths = d[2]
    seq_info = d[3]
    
    seq_lengths, perm_idx = seq_lengths.sort(0, descending=True)
    seq_tensor = seq_tensor[perm_idx]
    seq_labels = seq_labels[perm_idx]

    for key in seq_info:
        seq_info[key] = seq_info[key][perm_idx]
        
    return 'seq', seq_info, seq_tensor, seq_labels, seq_lengths


def get_data_manipulators(dataset):
    if isinstance(dataset,GraphBasedBasicBlocksDataset):
        label = label_of_pyg_graph
        label_b = label_of_pyg_graph_for_balancing
        batch_t = batch_transformer_for_pyg_graph
    elif isinstance(dataset,SequenceBasedBasicBlocksDataset):
        label = label_of_sequence_1
        label_b = label_of_sequence_1_for_balancing
        batch_t = batch_transformer_for_sequence_1
    elif isinstance(dataset,GraphBasedBasicBlocksWSDataset):
        label = label_of_pyg_graph
        label_b = label_of_pyg_graph_for_balancing
        batch_t = batch_transformer_for_pyg_ws_graph
    else:
        raise Exception(f'Unknown datset type: {type(dataset)}')

    return label, label_b, batch_t

