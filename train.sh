
python='python3'
tmp='tmp'

# SIZE 


## BOUND

### GNN
echo "$python main.py -ds 211 -e 50 -nt 1 -sm all -op $tmp/reg_ds_211 > $tmp/reg_ds_211/log.txt"
mkdir -p $tmp/reg_ds_211
$python main.py -ds 211 -e 50 -nt 1 -sm all -op $tmp/reg_ds_211 > $tmp/reg_ds_211/log.txt

echo "$python main.py -ds 212 -e 50 -nt 1 -sm all -op $tmp/reg_ds_212 > $tmp/reg_ds_212/log.txt"
mkdir -p $tmp/reg_ds_212
$python main.py -ds 212 -e 50 -nt 1 -sm all -op $tmp/reg_ds_212 > $tmp/reg_ds_212/log.txt

echo "$python main.py -ds 213 -e 50 -nt 1 -sm all -op $tmp/reg_ds_213 > $tmp/reg_ds_213/log.txt"
mkdir -p $tmp/reg_ds_213
$python main.py -ds 213 -e 50 -nt 1 -sm all -op $tmp/reg_ds_213 > $tmp/reg_ds_213/log.txt

echo "$python main.py -ds 214 -e 50 -nt 1 -sm all -op $tmp/reg_ds_214 > $tmp/reg_ds_214/log.txt"
mkdir -p $tmp/reg_ds_214
$python main.py -ds 214 -e 50 -nt 1 -sm all -op $tmp/reg_ds_214 > $tmp/reg_ds_214/log.txt


### using rnn with set 215 (abstract values kept)
echo "$python main.py -ds 215 -e 50 -nt 1 -m nn_models.Model_2 -rnn lstm -sm all -op $tmp/reg_ds_lstm_215 > $tmp/reg_ds_lstm_215/log.txt"
mkdir -p $tmp/reg_ds_lstm_215
$python main.py -ds 215 -e 50 -nt 1 -m nn_models.Model_2 -rnn lstm -sm all -op $tmp/reg_ds_lstm_215 > $tmp/reg_ds_lstm_215/log.txt

echo "$python main.py -ds 215 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn lstm -sm all -op $tmp/reg_ds_lstm_ed64_215 > $tmp/reg_ds_lstm_ed64_215/log.txt"
mkdir -p $tmp/reg_ds_lstm_ed64_215
$python main.py -ds 215 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn lstm -sm all -op $tmp/reg_ds_lstm_ed64_215 > $tmp/reg_ds_lstm_ed64_215/log.txt

echo "$python main.py -ds 215 -e 50 -nt 1 -m nn_models.Model_2 -rnn gru -sm all -op $tmp/reg_ds_gru_215 > $tmp/reg_ds_gru_215/log.txt"
mkdir -p $tmp/reg_ds_gru_215
$python main.py -ds 215 -e 50 -nt 1 -m nn_models.Model_2 -rnn gru -sm all -op $tmp/reg_ds_gru_215 > $tmp/reg_ds_gru_215/log.txt

echo "$python main.py -ds 215 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn gru -sm all -op $tmp/reg_ds_gru_ed64_215 > $tmp/reg_ds_gru_ed64_215/log.txt"
mkdir -p $tmp/reg_ds_gru_ed64_215
$python main.py -ds 215 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn gru -sm all -op $tmp/reg_ds_gru_ed64_215 > $tmp/reg_ds_gru_ed64_215/log.txt


### using rnn with set 216 (values removed)
echo "$python main.py -ds 216 -e 50 -nt 1 -m nn_models.Model_2 -rnn lstm -sm all -op $tmp/reg_ds_lstm_216 > $tmp/reg_ds_lstm_216/log.txt"
mkdir -p $tmp/reg_ds_lstm_216
$python main.py -ds 216 -e 50 -nt 1 -m nn_models.Model_2 -rnn lstm -sm all -op $tmp/reg_ds_lstm_216 > $tmp/reg_ds_lstm_216/log.txt

