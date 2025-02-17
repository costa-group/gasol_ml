*** This REDAME.md is still under construction ***

# Requirements

Install a recent version of [PyTorch](https://pytorch.org/) and [PyTorch Geometric](https://pytorch-geometric.readthedocs.io/en/latest/).

# Data sets

The first time you run the program, the datasets are automatically downloaded from [https://costa.fdi.ucm.es/download/gasol_ml](https://costa.fdi.ucm.es/download/gasol_ml). Note that the first time you use these sets, it will take some time to build the processed data from the raw data.

The file [datasets_db.py](./datasets_db.py) includes a list of all available datasets.

# The Main module

This is the main program that can be use for training and testing, it has several parameters that allows controling the kind of neural netwrok to be used, its parameters, etc. Next we overview these parameters

```
(venv) samir@costa2:~/gasol-optimizer/gasol_ml$ python3 main.py --help
Command line: main.py --help

usage: main.py [-h] [-e EPOCHS] [-ds DATASET] [-ts TESTSET] [-of OUTFILENAME] [-op OUTPUTPATH] [-sm {all,last}] [-sio] [-lm LOADMODEL] [-lr LEARNINGRATE]
               [-lf {mse,cross_entropy,cross_entropy_w}] [-opt OPTIMIZER] [-hc HIDDENCHANNELS] [-lt LEARNINGTYPE] [-m MODEL] [-ed EMBEDDINGDIM]
               [-to_int {round,ceil,floor}] [-pt PROP_THRESHOLD] [-dop DROP_OUT_P] [-rnndop RNN_DROP_OUT_P] [-rnn {lstm,gru}] [-nt NUMTHREADS]
               [-opt_key {saved_size,saved_gas}] [-sim_t] [-bs BATCH_SIZE] [-nl LAYERS]

options:
  -h, --help            show this help message and exit
  -e EPOCHS, --epochs EPOCHS
  -ds DATASET, --dataset DATASET
  -ts TESTSET, --testset TESTSET
  -of OUTFILENAME, --outfilename OUTFILENAME
  -op OUTPUTPATH, --outputpath OUTPUTPATH
  -sm {all,last}, --savemodels {all,last}
  -sio, --saveimprovedonly
  -lm LOADMODEL, --loadmodel LOADMODEL
  -lr LEARNINGRATE, --learningrate LEARNINGRATE
  -lf {mse,cross_entropy,cross_entropy_w}, --lossfunction {mse,cross_entropy,cross_entropy_w}
  -opt OPTIMIZER, --optimizer OPTIMIZER
  -hc HIDDENCHANNELS, --hiddenchannels HIDDENCHANNELS
  -lt LEARNINGTYPE, --learningtype LEARNINGTYPE
  -m MODEL, --model MODEL
  -ed EMBEDDINGDIM, --embeddingdim EMBEDDINGDIM
  -to_int {round,ceil,floor}, --to_int {round,ceil,floor}
  -pt PROP_THRESHOLD, --prop_threshold PROP_THRESHOLD
  -dop DROP_OUT_P, --drop_out_p DROP_OUT_P
  -rnndop RNN_DROP_OUT_P, --rnn_drop_out_p RNN_DROP_OUT_P
  -rnn {lstm,gru}, --rnn_class {lstm,gru}
  -nt NUMTHREADS, --numthreads NUMTHREADS
  -opt_key {saved_size,saved_gas}, --opt_keyword {saved_size,saved_gas}
  -sim_t, --sim_train
  -bs BATCH_SIZE, --batch_size BATCH_SIZE
  -nl LAYERS, --layers LAYERS
```

# Training and building modules

# Testing modules


