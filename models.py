import torch
from torch_geometric.nn import GCNConv, ChebConv, GraphConv, SGConv
from torch.nn import Linear, RNN, ReLU, LSTM
import torch.nn.functional as F
from torch_geometric.nn import global_mean_pool
from torch.nn.utils.rnn import pack_padded_sequence, pad_packed_sequence


#
class Model_1(torch.nn.Module):
    def __init__(self, hidden_channels, num_node_features, num_classes):
        super(Model_1, self).__init__()
        self.conv1 = GraphConv(num_node_features, hidden_channels)
        self.conv2 = GraphConv(hidden_channels, hidden_channels)
        self.conv3 = GraphConv(hidden_channels, hidden_channels)
        self.lin = Linear(hidden_channels, num_classes)

    def forward(self, x, edge_index, batch):

        # 1. Obtain node embeddings 
        x = self.conv1(x, edge_index)
        x = x.relu()
        x = self.conv2(x, edge_index)
        x = x.relu()
        x = self.conv3(x, edge_index)

        # 2. Readout layer
        x = global_mean_pool(x, batch)  # [batch_size, hidden_channels]

        # 3. Apply a final classifier
        x = F.dropout(x, p=0.5, training=self.training)
        x = self.lin(x)

        return x


class Model_2(torch.nn.Module):
    def __init__(self, hidden_channels, input_size, num_classes):
        super(Model_2, self).__init__()
        self.rnn = LSTM(input_size, hidden_channels, 1)
        self.lin = Linear(hidden_channels, num_classes)
        self.m = ReLU()

    def forward(self, x):

        # 1. Obtain node embeddings 
        output, (x, cn) = self.rnn(x)
#        x = output
        #x = x[0]
#        x = self.m(x)
        x = F.dropout(x, p=0.5, training=self.training)
        x = self.lin(x)

        return x[0]

