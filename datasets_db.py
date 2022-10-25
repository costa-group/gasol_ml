# from datasets import GasolBasicBlocks, GraphBuilder_2, GraphBuilder_1, class_generator_4
# from datasets import GasolBytecodeSeq, SequenceBuilder_1, class_generator_4
# from datasets import GasolBytecodeSeq, SequenceBuilder_1, class_generator_11

from graph_based_basic_blocks_dataset import GraphBasedBasicBlocksDataset
from sfs_graph import SFSGraph
from bytecode_block_graph import BytecodeBlockGraph

from sequence_based_basic_blocks_dataset import SequenceBasedBasicBlocksDataset
from bytecode_sequence import BytecodeSequence  

from label_generators import block_label_gas_saved, block_label_size_saved, block_label_opt_ninstr
from basic_block_filters import MinSizeOfInputBlockFilter

dataset_db={};

##
dataset_db[0] = lambda tag: GraphBasedBasicBlocksDataset(root='data',
                                                         name='bex_size',
                                                         tag=tag,
                                                         graph_builder=BytecodeBlockGraph(label_f=block_label_size_saved, node_features='multi_push'),
                                                         basic_block_filter=MinSizeOfInputBlockFilter(5)
                                                        )
dataset_db[1] = lambda tag: GraphBasedBasicBlocksDataset(root='data',
                                                         name='rl_size_opt',
                                                         tag=tag,
                                                         graph_builder=BytecodeBlockGraph(label_f=block_label_size_saved, node_features='multi_push'),
                                                         basic_block_filter=MinSizeOfInputBlockFilter(5)
                                                        )

##
dataset_db[2] = lambda tag: GraphBasedBasicBlocksDataset(root='data',
                                                         name='bex_size',
                                                         tag=tag,
                                                         graph_builder=BytecodeBlockGraph(label_f=block_label_size_saved, node_features='single_push'),
                                                         basic_block_filter=MinSizeOfInputBlockFilter(5)
                                                        )
dataset_db[3] = lambda tag: GraphBasedBasicBlocksDataset(root='data',
                                                         name='oms_size',
                                                         tag=tag,
                                                         graph_builder=BytecodeBlockGraph(label_f=block_label_size_saved, node_features='single_push'),
                                                         basic_block_filter=MinSizeOfInputBlockFilter(5)
                                                        )


##
dataset_db[4] = lambda tag: GraphBasedBasicBlocksDataset(root='data',
                                                         name='bex_size',
                                                         tag=tag,
                                                         graph_builder=BytecodeBlockGraph(label_f=block_label_size_saved, node_features='category'),
                                                         basic_block_filter=MinSizeOfInputBlockFilter(5)
                                                        )
dataset_db[5] = lambda tag: GraphBasedBasicBlocksDataset(root='data',
                                                         name='oms_size',
                                                         tag=tag,
                                                         graph_builder=BytecodeBlockGraph(label_f=block_label_size_saved, node_features='category'),
                                                         basic_block_filter=MinSizeOfInputBlockFilter(5)
                                                        )

##
dataset_db[6] = lambda tag: GraphBasedBasicBlocksDataset(root='data',
                                                         name='bex_gas',
                                                         tag=tag,
                                                         graph_builder=BytecodeBlockGraph(label_f=block_label_gas_saved, node_features='multi_push'),
                                                         basic_block_filter=MinSizeOfInputBlockFilter(5)
                                                        )
dataset_db[7] = lambda tag: GraphBasedBasicBlocksDataset(root='data',
                                                         name='oms_gas',
                                                         tag=tag,
                                                         graph_builder=BytecodeBlockGraph(label_f=block_label_gas_saved, node_features='multi_push'),
                                                         basic_block_filter=MinSizeOfInputBlockFilter(5)
                                                        )

##
dataset_db[8] = lambda tag: GraphBasedBasicBlocksDataset(root='data',
                                                         name='bex_gas',
                                                         tag=tag,
                                                         graph_builder=BytecodeBlockGraph(label_f=block_label_gas_saved, node_features='single_push'),
                                                         basic_block_filter=MinSizeOfInputBlockFilter(5)
                                                        )
dataset_db[9] = lambda tag: GraphBasedBasicBlocksDataset(root='data',
                                                         name='oms_gas',
                                                         tag=tag,
                                                         graph_builder=BytecodeBlockGraph(label_f=block_label_gas_saved, node_features='single_push'),
                                                         basic_block_filter=MinSizeOfInputBlockFilter(5)
                                                        )


