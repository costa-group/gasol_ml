# from datasets import GasolBasicBlocks, GraphBuilder_2, GraphBuilder_1, class_generator_4
# from datasets import GasolBytecodeSeq, SequenceBuilder_1, class_generator_4
# from datasets import GasolBytecodeSeq, SequenceBuilder_1, class_generator_11

from graph_based_basic_blocks_dataset import GraphBasedBasicBlocksDataset
from sfs_graph import SFSGraph
from bytecode_block_graph import BytecodeBlockGraph

from sequence_based_basic_blocks_dataset import SequenceBasedBasicBlocksDataset
from bytecode_sequence import BytecodeSequence  

from label_generators import block_label_gas_saved, block_label_size_saved, block_label_opt_ninstr, block_label_extra_instr
from basic_block_filters import MinSizeOfInputBlockFilter, OptimalModelFound
from sequence_based_block_split_dataset import SequenceBasedBasicSplitDataset
from bytecode_seq_graph import BytecodeSequenceGraph
import torch



dataset_db={};

##
##
dataset_db[0] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                            zips=['100-8-17'],
                                                            tag=tag,
                                                            sequence_builder=BytecodeSequence(label_f=block_label_size_saved,encoding='multi_push'),
                                                            basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                            )

dataset_db[1] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                            zips=['jul22-0xa-8-17'],
                                                            tag=tag,
                                                            sequence_builder=BytecodeSequence(label_f=block_label_size_saved,encoding='multi_push'),
                                                            basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                            )

dataset_db[2] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                            zips=['jul22-0xABC-8-17'],
                                                            tag=tag,
                                                            sequence_builder=BytecodeSequence(label_f=block_label_size_saved,encoding='multi_push'),
                                                            basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                            )

dataset_db[3] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                            zips=['jul22-0xb-8.17'],
                                                            tag=tag,
                                                            sequence_builder=BytecodeSequence(label_f=block_label_size_saved,encoding='multi_push'),
                                                            basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                            )

dataset_db[4] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                            zips=['jul22-0xd-8.17'],
                                                            tag=tag,
                                                            sequence_builder=BytecodeSequence(label_f=block_label_size_saved,encoding='multi_push'),
                                                            basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                            )

dataset_db[5] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                            zips=['100-8-17','jul22-0xa-8-17'],
                                                            tag=tag,
                                                            sequence_builder=BytecodeSequence(label_f=block_label_size_saved,encoding='multi_push'),
                                                            basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                            )

dataset_db[6] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                            zips=['100-8-17','jul22-0xa-8-17','jul22-0xABC-8-17'],
                                                            tag=tag,
                                                            sequence_builder=BytecodeSequence(label_f=block_label_size_saved,encoding='multi_push'),
                                                            basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                            )


##
##
##
##
dataset_db[10] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                            zips=['100-8-17'],
                                                            tag=tag,
                                                            graph_builder=BytecodeSequenceGraph(label_f=block_label_size_saved,node_features='multi_push'),
                                                            basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                            )

dataset_db[11] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                            zips=['jul22-0xa-8-17'],
                                                            tag=tag,
                                                            graph_builder=BytecodeSequenceGraph(label_f=block_label_size_saved,node_features='multi_push'),
                                                            basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                            )

dataset_db[12] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                            zips=['jul22-0xABC-8-17'],
                                                            tag=tag,
                                                            graph_builder=BytecodeSequenceGraph(label_f=block_label_size_saved,node_features='multi_push'),
                                                            basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                            )

dataset_db[13] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                            zips=['jul22-0xb-8.17'],
                                                            tag=tag,
                                                            graph_builder=BytecodeSequenceGraph(label_f=block_label_size_saved,node_features='multi_push'),
                                                            basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                            )

dataset_db[14] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                            zips=['jul22-0xd-8.17'],
                                                            tag=tag,
                                                            graph_builder=BytecodeSequenceGraph(label_f=block_label_size_saved,node_features='multi_push'),
                                                            basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                            )


##
##
dataset_db[100] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['100-8-17'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',regression=True),
                                                           basic_block_filter=OptimalModelFound() #MinSizeOfInputBlockFilter(1)
                                                           )
dataset_db[101] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['jul22-0xa-8-17'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',regression=True),
                                                           basic_block_filter=OptimalModelFound() #MinSizeOfInputBlockFilter(1)
                                                           )
dataset_db[102] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['jul22-0xABC-8-17'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',regression=True),
                                                           basic_block_filter=OptimalModelFound() #MinSizeOfInputBlockFilter(1)
                                                           )
dataset_db[103] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['jul22-0xb-8.17'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',regression=True),
                                                           basic_block_filter=OptimalModelFound() #MinSizeOfInputBlockFilter(1)
                                                           )
dataset_db[104] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['jul22-0xd-8.17'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',regression=True),
                                                           basic_block_filter=OptimalModelFound() #MinSizeOfInputBlockFilter(1)
                                                           )

