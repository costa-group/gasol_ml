import random
import torch

# This module includes classes that are used as precision
# evaluators. Each such class should provide methods
#
#   reset: resets everything, it is called before starting to accumulate information
#   eval: calculate and registers the loss in the current batch
#   loss: return a number representing the loss -- in principle the smaller the better
#   tag: return a string identifying the class, just for the purpose of printing
#   report: returns a string with a summary, used for the purpose of printing
#

# counts number of instances that where classified correctly
#

def to_labels(model_out,p):
    if p is None:
        pred = model_out.argmax(dim=1)
    else:
        pred = torch.tensor(list(map(lambda o: 0 if o[0] > p else 1,model_out.softmax(dim=1))))

    return pred

class CorrectClass():
    def __init__(self,p=None):
        self.p = p
        self.correct = 0
        self.total = 0

    def reset(self):
        self.correct = 0
        self.total = 0

    def eval(self,model_out,labels,data,loss_criterion):
        pred = to_labels(model_out,self.p)
        self.correct += int((pred == labels).sum())
        self.total += len(labels)
    
    def tag(self):
        return "CLASS_OK"
    
    def report(self):
        return f'{self.correct}/{self.total} (%{self.correct/self.total*100:0.2f})'

    def loss(self):
        return 1.0-self.correct/self.total



# count the aggregated batch loss wrt the given criterion, it can be sum, mean, or max.
#
class CriterionLoss():
    def __init__(self,reduction='mean'): # sum, mean, or max
        self.reduction = reduction
        self.total_loss = 0
        self.num_of_batches = 0
        self.max_loss = 0

    def reset(self):
        self.total_loss = 0
        self.num_of_batches = 0
        self.max_loss = 0

    def eval(self,model_out,labels,data,loss_criterion):
        loss = loss_criterion(model_out, labels).item()
        self.total_loss += loss
        self.max_loss = max(self.max_loss,loss)
        self.num_of_batches += 1

    def tag(self):
        return f'LOSS F. ({self.reduction})'

    def report(self):
        return f'total={self.total_loss:.2f},max={self.max_loss:.2f},mean={self.total_loss/self.num_of_batches:.2f}'

    def loss(self):
        if self.reduction=='mean':
            return self.total_loss/self.num_of_batches
        elif self.reduction=='sum':
            return self.total_loss
        else:
            return self.max_loss


# tries to simulate the actual execution of gasol, counting how much
# gas/size we lose and how much time we gain
#
class CountEpsError():
    def __init__(self,eps=1):
        self.eps = eps

        self.correct = 0
        self.total = 0

    def reset(self):
        self.correct = 0
        self.total = 0

    def eval(self,model_out,labels,data,loss_criterion):

        pred=model_out
        
        self.total += len(pred)

        # traverse all answers and collect some stats
        for i in range(len(pred)):
            diff = pred[i].item()-labels[i]
            if abs(diff) < self.eps:
                self.correct += 1

    def tag(self):
        return f'EPS({self.eps})'

    def report(self):
        return f'{self.correct}/{self.total}'

    def loss(self):
            return 1 - self.correct/self.total


# tries to simulate the actual execution of gasol, counting how much
# gas/size we lose and how much time we gain
#
class SafeBound():
    def __init__(self,to_int=round):
        self.to_int = to_int
        self.total = 0
        self.hit = 0
        self.lt = 0
        self.gt = 0
        self.neg = 0

    def reset(self):
        self.total = 0
        self.hit = 0
        self.lt = 0
        self.gt = 0
        self.neg = 0

    def eval(self,model_out,labels,data,loss_criterion):

        pred=model_out
        
        self.total += len(pred)

        # traverse all answers and collect some stats
        for i in range(len(pred)):
            p = int(self.to_int(pred[i].item()))
            l = int(labels[i].item())
            if p<0:
                self.neg += 1
            if p == l:
                self.hit += 1
            elif p > l:
                self.gt += 1            
            else:
                self.lt += 1

    def tag(self):
        return f'SAFE'

    def report(self):
        return f'{self.total}: ={self.hit}({self.hit/self.total*100:.2f}%),>{self.gt}({self.gt/self.total*100:.2f}%),<{self.lt}({self.lt/self.total*100:.2f}%),M{self.neg}'

    def loss(self):
            return 1 - (self.hit+self.gt)/self.total


