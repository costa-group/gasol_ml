
from sub_block_parser import load_list_of_sequences, process_sub_block_from_seq_elem
from random import randrange
import numpy as np

class GasolEnv:
    def __init__(self, source_path='./data/hierarchy'):
        self.source_path = source_path
        self.init_states = load_list_of_sequences(self.source_path)
        self.num_of_init_states = len(self.init_states)
        self.curr_state = { "left": [], "right": self.init_states[1].copy() }
        self.state_values = None
        self.sequences_store = None
        
    def reset(self):
        i = randrange(self.num_of_init_states)

    # observation, reward, terminated, truncated, info
    def step(self,action):
        l = self.curr_state["left"].copy()
        r = self.curr_state["right"].copy()

        truncated = False
        terminated = False
        reward = 0
        info = {}
        
        if action == 0:   # move
            if r:
                l.append(r[0])
                r.pop(0)
            else:
                truncated = True
        elif action == 1: # split
            if l:
                blokc_info = process_sub_block_from_seq_elem(l,self.source_path)
                reward = blokc_info['saved_size']
                l = []
                if not r:
                    terminated = True
            else:
                truncated = True

        new_state = { "left": l, "right": r }
        self.curr_state = new_state        
        return new_state, reward, terminated, truncated, info
        
    def _calculate_cost_of_block(self,seq,i,j):
        l = seq[i:(j+1)]
        block_info = process_sub_block_from_seq_elem(l,self.source_path)
        v = float(block_info["saved_size"])-(float(block_info["solver_time_in_sec"])/float(block_info["timeout"]))
        return v
    
    def _eval_all(self,seq,values,actions,i,j,k):
        if j>k:
            return 0.0

        # if if already computed
        if actions[i][j][k] != -1:
            return values[i][j][k]

        # move cursor
        v1 = self._eval_all(seq,values,actions,i,j+1,k)     

        # split
        v2 = self._eval_all(seq,values,actions,j+1,j+1,k) + self._calculate_cost_of_block(seq,i,j)

        # update cell
        if v1>v2:
            v = v1
            a = 0
        else:
            v = v2
            a = 1   # split

        values[i][j][k] = v
        actions[i][j][k] = a   # move

        return v

    def _evaluate(self,seq_idx,values,actions,gen_sequences):
        seq = self.init_states[seq_idx]
        n = len(seq)
        self.state_values[seq_idx] = self._eval_all(seq,values,actions,0,0,n-1)
        
        if gen_sequences:
            for i in range(n):
                for j in range(i,n):
                    for k in range(j+1,n):
                        if actions[i][j][k] != -1:
                            self.sequences_store.append((seq[i:j+1],seq[j+1:k+1],values[i][j][k],actions[i][j][k])) # (prefix,suffice,action)

    def calculate_state_values(self, gen_sequences = False):
        if gen_sequences:
            self.sequences_store = []

        if self.state_values is None:
            self.state_values = np.zeros(len(self.init_states))
        else:
            self.state_values.fill(0.0)

        n = 0
        for i in range(len(self.init_states)):
            seq = self.init_states[i]
            curr_n = len(seq)
            if  n < curr_n:
                n = curr_n
                values = np.zeros((n,n,n))
                actions = np.full((n,n,n),-1)
            else:
                values.fill(0.0)
                actions.fill(-1)

            self._evaluate(i,values,actions,gen_sequences)
