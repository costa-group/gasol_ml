*** This REDAME.md is still under construction ***

# Requirements

Install a recent version of [PyTorch](https://pytorch.org/) and [PyTorch Geometric](https://pytorch-geometric.readthedocs.io/en/latest/).

# Data sets

The first time you run the program, the datasets are automatically downloaded from [https://costa.fdi.ucm.es/download/gasol_ml](https://costa.fdi.ucm.es/download/gasol_ml). Note that the first time you use these sets, it will take some time to build the processed data from the raw data.

The file [datasets_db.py](./datasets_db.py) includes a list of all available datasets.

# The Main module

This is the main program that can be use for training and testing, it has several parameters that allows controlling the kind of neural network to be used, its parameters, etc. Next we overview these parameters

```
(venv) samir@costa2:~/gasol-optimizer/gasol_ml$ python3 main.py --help
Command line: main.py --help

usage: main.py [-h] [-e EPOCHS] [-ds DATASET] [-ts TESTSET] [-of OUTFILENAME] [-op OUTPUTPATH] [-sm {all,last}] [-sio] [-lm LOADMODEL] [-lr LEARNINGRATE]
               [-lf {mse,cross_entropy,cross_entropy_w}] [-opt OPTIMIZER] [-hc HIDDENCHANNELS] [-lt LEARNINGTYPE] [-m MODEL] [-ed EMBEDDINGDIM]
               [-to_int {round,ceil,floor}] [-pt PROP_THRESHOLD] [-dop DROP_OUT_P] [-rnndop RNN_DROP_OUT_P] [-rnn {lstm,gru}] [-nt NUMTHREADS]
               [-opt_key {saved_size,saved_gas}] [-sim_t] [-bs BATCH_SIZE] [-nl LAYERS]

options:
```


*  `-h, --help show this help message and exit`: shows usage information.
*  `-e EPOCHS, --epochs EPOCHS`: the number of epochs during training, with `1` as default value.
*  `-ds DATASET, --dataset DATASET`: the index of the data set to be used, as it appears in [datasets_db.py](./datasets_db.py). It will be divided into `80%` for training and `20%` for validation.
*  `-ts TESTSET, --testset TESTSET`: the index of the data set to be used for testing, after each EPOCH, as it appears in [datasets_db.py](./datasets_db.py). If not available no testing is performed (only validation).
*  `-of OUTFILENAME, --outfilename OUTFILENAME`: This option is just kept for backwards compatability. It used to be the filename where the learned model is saved, which is not written in the output path (see next option) with a filename prefix `model_` followed by the number of epoch and `i` if it is a model that improved the one of the previous epoch.
*  `-op OUTPUTPATH, --outputpath OUTPUTPATH`: the path where models are saved.
*  `-sm {all,last}, --savemodels {all,last}`: control which models are saved, `all` models (at each epoch) or the `last` one.
*  `-sio, --saveimprovedonly`: save only models that improve on previous ones.
*  `-lm LOADMODEL, --loadmodel LOADMODEL`: start from a model that has been saved before. It is used to test models on new data sets.
*  `-lr LEARNINGRATE, --learningrate LEARNINGRATE`: the learning rate to be used during training, with `1e-3` as default value.
*  `-lf {mse,cross_entropy,cross_entropy_w}, --lossfunction {mse,cross_entropy,cross_entropy_w}`: the loss function to use during training. 
*  `-opt {adam,sgd}, --optimizer {adam,sgd}`: the optimizer to use during training, by default it is `adam` (for `torch.optim.Adam`), and it can be `sgd` for (`torch.optim.SGD`)
*  `-hc HIDDENCHANNELS, --hiddenchannels HIDDENCHANNELS`: the models in [nn_models.py](./nn_models.py) typically end with a standard feed-forward deep neural network. This parameter control the number of hidden channels which is `128` by default.
*  `-lt {regression,classification}, --learningtype {regression,classification}`: specify if we are model a regression or a classification problem.
*  `-m MODEL, --model MODEL`: the mode to be used, should be one of those in `nn_models.py`.
*  `-ed EMBEDDINGDIM, --embeddingdim EMBEDDINGDIM`: some dimension of the embedding, when not specified the models use one-hot encoding.
*  `-to_int {round,ceil,floor}, --to_int {round,ceil,floor}`: how to convert real numbers to integers, with default value `round`. This is needed since the output of the regression problems in our case is integer, and thus we need to convert the output of the model to an integer.
*  `-pt PROP_THRESHOLD, --prop_threshold PROP_THRESHOLD`: this is used in classification problems to decide the class.
*  `-dop DROP_OUT_P, --drop_out_p DROP_OUT_P`: the probability for the drop out layer, with `0.5` as default value.
*  `-rnndop RNN_DROP_OUT_P, --rnn_drop_out_p RNN_DROP_OUT_P`: not used, kept for backwards comparability.
*  `-rnn {lstm,gru}, --rnn_class {lstm,gru}`: the type of RNN to be used.
*  `-nt NUMTHREADS, --numthreads NUMTHREADS`: number of thread for `PyTorch`.
*  `-opt_key {saved_size,saved_gas}, --opt_keyword {saved_size,saved_gas}`: This is very specific to the data set, which indicates the key (in the corresponding JSON) to be used to obtain the saving. This is mainly used for printing some statistics.
*  `-sim_t, --sim_train`:  We use this to print statistics of a model that we have already trained (splitting into training and validation set.
*  `-bs BATCH_SIZE, --batch_size BATCH_SIZE`: The size of the batch, with `64` as default value.
*  `-nl LAYERS, --layers LAYERS`: the models in [nn_models.py](./nn_models.py) typically end with a standard feed-forward deep neural network. This parameter control the number of layers which is `1` by default.

# Training and building modules

# Testing modules