echo "$python main.py -ds 216 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn lstm -sm all -op $tmp/reg_ds_lstm_ed64_216 > $tmp/reg_ds_lstm_ed64_216/log.txt"
mkdir -p $tmp/reg_ds_lstm_ed64_216
$python main.py -ds 216 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn lstm -sm all -op $tmp/reg_ds_lstm_ed64_216 > $tmp/reg_ds_lstm_ed64_216/log.txt

echo "$python main.py -ds 216 -e 50 -nt 1 -m nn_models.Model_2 -rnn gru -sm all -op $tmp/reg_ds_gru_216 > $tmp/reg_ds_gru_216/log.txt"
mkdir -p $tmp/reg_ds_gru_216
$python main.py -ds 216 -e 50 -nt 1 -m nn_models.Model_2 -rnn gru -sm all -op $tmp/reg_ds_gru_216 > $tmp/reg_ds_gru_216/log.txt

echo "$python main.py -ds 216 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn gru -sm all -op $tmp/reg_ds_gru_ed64_216 > $tmp/reg_ds_gru_ed64_216/log.txt"
mkdir -p $tmp/reg_ds_gru_ed64_216
$python main.py -ds 216 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn gru -sm all -op $tmp/reg_ds_gru_ed64_216 > $tmp/reg_ds_gru_ed64_216/log.txt

## OPT

### using rnn with set 221 (abstract values kept)
echo "$python main.py -ds 221 -e 50 -nt 1 -m nn_models.Model_2 -rnn lstm -lt classification -lf cross_entropy -sm all -opt_key saved_size -op $tmp/cl_ds_lstm_221 > $tmp/cl_ds_lstm_221/log.txt"
mkdir -p $tmp/cl_ds_lstm_221
$python main.py -ds 221 -e 50 -nt 1 -m nn_models.Model_2 -rnn lstm -lt classification -lf cross_entropy -sm all -opt_key saved_size -op $tmp/cl_ds_lstm_221 > $tmp/cl_ds_lstm_221/log.txt

echo "$python main.py -ds 221 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn lstm -lt classification -lf cross_entropy -sm all -opt_key saved_size -op $tmp/cl_ds_lstm_ed64_221 > $tmp/cl_ds_lstm_ed64_221/log.txt"
mkdir -p $tmp/cl_ds_lstm_ed64_221
$python main.py -ds 221 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn lstm -lt classification -lf cross_entropy -sm all -opt_key saved_size -op $tmp/cl_ds_lstm_ed64_221 > $tmp/cl_ds_lstm_ed64_221/log.txt

echo "$python main.py -ds 221 -e 50 -nt 1 -m nn_models.Model_2 -rnn gru -lt classification -lf cross_entropy -sm all -opt_key saved_size -op $tmp/cl_ds_gru_221 > $tmp/cl_ds_gru_221/log.txt"
mkdir -p $tmp/cl_ds_gru_221
$python main.py -ds 221 -e 50 -nt 1 -m nn_models.Model_2 -rnn gru -lt classification -lf cross_entropy -sm all -opt_key saved_size -op $tmp/cl_ds_gru_221 > $tmp/cl_ds_gru_221/log.txt

echo "$python main.py -ds 221 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn gru -lt classification -lf cross_entropy -sm all -opt_key saved_size -op $tmp/cl_ds_gru_ed64_221 > $tmp/cl_ds_gru_ed64_221/log.txt"
mkdir -p $tmp/cl_ds_gru_ed64_221
$python main.py -ds 221 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn gru -lt classification -lf cross_entropy -sm all -opt_key saved_size -op $tmp/cl_ds_gru_ed64_221 > $tmp/cl_ds_gru_ed64_221/log.txt


### using rnn with set 222 (abstract values removed)
echo "$python main.py -ds 222 -e 50 -nt 1 -m nn_models.Model_2 -rnn lstm -lt classification -lf cross_entropy -sm all -opt_key saved_size -op $tmp/cl_ds_lstm_222 > $tmp/cl_ds_lstm_222/log.txt"
mkdir -p $tmp/cl_ds_lstm_222
$python main.py -ds 222 -e 50 -nt 1 -m nn_models.Model_2 -rnn lstm -lt classification -lf cross_entropy -sm all -opt_key saved_size -op $tmp/cl_ds_lstm_222 > $tmp/cl_ds_lstm_222/log.txt

