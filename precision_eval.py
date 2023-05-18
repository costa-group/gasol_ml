import random
import torch
import math

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
        self.outfile = None
        self.epoch = None

    def reset(self,epoch=None,out_suffix='',out_path='/tmp'):
        self.correct = 0
        self.total = 0
        self.outfile = open(f'{out_path}/hit_{out_suffix}.dat',"a")
        self.epoch = epoch

    def eval(self,model_out,labels,data,loss_criterion,epoch=None,out_suffix='',out_path='/tmp'):
        pred = to_labels(model_out,self.p)
        self.correct += int((pred == labels).sum())
        self.total += len(labels)
    
    def tag(self):
        return "CLASS_OK"
    
    def report(self,epoch=None,out_suffix='',out_path='/tmp'):
        self.outfile.write(f'{self.epoch} {self.correct} {self.total} {self.correct/self.total*100:0.2f}\n')
        self.outfile.close()
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
        self.trainpreds = None
        self.traintrues = None
        self.loss_criterion = None
        self.outfile = None
        self.epoch = None

    def reset(self,epoch=None,out_suffix='',out_path='/tmp'):
        self.total_loss = 0
        self.num_of_batches = 0
        self.max_loss = 0
        self.trainpreds = torch.tensor([])
        self.traintrues = torch.tensor([],dtype=torch.long)

        self.outfile = open(f'{out_path}/loss_{out_suffix}.dat',"a")
        self.epoch = epoch

    def eval(self,model_out,labels,data,loss_criterion,epoch=None,out_suffix='',out_path='/tmp'):
        loss = loss_criterion(model_out, labels).item()
        self.total_loss += loss
        self.max_loss = max(self.max_loss,loss)
        self.num_of_batches += 1

        self.trainpreds = torch.cat((self.trainpreds,model_out.cpu().detach()))
        self.traintrues = torch.cat((self.traintrues,labels.cpu().detach()))
        self.loss_criterion = loss_criterion
        
    def tag(self):
        return f'LOSS F. ({self.reduction})'

    def report(self,epoch=None,out_suffix='',out_path='/tmp'):
