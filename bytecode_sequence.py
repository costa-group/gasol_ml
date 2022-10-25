import torch
from opcodes import vocab as single_push_vocab, vocab_ as multi_push_vocab, is_push_instr, is_memory_read_instr, is_memory_write_instr, is_store_read_instr, is_store_write_instr, is_swap_instr, is_dup_instr, is_comm_instr, split_bytecode_, opcodes, get_opcode

# one-hot vector
#
#  [opcode_0, opcode_1, ..., ...] 
#
#  - valid input: "empty", "in_var", "out_var" or a dictionary that corresponds to an instruction from the sfs
#  - all PUSHi are considered PUSH
#  - call with "empty" to get an empty vector
#
def node_features_com_single_push(opcode):

    vocab = single_push_vocab

    # remove the 'i' from PUSHi
    if re.fullmatch("PUSH([0-9]+)", opcode) is not None:
        opcode = "PUSH"

    return vocab.index(opcode)

# one-hot vector
#
#  [commutative, opcode_0, opcode_1, ..., ...] 
#
#  - valid input: "empty", opcode
#  - PUSHi treated as different instructions
#  - call with "empty" to get an empty vector
#
def node_features_com_multi_push(opcode):

    vocab = multi_push_vocab

    return vocab.index(opcode)


# one-hot vector:
#
#  [commutative, mem_read_inst, mem_write_inst, store_read_inst, store_write_inst, push_inst, pop, swap_inst, dup_inst, other_inst]
#
#  - valid input: "empty", opcode
#  - we just distinguish the class of the instruction swap/dup/push/memory/store/other (swap and dup never appear since we are using the sfs)
#  - call with "empty" to get an empty vector
#  
def node_feature_com_category(opcode):
    idx = 0

    if is_comm_instr(opcode):
        idx = 0
    elif is_memory_read_instr(opcode):
        idx = 1
    elif is_memory_write_instr(opcode):
        idx = 2
    elif is_store_read_instr(opcode):
        idx = 3
    elif is_store_write_instr(opcode):
        idx = 4
    elif opcode == "POP":
        idx = 5
    elif is_push_instr(opcode):
        idx = 6
    elif is_swap_instr(opcode):
        idx = 7
    elif is_dup_instr(opcode):
        idx = 8
    else:
        idx = 9

    return idx

# one-hot vector:
#
#  [commutative, mem_read_inst, mem_write_inst, store_read_inst, store_write_inst, push_inst, pop, swap_inst, dup_inst, other_inst]
#
#  - valid input: "empty", opcode
#  - we just distinguish the class of the instruction swap/dup/push/memory/store/other (swap and dup never appear since we are using the sfs)
#  - call with "empty" to get an empty vector
#  
def node_feature_com_category2(opcode):
    idx = 0

    if is_comm_instr(opcode):
        idx = 0
    elif is_memory_read_instr(opcode):
        idx = 1
    elif is_memory_write_instr(opcode):
        idx = 2
    elif is_store_read_instr(opcode):
        idx = 3
    elif is_store_write_instr(opcode):
        idx = 4
    elif opcode == "POP":
        idx = 5
    elif is_push_instr(opcode):
        idx = 6
    elif is_swap_instr(opcode):
        idx = 7
    elif is_dup_instr(opcode):
        idx = 8
    else:
        try:
            idx = get_opcode(opcode)[1]+9
        except Exception as e:
            print(f'error: {opcode}')
            exit(1)
            
    return idx



class BytecodeSequence:
    def __init__(self,
                 label_f=None,         # function for calculating the label
                 encoding = 'single_push', # can be 'single_push', 'multi_push', or 'category'
                 encode_consts = False,
                 regression=False):

        if encoding == 'single_push':
            self.encoding_f = node_features_com_single_push
            self.opcode_vocab_size = len(single_push_vocab)
        elif encoding == 'multi_push':
            self.encoding_f = node_features_com_multi_push
            self.opcode_vocab_size = len(multi_push_vocab)
        elif encoding == 'category':
            self.opcode_vocab_size = 10
            self.encoding_f = node_feature_com_category
        elif encoding == 'category2':
            self.opcode_vocab_size = 16
            self.encoding_f = node_feature_com_category2
        else:
            raise Exception(f"Invalid value for node_features: {node_features}")

        self.label_f = label_f
        self.regression = regression
        self.encode_consts = encode_consts

        if encode_consts:
            self.vocab_consts_shift = 17
            self.vocab_consts =['#','0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F']
        else:
            self.vocab_consts_shift = 0
            self.vocab_consts =[]

        self.idx = 0

    def vocab_size(self):
        return self.opcode_vocab_size + self.vocab_consts_shift + 1 # the zero is used for padding, this is why we add 1


    def build_seq_from_bytecode(self, bytecode):

        bytecode_sequence_orig = split_bytecode_(bytecode)

        if self.encode_consts:
            bytecode_sequence = []
            for t in bytecode_sequence_orig:
                if t.startswith("#"):
                    for c in t:
                        bytecode_sequence.append(c.upper())
                else:
                    bytecode_sequence.append(t)
        else:
            bytecode_sequence = list(filter(lambda x: not x.startswith("#"),bytecode_sequence_orig))

        ## aux function to look for the encoding of a token (opcode/digit/#)    
        def encode(token):
            if token in self.vocab_consts:
                return self.vocab_consts.index(token)
            else:
                return self.encoding_f(token) + self.vocab_consts_shift
 
        # convert the sequence into sequence of ids    
        bytecode_ids_sequence = [ encode(b)+1 for b in bytecode_sequence ] # the +1 is for avoiding 0, we later use it for padding
        return bytecode_ids_sequence

    def build_seq(self, block_info, block_sfs):

        # we only handle benchamrks for which a model was found -- should have been eliminated earlier
        if not block_info["model_found"]=="True":
            return None

        # convert the sequence into sequence of ids    
        bytecode_ids_sequence = self.build_seq_from_bytecode(block_sfs["original_instrs"])

        x = torch.tensor(bytecode_ids_sequence, dtype=torch.long).to(torch.long)

        # print(bytecode_sequence_orig)
        # print(bytecode_sequence)
        # print(x)
        
        # compute label -- must get rid of self.regression, it is ugly!!
        label = self.label_f(block_info,block_sfs)
        if self.regression:
            y = torch.tensor([[label]]).to(torch.float)
        else:
            y = torch.tensor(label).to(torch.long)            

        d = {"data": x, "label": y, "info": { "idx": self.idx, "size_saved": torch.tensor(float(block_info["saved_size"])), "gas_saved": torch.tensor(float(block_info["saved_gas"])), "time": torch.tensor(float(block_info["solver_time_in_sec"])), "initial_n_instrs": torch.tensor(int(block_info["initial_n_instrs"]))}}

        self.idx += 1
        
        return d