echo "$python main.py -ds 222 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn lstm -lt classification -lf cross_entropy -sm all -opt_key saved_size -op $tmp/cl_ds_lstm_ed64_222 > $tmp/cl_ds_lstm_ed64_222/log.txt"
mkdir -p $tmp/cl_ds_lstm_ed64_222
$python main.py -ds 222 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn lstm -lt classification -lf cross_entropy -sm all -opt_key saved_size -op $tmp/cl_ds_lstm_ed64_222 > $tmp/cl_ds_lstm_ed64_222/log.txt

echo "$python main.py -ds 222 -e 50 -nt 1 -m nn_models.Model_2 -rnn gru -lt classification -lf cross_entropy -sm all -opt_key saved_size -op $tmp/cl_ds_gru_222 > $tmp/cl_ds_gru_222/log.txt"
mkdir -p $tmp/cl_ds_gru_222
$python main.py -ds 222 -e 50 -nt 1 -m nn_models.Model_2 -rnn gru -lt classification -lf cross_entropy -sm all -opt_key saved_size -op $tmp/cl_ds_gru_222 > $tmp/cl_ds_gru_222/log.txt

echo "$python main.py -ds 222 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn gru -lt classification -lf cross_entropy -sm all -opt_key saved_size -op $tmp/cl_ds_gru_ed64_222 > $tmp/cl_ds_gru_ed64_222/log.txt"
mkdir -p $tmp/cl_ds_gru_ed64_222
$python main.py -ds 222 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn gru -lt classification -lf cross_entropy -sm all -opt_key saved_size -op $tmp/cl_ds_gru_ed64_222 > $tmp/cl_ds_gru_ed64_222/log.txt




# GAS

## BOUND

### GNN
echo "$python main.py -ds 231 -e 50 -nt 1 -sm all -op $tmp/reg_ds_231 > $tmp/reg_ds_231/log.txt"
mkdir -p $tmp/reg_ds_231
$python main.py -ds 231 -e 50 -nt 1 -sm all -op $tmp/reg_ds_231 > $tmp/reg_ds_231/log.txt

echo "$python main.py -ds 232 -e 50 -nt 1 -sm all -op $tmp/reg_ds_232 > $tmp/reg_ds_232/log.txt"
mkdir -p $tmp/reg_ds_232
$python main.py -ds 232 -e 50 -nt 1 -sm all -op $tmp/reg_ds_232 > $tmp/reg_ds_232/log.txt

echo "$python main.py -ds 233 -e 50 -nt 1 -sm all -op $tmp/reg_ds_233 > $tmp/reg_ds_233/log.txt"
mkdir -p $tmp/reg_ds_233
$python main.py -ds 233 -e 50 -nt 1 -sm all -op $tmp/reg_ds_233 > $tmp/reg_ds_233/log.txt

echo "$python main.py -ds 234 -e 50 -nt 1 -sm all -op $tmp/reg_ds_234 > $tmp/reg_ds_234/log.txt"
mkdir -p $tmp/reg_ds_234
$python main.py -ds 234 -e 50 -nt 1 -sm all -op $tmp/reg_ds_234 > $tmp/reg_ds_234/log.txt


### using rnn with set 235 (abstract values kept)
echo "$python main.py -ds 235 -e 50 -nt 1 -m nn_models.Model_2 -rnn lstm -sm all -op $tmp/reg_ds_lstm_235 > $tmp/reg_ds_lstm_235/log.txt"
mkdir -p $tmp/reg_ds_lstm_235
$python main.py -ds 235 -e 50 -nt 1 -m nn_models.Model_2 -rnn lstm -sm all -op $tmp/reg_ds_lstm_235 > $tmp/reg_ds_lstm_235/log.txt

