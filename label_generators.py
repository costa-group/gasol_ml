# methods for generating labels, both for classificationa nd
# regression
#


# The number of instructions in the optimized code -- for regression
#
def block_label_opt_ninstr(block_info, block_sfs):    
        return float(block_info["optimized_n_instrs"]);

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

