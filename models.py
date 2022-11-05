import torch
from torch_geometric.nn import GCNConv, ChebConv, GraphConv, SGConv, GraphNorm, LayerNorm, GatedGraphConv, DenseGraphConv, BatchNorm, SAGEConv, GATConv, PANConv, AGNNConv
from torch.nn import Linear, RNN, ReLU, LSTM, Embedding, LayerNorm, Dropout, GRU, Sigmoid, Softmax
import torch.nn.functional as F
from torch_geometric.nn import global_mean_pool, global_max_pool, global_add_pool
from torch.nn.utils.rnn import pack_padded_sequence, pad_packed_sequence



#
class Model_1(torch.nn.Module):
    def __init__(self, hidden_channels, in_channels, out_channels):
        super(Model_1, self).__init__()
        gnn = GraphConv  #SGConv #GraphConv #SAGEConv #SGConv #GCNConv 
        self.conv1 = gnn(in_channels, hidden_channels,  aggr='mean')
        self.conv2 = gnn(hidden_channels, hidden_channels,  aggr='mean')
        self.conv3 = gnn(hidden_channels, hidden_channels,  aggr='mean')
        
        self.lin1 = Linear(hidden_channels, hidden_channels)
        self.lin2 = Linear(hidden_channels, hidden_channels)
        self.lin = Linear(hidden_channels, out_channels)


    def forward(self, data):

        x, edge_index, batch = data[2], data[4], data[5]

        # 1. Obtain node embeddings 
        x = self.conv1(x, edge_index)
        x = x.relu()

        x = self.conv2(x, edge_index)
        x = x.relu()

        x = self.conv3(x, edge_index)

        # 2. Whole graph embedding
        x = global_mean_pool(x, batch)  # [batch_size, hidden_channels]

        x = F.dropout(x, p=0.5, training=self.training)

        # 3. Apply a final classifier
        x = self.lin1(x)
        x = x.relu()

        x = self.lin2(x)
        x = x.relu()

        x = self.lin(x)

        return x




class Model_2(torch.nn.Module):
    def __init__(self, hidden_channels, out_channels, vocab_size):
        super(Model_2, self).__init__()
        self.vocab_size = vocab_size
        self.rnn = GRU(vocab_size, hidden_channels, 1)
        self.lin = Linear(hidden_channels, out_channels)
        self.lin1 = Linear(hidden_channels, hidden_channels)
        self.lin2 = Linear(hidden_channels, hidden_channels)

    def __build_features_vec(self,token):
        features = [0]*self.vocab_size
        features[ token ] = 1
        return features

    def forward(self, data):
        x, lengths = data[2], data[4]

        # change every token by a corresponding one-hot vector
        x = torch.tensor([ [ self.__build_features_vec(i) for i in j ] for j in x.tolist() ]).to(torch.float)

        # pack all sequences (they are assumed to be padded and sorted by length)
        x = torch.nn.utils.rnn.pack_padded_sequence(x, lengths=lengths, batch_first=True)

        # apply rnn 
#        output, (x, cn) = self.rnn(x) # for LSTM
        output, x = self.rnn(x) # gor GRU

        # take the last output 
        x = x[0]

#        x.relu()
        # dropout
        x = F.dropout(x, p=0.5, training=self.training)

        # final linear layer
        x = self.lin1(x)
        x = x.relu()
        x = self.lin2(x)
        x = x.relu()

        x = self.lin(x)

        
        return x

class Model_3(torch.nn.Module):
    def __init__(self, hidden_channels, out_channels, vocab_size, embed_dim=64):
        super(Model_3, self).__init__()
        self.emb = Embedding(vocab_size, embed_dim, padding_idx=0) # we assume 0 was used for padding sequences
        self.rnn = LSTM(embed_dim, hidden_channels, 1)
        self.lin = Linear(hidden_channels, out_channels)
        # self.lin1 = Linear(hidden_channels, hidden_channels)
        # self.lin2 = Linear(hidden_channels, hidden_channels)

    def forward(self, data):

        x, lengths = data[2], data[4]

        # embedding of the tokens into a relatively small dimensional space
        x = self.emb(x)

        # pack all sequences (they are assumed to be padded and sorted by length)
        x = torch.nn.utils.rnn.pack_padded_sequence(x, lengths=lengths, batch_first=True)

        # 1. Obtain node embeddings 
        output, (x, cn) = self.rnn(x)
#        output, x = self.rnn(x)

        # take the last output 
        x = x[0]

        x = F.dropout(x, p=0.5, training=self.training)

        # x = self.lin1(x)
        # x = x.relu()
        # x = self.lin2(x)
        # x = x.relu()

        x = self.lin(x)

        return x