echo "$python main.py -ds 235 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn lstm -sm all -op $tmp/reg_ds_lstm_ed64_235 > $tmp/reg_ds_lstm_ed64_235/log.txt"
mkdir -p $tmp/reg_ds_lstm_ed64_235
$python main.py -ds 235 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn lstm -sm all -op $tmp/reg_ds_lstm_ed64_235 > $tmp/reg_ds_lstm_ed64_235/log.txt

echo "$python main.py -ds 235 -e 50 -nt 1 -m nn_models.Model_2 -rnn gru -sm all -op $tmp/reg_ds_gru_235 > $tmp/reg_ds_gru_235/log.txt"
mkdir -p $tmp/reg_ds_gru_235
$python main.py -ds 235 -e 50 -nt 1 -m nn_models.Model_2 -rnn gru -sm all -op $tmp/reg_ds_gru_235 > $tmp/reg_ds_gru_235/log.txt

echo "$python main.py -ds 235 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn gru -sm all -op $tmp/reg_ds_gru_ed64_235 > $tmp/reg_ds_gru_ed64_235/log.txt"
mkdir -p $tmp/reg_ds_gru_ed64_235
$python main.py -ds 235 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn gru -sm all -op $tmp/reg_ds_gru_ed64_235 > $tmp/reg_ds_gru_ed64_235/log.txt


### using rnn with set 236 (values removed)
echo "$python main.py -ds 236 -e 50 -nt 1 -m nn_models.Model_2 -rnn lstm -sm all -op $tmp/reg_ds_lstm_236 > $tmp/reg_ds_lstm_236/log.txt"
mkdir -p $tmp/reg_ds_lstm_236
$python main.py -ds 236 -e 50 -nt 1 -m nn_models.Model_2 -rnn lstm -sm all -op $tmp/reg_ds_lstm_236 > $tmp/reg_ds_lstm_236/log.txt

echo "$python main.py -ds 236 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn lstm -sm all -op $tmp/reg_ds_lstm_ed64_236 > $tmp/reg_ds_lstm_ed64_236/log.txt"
mkdir -p $tmp/reg_ds_lstm_ed64_236
$python main.py -ds 236 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn lstm -sm all -op $tmp/reg_ds_lstm_ed64_236 > $tmp/reg_ds_lstm_ed64_236/log.txt

echo "$python main.py -ds 236 -e 50 -nt 1 -m nn_models.Model_2 -rnn gru -sm all -op $tmp/reg_ds_gru_236 > $tmp/reg_ds_gru_236/log.txt"
mkdir -p $tmp/reg_ds_gru_236
$python main.py -ds 236 -e 50 -nt 1 -m nn_models.Model_2 -rnn gru -sm all -op $tmp/reg_ds_gru_236 > $tmp/reg_ds_gru_236/log.txt

echo "$python main.py -ds 236 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn gru -sm all -op $tmp/reg_ds_gru_ed64_236 > $tmp/reg_ds_gru_ed64_236/log.txt"
mkdir -p $tmp/reg_ds_gru_ed64_236
$python main.py -ds 236 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn gru -sm all -op $tmp/reg_ds_gru_ed64_236 > $tmp/reg_ds_gru_ed64_236/log.txt


## OPT

### using rnn with set 241 (abstract values kept)
echo "$python main.py -ds 241 -e 50 -nt 1 -m nn_models.Model_2 -rnn lstm -lt classification -lf cross_entropy -sm all -opt_key saved_gas -op $tmp/cl_ds_lstm_241 > $tmp/cl_ds_lstm_241/log.txt"
mkdir -p $tmp/cl_ds_lstm_241
$python main.py -ds 241 -e 50 -nt 1 -m nn_models.Model_2 -rnn lstm -lt classification -lf cross_entropy -sm all -opt_key saved_gas -op $tmp/cl_ds_lstm_241 > $tmp/cl_ds_lstm_241/log.txt

