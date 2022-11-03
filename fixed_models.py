import torch
from torch_geometric.nn import GCNConv, ChebConv, GraphConv, SGConv, GraphNorm, LayerNorm, GatedGraphConv, DenseGraphConv, BatchNorm, SAGEConv, GATConv, PANConv, AGNNConv
from torch.nn import Linear, RNN, ReLU, LSTM, Embedding, LayerNorm, Dropout, GRU, Sigmoid, Softmax
import torch.nn.functional as F
from torch_geometric.nn import global_mean_pool, global_max_pool, global_add_pool
from torch.nn.utils.rnn import pack_padded_sequence, pad_packed_sequence



class Model_bound_predictor_size_01112022_0645_costa2(torch.nn.Module):
    def __init__(self, hidden_channels, in_channels, out_channels):
        super(Model_bound_predictor_size_01112022_0645_costa2, self).__init__()
        gnn = GraphConv 
        self.conv1 = gnn(in_channels, hidden_channels,  aggr='mean')
        self.conv2 = gnn(hidden_channels, hidden_channels,  aggr='mean')
        self.conv3 = gnn(hidden_channels, hidden_channels,  aggr='mean')
        
        self.lin1 = Linear(hidden_channels, hidden_channels)
        self.lin2 = Linear(hidden_channels, hidden_channels)
        self.lin = Linear(hidden_channels, out_channels)


    def forward(self, data):

        x, edge_index, batch = data.x, data.edge_index, data.batch

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




class Model_opt_classifier_size_03112022_1230_samirpc(torch.nn.Module):
    def __init__(self, hidden_channels, out_channels, vocab_size, embed_dim=16):
        super(Model_opt_classifier_size_03112022_1230_samirpc, self).__init__()
        self.emb = Embedding(vocab_size, embed_dim, padding_idx=0) # we assume 0 was used for padding sequences
        self.rnn = LSTM(embed_dim, hidden_channels, 1)
        self.lin = Linear(hidden_channels, out_channels)
        self.lin1 = Linear(hidden_channels, hidden_channels)
        self.lin2 = Linear(hidden_channels, hidden_channels)

    def forward(self, data):

        x, lengths = data[0], data[2]

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

        x = self.lin1(x)
        x = x.relu()
        x = self.lin2(x)
        x = x.relu()

        x = self.lin(x)

        return x


