

# compare the first element of the validation evaluators
#
def val_first_elem_cmp(curr_train_loss,curr_val_loss,best_train_loss,best_val_loss):
    return curr_val_loss[0] < best_val_loss[0]

# compare the first element of the training evaluators
#
def train_first_elem_cmp(curr_train_loss,curr_val_loss,best_train_loss,best_val_loss):
    return curr_train_loss[0] < best_train_loss[0]
