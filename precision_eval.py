
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
class CorrectClass():
    def __init__(self):
        self.correct = 0
        self.total = 0

    def reset(self):
        self.correct = 0
        self.total = 0

    def eval(self,model_out,labels,data,loss_criterion):
        pred = model_out.argmax(dim=1)
        self.correct += int((pred == labels).sum())
        self.total += len(labels)
    
    def tag(self):
        return "CLASS_OK"
    
    def report(self):
        return f'{self.correct}/{self.total} (%{self.correct/self.total*100:0.2f})'

    def loss(self):
        return 1.0-self.correct/self.total



# tries to simulate the actual execution of gasol, counting how much
# gas/size we lose and how much time we gain
#
class TimeGain_vs_OptLoss():
    def __init__(self,opt_key='size_saved',time_key='time'):
        self.opt_key = opt_key
        self.time_key = time_key

        self.correct = 0
        self.total = 0
        self.total_opt = 0
        self.total_time = 0
        self.lost_opt = 0
        self.saved_time = 0
        self._correct = 0
        self.wrong_0_ans = 0
        self.wrong_1_answ = 0

    def reset(self):
        self.correct = 0
        self.total = 0
        self.total_opt = 0
        self.total_time = 0
        self.lost_opt = 0
        self.saved_time = 0
        self._correct = 0
        self.wrong_0_ans = 0
        self.wrong_1_answ = 0

    def eval(self,model_out,labels,data,loss_criterion):
        size_saved = data[3][self.opt_key]
        time = data[3][self.time_key]

        # calculate the predicted values
        pred = model_out.argmax(dim=1)

        # total correct predictions
        self.correct += int((pred == labels).sum())
        self.total += len(labels)

        # traverse all answers and collect some stats
        for i in range(len(pred)):

            # the total gas/size save, and total time spent
            self.total_opt += max(0,size_saved[i].item())
            self.total_time += time[i].item()

            # if we predict do not optimize, we save the time and lose the size/gas
            if pred[i].item() == 0:
                self.lost_opt += max(0,size_saved[i].item())
                self.saved_time += time[i].item()

            # how many 0 answers are wrong, and how many 1 answers are wrong    
            if labels[i].item() == 1 and pred[i].item() == 0:
                self.wrong_0_ans += 1
            elif labels[i].item() == 0 and pred[i].item() == 1:
                self.wrong_1_answ += 1
                
            
        
    def tag(self):
        return "TimeGain_OptLoss"
    
    def report(self):
        return f'{self.saved_time:.2f}/{self.total_time:.2f},{self.lost_opt:.2f}/{self.total_opt:.2f})@({self.correct},{self.wrong_0_ans},{self.wrong_1_answ}'

    def loss(self):
        return 1.0-self.correct/self.total


# count the aggregated batch loss wrt the given criterion, it can be sum, mean, or max.
#
class CriterionLoss():
    def __init__(self,reduction='sum'): # sum, mean, or max
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
            diff = pred[i]-labels[i]
            if abs(diff) < self.eps:
                self.correct += 1

    def tag(self):
        return f'EPS({self.eps})'

    def report(self):
        return f'{self.correct}/{self.total}'

    def loss(self):
            return 1 - self.correct/self.total
