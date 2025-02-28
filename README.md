# Requirements

Install a recent version of [PyTorch](https://pytorch.org/) and [PyTorch Geometric](https://pytorch-geometric.readthedocs.io/en/latest/).

# Datasets

The file [datasets_db.py](./datasets_db.py) includes a list of all available datasets. From this list, you can understand which encoding is used for each case (using GNNs or sequences of tokens).

The first time you run `main.py` in training mode, the datasets are automatically downloaded from [https://costa.fdi.ucm.es/download/gasol_ml/dataset/](https://costa.fdi.ucm.es/download/gasol_ml/dataset/) and the processed data is created from the raw data for the particular dataset used, which might take some time.

# The Main module `main.py`

This is the main program that can be used for training (and possibly testing). It has several parameters that allow you to control the type of neural network to be used, its parameters, etc. Here is a brief explanation of each parameter:

```
$ python3 main.py --help

usage: main.py [-h] [-e EPOCHS] [-ds DATASET] [-ts TESTSET] [-op OUTPUTPATH] [-sm {all,last}] [-sio] [-lm LOADMODEL] [-lr LEARNINGRATE]
               [-lf {mse,cross_entropy,cross_entropy_w}] [-opt OPTIMIZER] [-hc HIDDENCHANNELS] [-lt LEARNINGTYPE] [-m MODEL] [-ed EMBEDDINGDIM]
               [-to_int {round,ceil,floor}] [-pt PROP_THRESHOLD] [-dop DROP_OUT_P] [-rnndop RNN_DROP_OUT_P] [-rnn {lstm,gru}] [-nt NUMTHREADS]
               [-opt_key {saved_size,saved_gas}] [-bs BATCH_SIZE] [-nl LAYERS]

options:
```


*  `-h, --help show this help message and exit`: Shows usage information.

*  `-e EPOCHS, --epochs EPOCHS`: The number of epochs during training, with `1` being the default value.

*  `-ds DATASET, --dataset DATASET`: The index of the dataset to be used for training, as it appears in [datasets_db.py](./datasets_db.py). It will be divided into `80%` for training and `20%` for validation. Note that the type of the data set affects which models can be selected in the option `-m` -- it must be one that receives the corresponding encoding used in the dataset.

* `-ts DATASET, --dataset DATASET`: The index of the dataset to be used for testing, as it appears in [datasets_db.py](./datasets_db.py). After each epoch the current model will be tested on this set.

* `-of FILENAME, --outputfile FILENAME`: If provided, the model of the last epoch is save into `FILENAME`.

*  `-op OUTPUTPATH, --outputpath OUTPUTPATH`: The path where models are saved.

* `-sm {all,last}, --savemodels {all,last}`: Control which models to save, `all` models (at each epoch) or the `last` model. Each model is named `model_n.pyt` or `model_i_n.pyt`, where `n` is the number of the epoch in which it was generated, and `i` indicates that it is an improvement over the previous one, according to the precision measure used.

*  `-lm LOADMODEL, --loadmodel LOADMODEL`: Start from a model that has been saved before. It is mainly used to test existing models on new datasets.

*  `-lr LEARNINGRATE, --learningrate LEARNINGRATE`: The learning rate to be used during training, with `1e-3` being the default value.

*  `-lf {mse,cross_entropy,cross_entropy_w}, --lossfunction {mse,cross_entropy,cross_entropy_w}`: The loss function to use during training, with `mse` being the default value.

*  `-opt {adam,sgd}, --optimizer {adam,sgd}`: The optimizer to use during training, by default it is `adam` (for `torch.optim.Adam`), and it can also be `sgd` for (`torch.optim.SGD`).

*  `-hc HIDDENCHANNELS, --hiddenchannels HIDDENCHANNELS`: The models in [nn_models.py](./nn_models.py) typically end with a standard feed-forward deep neural network. This parameter controls the number of channels, with `128` being the default value.

*  `-lt {regression,classification}, --learningtype {regression,classification}`: Specify if we are modeling a `regression` or a `classification` problem, with `regression` being the default value.

* `-m MODEL, --model MODEL`: The model to use for training, using the name as it appears in `nn_models.py` (see the comments in that file for more information on each). Note that you should use a model that accepts the encoding of the selected dataset.

*  `-ed EMBEDDINGDIM, --embeddingdim EMBEDDINGDIM`: The dimension of the space used for embedding, when not specified the models use one-hot encoding.

* `-to_int {round,ceil,floor}, --to_int {round,ceil,floor}`: How to convert a real number to an integer, where `round` is the default. This is needed when predicting the size of the optimal block (using regression), since the size is an integer but the models output a real number.

*  `-pt PROP_THRESHOLD, --prop_threshold PROP_THRESHOLD`: The probability threshold to be used in binary classification problems.

*  `-dop DROP_OUT_P, --drop_out_p DROP_OUT_P`: The probability to be used in the dropout layer, with `0.5` being the default value.

*  `-rnndop RNN_DROP_OUT_P, --rnn_drop_out_p RNN_DROP_OUT_P`: The probability to be used in the dropout of the corresponding RNN, with `0` being the default value.

*  `-rnn {lstm,gru}, --rnn_class {lstm,gru}`: The type of RNN to be used.

*  `-nt NUMTHREADS, --numthreads NUMTHREADS`: Number of threads to be used by `PyTorch`.

*  `-opt_key {saved_size,saved_gas}, --opt_keyword {saved_size,saved_gas}`: This is very specific to the dataset and classification problems, which indicates the key (in the corresponding dataset) to be used to obtain the saving (in gas consumption or in block size).

*  `-bs BATCH_SIZE, --batch_size BATCH_SIZE`: The size of the batch during training, with `64` being the default value.

* `-nl LAYERS, --layers LAYERS`: The models in [nn_models.py](./nn_models.py) typically end with a standard feed-forward deep neural network. This parameter controls the number of layers, with `1` being the default value.


# Training 

The file `train.sh` contains several command lines to train on different datasets and configurations. The ones selected in the experiments of the paper can be generated with the following commands:

* Predicting a bound on the size of the optimal block (optimality wrt. to the block size): 

   `python3 main.py -ds 215 -e 47 -nt 1 -m nn_models.Model_2 -ed 64 -rnn gru -sm last -op /tmp`

* Predicting if a given block is already optimal (optimality wrt. to the block size): 

   `python3 main.py -ds 221 -e 50 -nt 1 -m nn_models.Model_2 -rnn lstm -lt classification -lf cross_entropy -sm last -opt_key saved_size -op /tmp`

* Predicting a bound on the size of the optimal block (optimality wrt. to the gas consumption): 

   `python3 main.py -ds 255 -e 49 -nt 1 -m nn_models.Model_2 -ed 64 -rnn gru -sm last -op /tmp`

* Predicting if a given block is already optimal (optimality wrt. to the gas consumption): 

   `python3 main.py -ds 261 -e 47 -nt 1 -m nn_models.Model_2 -rnn lstm -lt classification -lf cross_entropy -sm last -opt_key saved_gas -op /tmp`


# Testing models

First, note that during training, we can provide a test dataset using the `-ts` parameter and the model of each epoch is evaluated on that test set. In what follows we describe how to test an existing model on a given set.


## Classification problem

Supposes we have generated a model `model.pyt` using:

```
python3 main.py -ds 242 -e 50 -nt 1 -m nn_models.Model_2 -rnn lstm -lt classification -lf cross_entropy -sm all -opt_key saved_gas
```

then we can test it on a set with identifier `X` using the following:

```
python3 main.py -ts X -lm model.pyt -lt classification -lf cross_entropy -opt_key saved_gas
```

Note that we have to use the same values for options `-lt`, `-lf` and `-opt_key`.


## Regression problem

Supposes we have generated a model `model.pyt` using:

```
python3 main.py -ds 215 -e 47 -nt 1 -m nn_models.Model_2 -ed 64 -rnn gru -sm all 
```

We can test it on a set with identifier `X` using the following:

```
python3 main.py -ts X -lm model.pyt
```

## Example

The following command lines can be used to test the models we have generated on the test sets used in the experimental evaluation section. Each case has two command lines, the first using all blocks without eliminating repetitions and the second with repetitions eliminated.

### Test set 1 (100 contracts)

* Predicting a bound on the size of the optimal block (optimality wrt. to the block size): 

   `python3 main.py -ts 3150 -nt 1 -lm models/bound_size.pyt -op /tmp`

   `python3 main.py -ts 3151 -nt 1 -lm models/bound_size.pyt -op /tmp`

* Predicting if a given block is already optimal (optimality wrt. to the block size): 

   `python3 main.py -ts 3210 -nt 1 -lt classification -lf cross_entropy -opt_key saved_size -lm models/opt_size.pyt -op /tmp`

   `python3 main.py -ts 3211 -nt 1 -lt classification -lf cross_entropy -opt_key saved_size -lm models/opt_size.pyt -op /tmp`

* Predicting a bound on the size of the optimal block (optimality wrt. to the gas consumption): 

   `python3 main.py -ds 3550 -nt 1 -lm models/bound_gas.pyt -op /tmp`

   `python3 main.py -ds 3551 -nt 1 -lm models/bound_gas.pyt -op /tmp`

* Predicting if a given block is already optimal (optimality wrt. to the gas consumption): 

   `python3 main.py -ds 3610 -nt 1 -lt classification -lf cross_entropy -opt_key saved_gas  -lm models/opt_gas.pyt -op /tmp`

   `python3 main.py -ds 3611 -nt 1 -lt classification -lf cross_entropy -opt_key saved_gas  -lm models/opt_gas.pyt -op /tmp`

### Test set 2 (1000 contracts)

* Predicting a bound on the size of the optimal block (optimality wrt. to the block size): 

   `python3 main.py -ts 4150 -nt 1 -lm models/bound_size.pyt -op /tmp`

   `python3 main.py -ts 4151 -nt 1 -lm models/bound_size.pyt -op /tmp`

* Predicting if a given block is already optimal (optimality wrt. to the block size): 

   `python3 main.py -ts 4210 -nt 1 -lt classification -lf cross_entropy -opt_key saved_size -lm models/opt_size.pyt -op /tmp`

   `python3 main.py -ts 4211 -nt 1 -lt classification -lf cross_entropy -opt_key saved_size -lm models/opt_size.pyt -op /tmp`

* Predicting a bound on the size of the optimal block (optimality wrt. to the gas consumption): 

   `python3 main.py -ds 4550 -nt 1 -lm models/bound_gas.pyt -op /tmp`

   `python3 main.py -ds 4551 -nt 1 -lm models/bound_gas.pyt -op /tmp`

* Predicting if a given block is already optimal (optimality wrt. to the gas consumption): 

   `python3 main.py -ds 4610 -nt 1 -lt classification -lf cross_entropy -opt_key saved_gas  -lm models/opt_gas.pyt -op /tmp`

   `python3 main.py -ds 4611 -nt 1 -lt classification -lf cross_entropy -opt_key saved_gas  -lm models/opt_gas.pyt -op /tmp`

# Using a model within GASOL

The modules [opt_predictor.py](./opt_predictor.py) and [bound_predictor.py](./bound_predictor.py) can be used to use an existing model within GASOL (these files inlucde usage information as comments). They are mainly used with the models available in the directory [models](./models).