#        print(self.trainpreds)
#        print(self.traintrues)
#        print(self.loss_criterion)
        # global_loss = self.loss_criterion(self.trainpreds, self.traintrues).item()

        # c1=c2=c3=0
        # for i in range(len(self.traintrues)):
        #     act = self.traintrues[i].item()
        #     pred = self.trainpreds[i] #.item()
            
        #     if act == 0.0:
        #         c1 += 1
        #     if pred == 0.0:
        #         c2 += 1
        #         if act == 0:
        #             c3 += 1

        self.outfile.write(f'{self.epoch} {self.total_loss/self.num_of_batches} {self.max_loss} {self.total_loss}\n')
        self.outfile.close()

        return f'total={self.total_loss:.2f},max={self.max_loss:.2f},mean={self.total_loss/self.num_of_batches:.2f}'#,global={global_loss:.2f},{c1},{c2},{c3}'

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
        self.outfile = None
        self.epoch = None

    def reset(self,epoch=None,out_suffix='',out_path='/tmp'):
        self.correct = 0
        self.total = 0
        self.outfile = open(f'{out_path}/eps_{out_suffix}.dat',"a")
        self.epoch = epoch

    def eval(self,model_out,labels,data,loss_criterion,epoch=None,out_suffix='',out_path='/tmp'):

        pred=model_out
        
        self.total += len(pred)

        # traverse all answers and collect some stats
        for i in range(len(pred)):
            diff = pred[i].item()-labels[i]
            if abs(diff) < self.eps:
                self.correct += 1

    def tag(self):
        return f'EPS({self.eps})'

    def report(self,epoch=None,out_suffix='',out_path='/tmp'):
        self.outfile.write(f'{self.epoch} {self.eps} {self.correct}/{self.total}\n')
        self.outfile.close()
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
        self.totals = {}
        self.hit_answ = {}
        self.lt_answ = {}
        self.gt_answ = {}
        self.outfile1 = None
        self.outfile2 = None
        self.epoch = None

    def reset(self,epoch=None,out_suffix='',out_path='/tmp'):
        self.total = 0
        self.hit = 0
        self.lt = 0
        self.gt = 0
        self.neg = 0
        self.totals = {}
        self.hit_answ = {}
        self.lt_answ = {}
        self.gt_answ = {}
        self.epoch = epoch
        self.outfile1 = open(f'{out_path}/safe_bound_{out_suffix}.dat',"a")
        self.outfile2 = open(f'{out_path}/safe_bound_{out_suffix}_{self.epoch}.dat',"w")

    def eval(self,model_out,labels,data,loss_criterion,epoch=None,out_suffix='',out_path='/tmp'):

        pred=model_out
        
        self.total += len(pred)

        # traverse all answers and collect some stats
        for i in range(len(pred)):

            p = int(self.to_int(pred[i].item()))
            l = int(labels[i].item())
            
            if self.totals.get(l) is None:
                self.totals[l] = 1
                self.hit_answ[l] = 0
                self.lt_answ[l] = 0
                self.gt_answ[l] = 0
            else:
                self.totals[l] = self.totals[l]+1

            if p<0:
                self.neg += 1
    
            if p == l:
                self.hit += 1
                self.hit_answ[l] += 1
            elif p > l:
                self.gt += 1            
                self.gt_answ[l] += 1
            else:
                self.lt += 1
                self.lt_answ[l] += 1

    def tag(self):
        return f'SAFE'

    def report(self,epoch=None,out_suffix='',out_path='/tmp'):
        for k in sorted(self.totals.keys()):
            self.outfile2.write(f'{self.epoch} {k} {self.totals[k]} {self.hit_answ[k]} {self.gt_answ[k]} {self.lt_answ[k]}\n')
        self.outfile2.close()
        
        self.outfile1.write(f'{self.epoch} {self.total} {self.hit} {self.gt} {self.lt}\n')
        self.outfile1.close()
        
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
        self.outfile = None
        self.epoch = None

    def reset(self,epoch=None,out_suffix='',out_path='/tmp'):
        self.canbeimprove = 0
        self.hit = 0
        self.imp = 0
        self.lt = 0
        self.gt = 0
        self.eq = 0
        self.total = 0
        self.outfile = open(f'{out_path}/precise_bound_{out_suffix}.dat',"a")
        self.epoch = epoch

    def eval(self,model_out,labels,data,loss_criterion,epoch=None,out_suffix='',out_path='/tmp'):
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

    def report(self,epoch=None,out_suffix='',out_path='/tmp'):

        self.outfile.write(f'{self.epoch} {self.canbeimprove} {self.hit} {self.imp} {self.eq} {self.gt} {self.lt}\n')
        self.outfile.close()

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
        self.wrong_0 = 0
        self.wrong_1 = 0

    def reset(self,epoch=None,out_suffix='',out_path='/tmp'):
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
        self.wrong_0 = 0
        self.wrong_1 = 0

    def eval(self,model_out,labels,data,loss_criterion,epoch=None,out_suffix='',out_path='/tmp'):
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
                self.wrong_0 += 1
                self.saved_time_w += time[i].item()
            elif labels[i].item() == 0 and pred[i].item() == 1:
                self.wrong_1 += 1
                
            
        
    def tag(self):
        return "TimeGain_OptLoss"
    
    def report(self,epoch=None,out_suffix='',out_path='/tmp'):
        # precesion_1 = self.correct_1/(self.correct_1+self.wrong_1_answ)
        # recall_1 = self.correct_1/(self.correct_1+self.wrong_0_answ)
        # precesion_0 = self.correct_0/(self.correct_0+self.wrong_0_answ)
        # recall_0 = self.correct_0/(self.correct_0+self.wrong_1_answ)
        precesion_1 = self.correct_1/(self.correct_1+self.wrong_1) if self.correct_1+self.wrong_1>0 else 1
        recall_1 = self.correct_1/(self.correct_1+self.wrong_0) if self.correct_1+self.wrong_0>0 else 1
        precesion_0 = self.correct_0/(self.correct_0+self.wrong_0) if self.correct_0+self.wrong_0>1 else 1
        recall_0 = self.correct_0/(self.correct_0+self.wrong_1) if self.correct_0+self.wrong_1>0 else 1
        return f'{self.saved_time:.2f}/{self.total_time:.2f},{self.lost_opt_units:.2f}/{self.total_opt_units:.2f})@(TN={self.correct_0},TP={self.correct_1},FN={self.wrong_0}({self.saved_time_w/self.saved_time*100:.2f}%),FP={self.wrong_1})@({precesion_1:.4f},{recall_1:.4f})@@({precesion_0:.4f},{recall_0:.4f})'

    def loss(self):
        return 1.0-self.correct/self.total


