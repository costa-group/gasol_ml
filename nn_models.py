import torch
from torch_geometric.nn import GCNConv, ChebConv, GraphConv, SGConv, GraphNorm, LayerNorm, GatedGraphConv, DenseGraphConv, BatchNorm, SAGEConv, GATConv, PANConv, AGNNConv
from torch.nn import Linear, RNN, ReLU, LSTM, Embedding, LayerNorm, Dropout, GRU, Sigmoid, Softmax
import torch.nn.functional as F
from torch_geometric.nn import global_mean_pool, global_max_pool, global_add_pool
from torch.nn.utils.rnn import pack_padded_sequence, pad_packed_sequence
import math


# This model receives pyg graphs as input, can be used for regression
# or classification
#
class Model_1(torch.nn.Module):
    def __init__(self, dataset, args):
        super(Model_1, self).__init__()

        hidden_channels = args.hiddenchannels
        in_channels = dataset.num_node_features
        out_channels = 1 if args.learningtype == 'regression' else dataset.num_classes
        
        
        gnn = GraphConv #GraphConv  #SGConv #GraphConv #SAGEConv #SGConv #GCNConv 
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

        x = F.dropout(x, p=0.1, training=self.training)

        # 3. Apply a final classifier
        x = self.lin1(x)
        x = x.relu()

        x = self.lin2(x)
        x = x.relu()

        x = self.lin(x)

        return x



# This model is supposed to receives sequences as input
#
class Model_2(torch.nn.Module):
    def __init__(self, dataset, args):
        super(Model_2, self).__init__()

        hidden_channels = args.hiddenchannels
        vocab_size = dataset.vocab_size
        out_channels = 1 if args.learningtype == 'regression' else dataset.num_classes

        self.vocab_size = vocab_size
        self.rnn = LSTM(vocab_size, hidden_channels, 1)
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
        output, (x, cn) = self.rnn(x) # for LSTM
#        output, x = self.rnn(x) # for GRU

        # take the last output 
        x = x[0]

        x = F.dropout(x, p=0.5, training=self.training)

        # final linear layer
        x = self.lin1(x)
        x = x.relu()
        x = self.lin2(x)
        x = x.relu()

        x = self.lin(x)

        
        return x

# This model is supposed to receives sequences as input
#
class Model_3(torch.nn.Module):
    def __init__(self, dataset, args):
        super(Model_3, self).__init__()

        hidden_channels = args.hiddenchannels
        vocab_size = dataset.vocab_size
        out_channels = 1 if args.learningtype == 'regression' else dataset.num_classes
        embed_dim=args.embeddingdim
         
        self.emb = Embedding(vocab_size, embed_dim, padding_idx=0) # we assume 0 was used for padding sequences
        self.rnn = GRU(embed_dim, hidden_channels, 1)
        self.lin = Linear(hidden_channels, out_channels)
        self.lin1 = Linear(hidden_channels, hidden_channels)
        self.lin2 = Linear(hidden_channels, hidden_channels)

    def forward(self, data):

        x, lengths = data[2], data[4]

        # embedding of the tokens into a relatively small dimensional space
        x = self.emb(x)

        # pack all sequences (they are assumed to be padded and sorted by length)
        x = torch.nn.utils.rnn.pack_padded_sequence(x, lengths=lengths, batch_first=True)

        # 1. Obtain node embeddings 
#        output, (x, cn) = self.rnn(x) # for LSTM
        output, x = self.rnn(x) # for GRU

        # take the last output 
        x = x[0]

        x = F.dropout(x, p=0.5, training=self.training)

        x = self.lin1(x)
        x = x.relu()
        
        x = self.lin2(x)
        x = x.relu()

        x = self.lin(x)

        return x


class PositionalEncoding(torch.nn.Module):
    """
    https://pytorch.org/tutorials/beginner/transformer_tutorial.html
    """

    def __init__(self, d_model, vocab_size=5000, dropout=0.1):
        super().__init__()
        self.dropout = torch.nn.Dropout(p=dropout)

        pe = torch.zeros(vocab_size, d_model)
        position = torch.arange(0, vocab_size, dtype=torch.float).unsqueeze(1)
        div_term = torch.exp(
            torch.arange(0, d_model, 2).float()
            * (-math.log(10000.0) / d_model)
        )
        pe[:, 0::2] = torch.sin(position * div_term)
        pe[:, 1::2] = torch.cos(position * div_term)
        pe = pe.unsqueeze(0)
        self.register_buffer("pe", pe)

    def forward(self, x):
        x = x + self.pe[:, : x.size(1), :]
        return self.dropout(x)


class Model_4(torch.nn.Module):
    def __init__(self, dataset, args):
        super(Model_4, self).__init__()

        vocab_size = dataset.vocab_size
        embed_dim=args.embeddingdim

        nhead=8
        dim_feedforward=2048
        num_layers=6
        dropout=0.1
        activation="relu"
        classifier_dropout=0.1

        self.emb = Embedding(vocab_size, embed_dim, padding_idx=0) # we assume 0 was used for padding sequences
        d_model = embed_dim
        assert d_model % nhead == 0, "nheads must divide evenly into d_model"

        self.pos_encoder = PositionalEncoding(
            d_model=d_model,
            dropout=dropout,
            vocab_size=vocab_size,
        )

        encoder_layer = torch.nn.TransformerEncoderLayer(
            d_model=d_model,
            nhead=nhead,
            dim_feedforward=dim_feedforward,
            dropout=dropout,
        )
        self.transformer_encoder = torch.nn.TransformerEncoder(
            encoder_layer,
            num_layers=num_layers,
        )
        self.classifier = torch.nn.Linear(d_model, 2)
        self.d_model = d_model

    def forward(self, data):
        x, lengths = data[2], data[4]
        x = self.emb(x) * math.sqrt(self.d_model)

        x = self.pos_encoder(x)
        x = torch.nn.utils.rnn.pack_padded_sequence(x, lengths=lengths, batch_first=True)
        x = self.transformer_encoder(x)
        x = x.mean(dim=1)
        x = self.classifier(x)

        return x