echo "$python main.py -ds 241 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn lstm -lt classification -lf cross_entropy -sm all -opt_key saved_gas -op $tmp/cl_ds_lstm_ed64_241 > $tmp/cl_ds_lstm_ed64_241/log.txt"
mkdir -p $tmp/cl_ds_lstm_ed64_241
$python main.py -ds 241 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn lstm -lt classification -lf cross_entropy -sm all -opt_key saved_gas -op $tmp/cl_ds_lstm_ed64_241 > $tmp/cl_ds_lstm_ed64_241/log.txt

echo "$python main.py -ds 241 -e 50 -nt 1 -m nn_models.Model_2 -rnn gru -lt classification -lf cross_entropy -sm all -opt_key saved_gas -op $tmp/cl_ds_gru_241 > $tmp/cl_ds_gru_241/log.txt"
mkdir -p $tmp/cl_ds_gru_241
$python main.py -ds 241 -e 50 -nt 1 -m nn_models.Model_2 -rnn gru -lt classification -lf cross_entropy -sm all -opt_key saved_gas -op $tmp/cl_ds_gru_241 > $tmp/cl_ds_gru_241/log.txt

echo "$python main.py -ds 241 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn gru -lt classification -lf cross_entropy -sm all -opt_key saved_gas -op $tmp/cl_ds_gru_ed64_241 > $tmp/cl_ds_gru_ed64_241/log.txt"
mkdir -p $tmp/cl_ds_gru_ed64_241
$python main.py -ds 241 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn gru -lt classification -lf cross_entropy -sm all -opt_key saved_gas -op $tmp/cl_ds_gru_ed64_241 > $tmp/cl_ds_gru_ed64_241/log.txt


### using rnn with set 242 (abstract values removed)
echo "$python main.py -ds 242 -e 50 -nt 1 -m nn_models.Model_2 -rnn lstm -lt classification -lf cross_entropy -sm all -opt_key saved_gas -op $tmp/cl_ds_lstm_242 > $tmp/cl_ds_lstm_242/log.txt"
mkdir -p $tmp/cl_ds_lstm_242
$python main.py -ds 242 -e 50 -nt 1 -m nn_models.Model_2 -rnn lstm -lt classification -lf cross_entropy -sm all -opt_key saved_gas -op $tmp/cl_ds_lstm_242 > $tmp/cl_ds_lstm_242/log.txt

echo "$python main.py -ds 242 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn lstm -lt classification -lf cross_entropy -sm all -opt_key saved_gas -op $tmp/cl_ds_lstm_ed64_242 > $tmp/cl_ds_lstm_ed64_242/log.txt"
mkdir -p $tmp/cl_ds_lstm_ed64_242
$python main.py -ds 242 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn lstm -lt classification -lf cross_entropy -sm all -opt_key saved_gas -op $tmp/cl_ds_lstm_ed64_242 > $tmp/cl_ds_lstm_ed64_242/log.txt

echo "$python main.py -ds 242 -e 50 -nt 1 -m nn_models.Model_2 -rnn gru -lt classification -lf cross_entropy -sm all -opt_key saved_gas -op $tmp/cl_ds_gru_242 > $tmp/cl_ds_gru_242/log.txt"
mkdir -p $tmp/cl_ds_gru_242
$python main.py -ds 242 -e 50 -nt 1 -m nn_models.Model_2 -rnn gru -lt classification -lf cross_entropy -sm all -opt_key saved_gas -op $tmp/cl_ds_gru_242 > $tmp/cl_ds_gru_242/log.txt

echo "$python main.py -ds 242 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn gru -lt classification -lf cross_entropy -sm all -opt_key saved_gas -op $tmp/cl_ds_gru_ed64_242 > $tmp/cl_ds_gru_ed64_242/log.txt"
mkdir -p $tmp/cl_ds_gru_ed64_242
$python main.py -ds 242 -e 50 -nt 1 -m nn_models.Model_2 -ed 64 -rnn gru -lt classification -lf cross_entropy -sm all -opt_key saved_gas -op $tmp/cl_ds_gru_ed64_242 > $tmp/cl_ds_gru_ed64_242/log.txt