##
dataset_db[10] = lambda tag: GraphBasedBasicBlocksDataset(root='data',
                                                         name='bex_gas',
                                                         tag=tag,
                                                         graph_builder=BytecodeBlockGraph(label_f=block_label_gas_saved, node_features='category'),
                                                         basic_block_filter=MinSizeOfInputBlockFilter(5)
                                                        )
dataset_db[11] = lambda tag: GraphBasedBasicBlocksDataset(root='data',
                                                         name='oms_gas',
                                                         tag=tag,
                                                         graph_builder=BytecodeBlockGraph(label_f=block_label_gas_saved, node_features='category'),
                                                         basic_block_filter=MinSizeOfInputBlockFilter(5)
                                                        )


##
dataset_db[12] = lambda tag: SequenceBasedBasicBlocksDataset(root='data',
                                                            name='bex_size',
                                                            tag=tag,
                                                            sequence_builder=BytecodeSequence(label_f=block_label_size_saved,encoding='category'),
                                                            basic_block_filter=MinSizeOfInputBlockFilter(5)
                                                        )

dataset_db[13] = lambda tag: SequenceBasedBasicBlocksDataset(root='data',
                                                            name='oms_size',
                                                            tag=tag,
                                                            sequence_builder=BytecodeSequence(label_f=block_label_size_saved,encoding='category'),
                                                            basic_block_filter=MinSizeOfInputBlockFilter(5)
                                                        )
dataset_db[14] = lambda tag: SequenceBasedBasicBlocksDataset(root='data',
                                                            name='rl_size_opt',
                                                            tag=tag,
                                                            sequence_builder=BytecodeSequence(label_f=block_label_size_saved,encoding='category'),
                                                            basic_block_filter=MinSizeOfInputBlockFilter(5)
                                                        )

##
dataset_db[15] = lambda tag: SequenceBasedBasicBlocksDataset(root='data',
                                                            name='bex_size',
                                                            tag=tag,
                                                            sequence_builder=BytecodeSequence(label_f=block_label_size_saved,encoding='multi_push'),
                                                            basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                        )

dataset_db[16] = lambda tag: SequenceBasedBasicBlocksDataset(root='data',
                                                            name='oms_size',
                                                            tag=tag,
                                                            sequence_builder=BytecodeSequence(label_f=block_label_size_saved,encoding='multi_push'),
                                                            basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                        )
dataset_db[17] = lambda tag: SequenceBasedBasicBlocksDataset(root='data',
                                                            name='rl_size_opt',
                                                            tag=tag,
                                                            sequence_builder=BytecodeSequence(label_f=block_label_size_saved,encoding='multi_push'),
                                                            basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                        )


##
dataset_db[18] = lambda tag: GraphBasedBasicBlocksDataset(root='data',
                                                          name='bex_size',
                                                          tag=tag,
                                                          graph_builder=SFSGraph(label_f=block_label_opt_ninstr,node_features='multi_push',regression=True),
                                                          basic_block_filter=MinSizeOfInputBlockFilter(5)
                                                          )

dataset_db[19] = lambda tag: GraphBasedBasicBlocksDataset(root='data',
                                                          name='oms_size',
                                                          tag=tag,
                                                          graph_builder=SFSGraph(label_f=block_label_opt_ninstr,node_features='multi_push',regression=True),
                                                          basic_block_filter=MinSizeOfInputBlockFilter(5)
                                                          )

dataset_db[20] = lambda tag: GraphBasedBasicBlocksDataset(root='data',
                                                          name='rl_size_opt',
                                                          tag=tag,
                                                          graph_builder=SFSGraph(label_f=block_label_opt_ninstr,node_features='multi_push',regression=True),
                                                          basic_block_filter=MinSizeOfInputBlockFilter(5)
                                                          )

##
dataset_db[21] = lambda tag: GraphBasedBasicBlocksDataset(root='data',
                                                          name='bex_size',
                                                          tag=tag,
                                                          graph_builder=SFSGraph(label_f=block_label_opt_ninstr,node_features='category',regression=True),
                                                          basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                          )

dataset_db[22] = lambda tag: GraphBasedBasicBlocksDataset(root='data',
                                                          name='oms_size',
                                                          tag=tag,
                                                          graph_builder=SFSGraph(label_f=block_label_opt_ninstr,node_features='category',regression=True),
                                                          basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                          )

dataset_db[23] = lambda tag: GraphBasedBasicBlocksDataset(root='data',
                                                          name='rl_size_opt',
                                                          tag=tag,
                                                          graph_builder=SFSGraph(label_f=block_label_opt_ninstr,node_features='category',regression=True),
                                                          basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                          )

def load_dataset(id):
    print(f'Loading dataset with id {id}')
    ds = dataset_db[id](id)
    return ds
