import torch
from torch_geometric.nn import GCNConv, ChebConv, GraphConv, SGConv
from torch.nn import Linear
import torch.nn.functional as F
from torch_geometric.nn import global_mean_pool


#
class Model_1(torch.nn.Module):
    def __init__(self, hidden_channels, num_node_features, num_classes):
        super(Model_1, self).__init__()
        self.conv1 = GraphConv(num_node_features, hidden_channels)
        self.conv2 = GraphConv(hidden_channels, hidden_channels)
        self.conv3 = GraphConv(hidden_channels, hidden_channels)
        self.lin = Linear(hidden_channels, hidden_channels)


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