dataset_db[105] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['100-8-17','jul22-0xa-8-17'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',regression=True),
                                                           basic_block_filter=OptimalModelFound() #MinSizeOfInputBlockFilter(1)
                                                           )

dataset_db[106] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['100-8-17', 'jul22-0xa-8-17', 'jul22-0xABC-8-17'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',regression=True),
                                                           basic_block_filter=OptimalModelFound() #MinSizeOfInputBlockFilter(1)
                                                           )


#
dataset_db[201] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['contract-jul22-subset1-size'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',regression=True),
                                                           basic_block_filter=OptimalModelFound() #MinSizeOfInputBlockFilter(1)
                                                           )
dataset_db[202] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['contract-jul22-subset2-size'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',regression=True),
                                                           basic_block_filter=OptimalModelFound() #MinSizeOfInputBlockFilter(1)
                                                           )
dataset_db[203] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['contract100-size'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',regression=True),
                                                           basic_block_filter=OptimalModelFound() #MinSizeOfInputBlockFilter(1)
                                                           )


dataset_db[211] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['contract-jul22-subset1-size'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',in_stk_order=True,out_stk_order=True,regression=True),
                                                           basic_block_filter=OptimalModelFound() #MinSizeOfInputBlockFilter(1)
                                                           )
dataset_db[212] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['contract-jul22-subset2-size'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',in_stk_order=True,out_stk_order=True,regression=True),
                                                           basic_block_filter=OptimalModelFound() #MinSizeOfInputBlockFilter(1)
                                                           )
dataset_db[213] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['contract100-size'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',in_stk_order=True,out_stk_order=True,regression=True),
                                                           basic_block_filter=OptimalModelFound() #MinSizeOfInputBlockFilter(1)
                                                           )

#
dataset_db[301] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['contract-jul22-subset1-gas'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',regression=True),
                                                           basic_block_filter=OptimalModelFound() #MinSizeOfInputBlockFilter(1)
                                                           )
dataset_db[302] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['contract-jul22-subset2-gas'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',regression=True),
                                                           basic_block_filter=OptimalModelFound() #MinSizeOfInputBlockFilter(1)
                                                           )
dataset_db[303] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['contract100-gas'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',regression=True),
                                                           basic_block_filter=OptimalModelFound() #MinSizeOfInputBlockFilter(1)
                                                           )

dataset_db[311] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['contract-jul22-subset1-gas'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',in_stk_order=True,out_stk_order=True,regression=True),
                                                           basic_block_filter=OptimalModelFound() #MinSizeOfInputBlockFilter(1)
                                                           )
dataset_db[312] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['contract-jul22-subset2-gas'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',in_stk_order=True,out_stk_order=True,regression=True),
                                                           basic_block_filter=OptimalModelFound() #MinSizeOfInputBlockFilter(1)
                                                           )
dataset_db[313] = lambda tag: GraphBasedBasicBlocksDataset(root='data/gasol',
                                                           zips=['contract100-gas'],
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',in_stk_order=True,out_stk_order=True,regression=True),
                                                           basic_block_filter=OptimalModelFound() #MinSizeOfInputBlockFilter(1)
                                                           )


#
dataset_db[401] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                              zips=['contract-jul22-subset1-size'],
                                                              tag=tag,
                                                              sequence_builder=BytecodeSequence(label_f=block_label_size_saved,encoding='multi_push'),
                                                              basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                              )

dataset_db[402] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                              zips=['contract-jul22-subset2-size'],
                                                              tag=tag,
                                                              sequence_builder=BytecodeSequence(label_f=block_label_size_saved,encoding='multi_push'),
                                                              basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                              )

dataset_db[403] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                              zips=['contract100-size'],
                                                              tag=tag,
                                                              sequence_builder=BytecodeSequence(label_f=block_label_size_saved,encoding='multi_push'),
                                                              basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                              )

#
dataset_db[501] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                              zips=['contract-jul22-subset1-gas'],
                                                              tag=tag,
                                                              sequence_builder=BytecodeSequence(label_f=block_label_gas_saved,encoding='multi_push'),
                                                              basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                              )

dataset_db[502] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                              zips=['contract-jul22-subset2-gas'],
                                                              tag=tag,
                                                              sequence_builder=BytecodeSequence(label_f=block_label_gas_saved,encoding='multi_push'),
                                                              basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                              )

dataset_db[503] = lambda tag: SequenceBasedBasicBlocksDataset(root='data/gasol',
                                                              zips=['contract100-gas'],
                                                              tag=tag,
                                                              sequence_builder=BytecodeSequence(label_f=block_label_gas_saved,encoding='multi_push'),
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
    return 'pyg', { 'initial_n_instrs' : d.initial_n_instrs, 'sfs_size': d.sfs_size, 'size_saved' : d.size_saved, 'min_length': d.min_length, "time": d.time }, d.x, d.y, d.edge_index, d.batch


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
    else:
        raise Exception(f'Unknown datset type: {type(dataset)}')

    return label, label_b, batch_t

