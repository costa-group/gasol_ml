# methods for generating labels, both for classificationa nd
# regression
#


# The number of instructions in the optimized code -- for regression
#
def block_label_opt_ninstr(block_info, block_sfs):    
        return float(block_info["optimized_n_instrs"])


# The number of instructions in the optimized code, minus the minimal length -- for regression
#
def block_label_extra_instr(block_info, block_sfs):
        d = float(block_info["optimized_n_instrs"])-float(block_sfs["min_length"])
        #d = float(block_info["optimized_n_instrs"])-float(len(block_sfs["user_instrs"]))
        assert( d>= 0 )
        return d

def block_label_opt_n_instr(block_info, block_sfs):
        d = float(block_info["optimized_n_instrs"])
        assert( d>= 0 )
        return d

# 1 if minlength is the optimal
def block_opt_minlen(block_info, block_sfs):
        d = float(block_info["optimized_n_instrs"])-float(block_sfs["min_length"])
        assert( d>=0 )
        return 1 if d==0 else 0

# 1 if gas was saved, and 0 otherwise -- for classification
#
def block_label_gas_saved(block_info, block_sfs):
    if int(block_info["saved_gas"]) > 0:
        c = 1
    else:
        c = 0
    return c

# 1 if size was saved, and 0 otherwise -- for classification
#
def block_label_size_saved(block_info, block_sfs):
    if int(block_info["saved_size"]) > 0:
        c = 1
    else:
        c = 0
    return c