# tries to simulate the actual execution of gasol, counting how much
# gas/size we lose and how much time we gain
#
class PreciseBound():
    def __init__(self,to_int=round):
        self.to_int = to_int
        self.canbeimprove = 0
        self.hit = 0
        self.imp = 0
        self.lt = 0
        self.gt = 0
        self.eq = 0
        self.total = 0

    def reset(self):
        self.canbeimprove = 0
        self.hit = 0
        self.imp = 0
        self.lt = 0
        self.gt = 0
        self.eq = 0
        self.total = 0

    def eval(self,model_out,labels,data,loss_criterion):
        init_n = data[1]['initial_n_instrs']
        sfs_size = data[1]['sfs_size']
        min_length = data[1]['min_length']

        pred=model_out
        
        self.total += len(pred)

        # traverse all answers and collect some stats
        for i in range(len(pred)):
            p = self.to_int(pred[i].item())
            if init_n[i]>min_length[i]+labels[i]: # can be improved
                self.canbeimprove += 1
                if p+min_length[i] == labels[i]+min_length[i]:
                    self.hit += 1                   
                elif p+min_length[i] > labels[i]+min_length[i] and p+min_length[i] < init_n[i]: 
                    self.imp += 1
                elif p+min_length[i] == init_n[i]:
                    self.eq += 1
                elif p+min_length[i] > init_n[i]:
                    self.gt += 1
                elif p+min_length[i] < init_n[i]:
                    self.lt += 1

                    

    def tag(self):
        return f'PR'

    def report(self):
        return f'{self.canbeimprove} (H{self.hit}({self.hit/self.canbeimprove*100:.2f}%),I{self.imp}({self.imp/self.canbeimprove*100:.2f}%),={self.eq}({self.eq/self.canbeimprove*100:.2f}%),>{self.gt}({self.gt/self.canbeimprove*100:.2f}%),<{self.lt}({self.lt/self.canbeimprove*100:.2f}%))'

    def loss(self):
            return 1 - self.hit/self.canbeimprove




        
# tries to simulate the actual execution of gasol, counting how much
# gas/size we lose and how much time we gain
#
class TimeGain_vs_OptLoss():
    def __init__(self,opt_key='saved_size',time_key='time',p=None):
        self.p = p
        self.opt_key = opt_key
        self.time_key = time_key

        self.correct = 0
        self.total = 0
        self.total_opt_units = 0
        self.total_time = 0
        self.lost_opt_units = 0
        self.saved_time = 0
        self.saved_time_w = 0
        self.correct = 0
        self.correct_0 = 0
        self.correct_1 = 0
        self.wrong_0_answ = 0
        self.wrong_1_answ = 0

    def reset(self):
        self.correct = 0
        self.total = 0
        self.total_opt_units = 0
        self.total_time = 0
        self.lost_opt_units = 0
        self.saved_time = 0
        self.saved_time_w = 0
        self.correct = 0
        self.correct_0 = 0
        self.correct_1 = 0
        self.wrong_0_answ = 0
        self.wrong_1_answ = 0

    def eval(self,model_out,labels,data,loss_criterion):
        units_saved = data[1][self.opt_key]
        time = data[1][self.time_key]

        # calculate the predicted values
        pred = to_labels(model_out,self.p)
#        pred = model_out.argmax(dim=1)
#        labels = labels.argmax(dim=1)

        # total correct predictions
        self.correct += int((pred == labels).sum())
        self.total += len(labels)

        # traverse all answers and collect some stats
        for i in range(len(pred)):

            # the total gas/size save, and total time spent
            self.total_opt_units += max(0,units_saved[i].item())
            self.total_time += time[i].item()

            # if we predict do not optimize, we save the time and lose the size/gas
            if pred[i].item() == 0:
                self.saved_time += time[i].item()
                self.lost_opt_units += max(0,units_saved[i].item())
                
            if pred[i].item() == 0 and labels[i].item() == 0:
                self.correct_0 += 1

            if pred[i].item() == 1 and labels[i].item() == 1:
                self.correct_1 += 1

                
            # how many 0 answers are wrong, and how many 1 answers are wrong    
            if labels[i].item() == 1 and pred[i].item() == 0:
                self.wrong_0_answ += 1
                self.saved_time_w += time[i].item()
            elif labels[i].item() == 0 and pred[i].item() == 1:
                self.wrong_1_answ += 1
                
            
        
    def tag(self):
        return "TimeGain_OptLoss"
    
    def report(self):
        precesion_1 = self.correct_1/(self.correct_1+self.wrong_1_answ)
        recall_1 = self.correct_1/(self.correct_1+self.wrong_0_answ)
        precesion_0 = self.correct_0/(self.correct_0+self.wrong_0_answ)
        recall_0 = self.correct_0/(self.correct_0+self.wrong_1_answ)
        return f'{self.saved_time:.2f}/{self.total_time:.2f},{self.lost_opt_units:.2f}/{self.total_opt_units:.2f})@(TN={self.correct_0},TP={self.correct_1},FN={self.wrong_0_answ}({self.saved_time_w/self.saved_time*100:.2f}%),FP={self.wrong_1_answ})@({precesion_1:.4f},{recall_1:.4f})@@({precesion_0:.4f},{recall_0:.4f})'

    def loss(self):
        return 1.0-self.correct/self.total