# tries to simulate the actual execution of gasol, counting how much
# gas/size we lose and how much time we gain
#
class ROC():
    def __init__(self,opt_key='saved_size'):
        self.trainpreds = None
        self.traintrues = None
        self.loss_criterion = None
        self.opt_key = opt_key
        self.outfile = None
        self.epoch = None
        
    def reset(self,epoch=None,out_suffix='',out_path='/tmp'):
        self.trainpreds = torch.tensor([])
        self.traintrues = torch.tensor([],dtype=torch.long)
        self.outfile = open(f'{out_path}/roc_{out_suffix}_{epoch}.dat',"a")
        self.epoch = epoch

    def eval(self,model_out,labels,data,loss_criterion,epoch=None,out_suffix='',out_path='/tmp'):
        self.trainpreds = torch.cat((self.trainpreds,model_out.cpu().detach()))
        self.traintrues = torch.cat((self.traintrues,labels.cpu().detach()))
        self.loss_criterion = loss_criterion          
        
    def tag(self):
        return ""

    def cal_roc(self,p):
        # traverse all answers and collect some stats

        correct_0 = 0
        correct_1 = 0
        wrong_0 = 0
        wrong_1 = 0

        for i in range(len(self.traintrues)):
            pred = 1 if self.trainpreds[i].softmax(dim=0)[1]>p else 0
#            print(f'p={p}, {self.trainpreds[i]}, {self.trainpreds[i].softmax(dim=0)}, {pred}')
            act = self.traintrues[i].item()
            
            if pred == 0:
                if act == 0:
                    correct_0 += 1
                else:
                    wrong_0 += 1

            if pred == 1:
                if act == 1:
                    correct_1 += 1
                else:
                    wrong_1 += 1

        precesion_1 = correct_1/(correct_1+wrong_1) if correct_1+wrong_1>0 else 1
        recall_1 = correct_1/(correct_1+wrong_0) if correct_1+wrong_0>0 else 1
        precesion_0 = correct_0/(correct_0+wrong_0) if correct_0+wrong_0>1 else 1
        recall_0 = correct_0/(correct_0+wrong_1) if correct_0+wrong_1>0 else 1
        acu = (correct_1+correct_0)/(correct_1+correct_0+wrong_1+wrong_0)
        return acu, precesion_1,recall_1,precesion_0,recall_0, correct_1, wrong_1, correct_0, wrong_0 

    def report(self,epoch=None,out_suffix='',out_path='/tmp'):
        for i in range(101):
            p = i/100.0
            acu, precesion_1,recall_1,precesion_0,recall_0, correct_1, wrong_1, correct_0, wrong_0 = self.cal_roc(p)
            self.outfile.write(f'{p:0.4f} {acu:.10f} {precesion_1:.10f} {recall_1:.10f} {precesion_0:.10f} {recall_0:.10f} {correct_1} {wrong_1} {correct_0} {wrong_0}\n')

        self.outfile.close()

    def loss(self):
        return 0









    
    
# count the aggregated batch loss wrt the given criterion, it can be sum, mean, or max.
#
class RegInfo():
    def __init__(self,reduction='mean'): # sum, mean, or max
        self.trainpreds = None
        self.traintrues = None
        self.loss_criterion = None
        self.idx = 0

    def reset(self,epoch=None,out_suffix='',out_path='/tmp'):
        self.trainpreds = torch.tensor([])
        self.traintrues = torch.tensor([],dtype=torch.long)

    def eval(self,model_out,labels,data,loss_criterion,epoch=None,out_suffix='',out_path='/tmp'):
        self.trainpreds = torch.cat((self.trainpreds,model_out.cpu().detach()))
        self.traintrues = torch.cat((self.traintrues,labels.cpu().detach()))
        self.loss_criterion = loss_criterion
        
    def tag(self):
        return f'RegInfo'

    def report(self,epoch=None,out_suffix='',out_path='/tmp'):
        self.idx = self.idx+1
        outfile = open(f'tmp/reg_{self.idx}.dat', "w")
        for i in range(len(self.trainpreds)):
            pred = self.trainpreds[i].item()
            act  = self.traintrues[i].item()
            outfile.write(f'{i}	{act}	{pred}	{round(pred)}	{math.ceil(pred)}	{math.floor(pred)}')
            outfile.write('\n')
        outfile.close()
        
        return f''

    def loss(self):
        return 0.0
