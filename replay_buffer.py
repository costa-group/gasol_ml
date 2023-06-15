import numpy as np




class ReplayBuffer(object):
    def __init__(self, max_size, n_actions, state_encoder=lambda d: d, batch_encoder=lambda d : d):
        self.mem_size = max_size
        self.mem_cntr = 0
        self.state_encoder = state_encoder
        self.state_memory = {}
        self.new_state_memory = {}
        self.action_memory = {}
        self.reward_memory = {}
        self.terminal_memory = {}

    def store_transition(self, state, action, reward, state_, done):
        index = self.mem_cntr % self.mem_size
        self.state_memory[index] = state_encoder(state)
        self.new_state_memory[index] = state_encoder(state_)
        self.action_memory[index] = action
        self.reward_memory[index] = reward
        self.terminal_memory[index] = done
        self.mem_cntr += 1

    def sample_buffer(self, batch_size):
        max_mem = min(self.mem_cntr, self.mem_size)
        batch = np.random.choice(max_mem, batch_size, replace=False)

        states = [ self.state_memory[i] for i in batch ]
        actions = [ self.action[i] for i in batch ]
        rewards = [ self.reward_memory[i] for i in batch ]
        states_ = [ self.new_state_memory[i] for i in batch ]
        terminal = [ self.terminal_memory[i] for i in batch ]

        return batch_encoder(states), actions, rewards, batch_encoder(states_), terminal
