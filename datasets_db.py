# from datasets import GasolBasicBlocks, GraphBuilder_2, GraphBuilder_1, class_generator_4
# from datasets import GasolBytecodeSeq, SequenceBuilder_1, class_generator_4
# from datasets import GasolBytecodeSeq, SequenceBuilder_1, class_generator_11

from graph_based_basic_blocks_dataset import GraphBasedBasicBlocksDataset
from sfs_graph import SFSGraph
from bytecode_block_graph import BytecodeBlockGraph

from sequence_based_basic_blocks_dataset import SequenceBasedBasicBlocksDataset
from bytecode_sequence import BytecodeSequence  

from label_generators import block_label_gas_saved, block_label_size_saved, block_label_opt_ninstr, block_label_extra_instr
from basic_block_filters import MinSizeOfInputBlockFilter
from sequence_based_block_split_dataset import SequenceBasedBasicSplitDataset


dataset_db={};

##

##
dataset_db[0] = lambda tag: SequenceBasedBasicBlocksDataset(root='data',
                                                            name='100-8-17',
                                                            tag=tag,
                                                            sequence_builder=BytecodeSequence(label_f=block_label_size_saved,encoding='category'),
                                                            basic_block_filter=MinSizeOfInputBlockFilter(5)
                                                        )

dataset_db[1] = lambda tag: SequenceBasedBasicBlocksDataset(root='data',
                                                            name='jul22-0xa-8-17',
                                                            tag=tag,
                                                            sequence_builder=BytecodeSequence(label_f=block_label_size_saved,encoding='category'),
                                                            basic_block_filter=MinSizeOfInputBlockFilter(5)
                                                        )

dataset_db[2] = lambda tag: SequenceBasedBasicBlocksDataset(root='data',
                                                            name='jul22-0xABC-8-17',
                                                            tag=tag,
                                                            sequence_builder=BytecodeSequence(label_f=block_label_size_saved,encoding='category'),
                                                            basic_block_filter=MinSizeOfInputBlockFilter(5)
                                                        )

##
dataset_db[3] = lambda tag: SequenceBasedBasicBlocksDataset(root='data',
                                                            name='100-8-17',
                                                            tag=tag,
                                                            sequence_builder=BytecodeSequence(label_f=block_label_opt_ninstr,encoding='category',regression=True),
                                                            basic_block_filter=MinSizeOfInputBlockFilter(5)
                                                        )

dataset_db[4] = lambda tag: SequenceBasedBasicBlocksDataset(root='data',
                                                            name='jul22-0xa-8-17',
                                                            tag=tag,
                                                            sequence_builder=BytecodeSequence(label_f=block_label_opt_ninstr,encoding='category',regression=True),
                                                            basic_block_filter=MinSizeOfInputBlockFilter(5)
                                                        )

dataset_db[5] = lambda tag: SequenceBasedBasicBlocksDataset(root='data',
                                                            name='jul22-0xABC-8-17',
                                                            tag=tag,
                                                            sequence_builder=BytecodeSequence(label_f=block_label_opt_ninstr,encoding='category',regression=True),
                                                            basic_block_filter=MinSizeOfInputBlockFilter(5)
                                                        )



dataset_db[100] = lambda tag: GraphBasedBasicBlocksDataset(root='data',
                                                           name='100-8-17',
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',regression=True),
                                                           basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                           )
dataset_db[101] = lambda tag: GraphBasedBasicBlocksDataset(root='data',
                                                           name='jul22-0xa-8-17',
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',regression=True),
                                                           basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                           )
dataset_db[102] = lambda tag: GraphBasedBasicBlocksDataset(root='data',
                                                           name='jul22-0xABC-8-17',
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',regression=True),
                                                           basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                           )
dataset_db[103] = lambda tag: GraphBasedBasicBlocksDataset(root='data',
                                                           name='jul22-0xb-8.17',
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',regression=True),
                                                           basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                           )
dataset_db[104] = lambda tag: GraphBasedBasicBlocksDataset(root='data',
                                                           name='jul22-0xd-8.17',
                                                           tag=tag,
                                                           graph_builder=SFSGraph(label_f=block_label_extra_instr,node_features='multi_push',regression=True),
                                                           basic_block_filter=MinSizeOfInputBlockFilter(1)
                                                           )


#
dataset_db[1000] = lambda tag: SequenceBasedBasicSplitDataset(root='data',
                                                            name='hierarchy',
                                                            tag=tag
                                                        )

def load_dataset(id):
    print(f'Loading dataset with id {id}')
    ds = dataset_db[id](id)
    return ds
