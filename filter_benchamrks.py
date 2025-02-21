import os
import csv
from opcodes import split_bytecode_

def abstract_constants(bytecode_sequence_orig):
    bytecode_sequence = []
    consts = list(dict.fromkeys((filter(lambda x: x.startswith('#'), bytecode_sequence_orig)))) # all constants in a list, without repetitions
    for t in bytecode_sequence_orig:
        if t.startswith("#"):
            t = f'{consts.index(t)}' # repetitions are kept, but with smaller number of digits, we also add ! at the end
            for c in t:
                bytecode_sequence.append(c.upper()) # upper used when we had hex, i keep it for now
        else:
            bytecode_sequence.append(t)

    return bytecode_sequence
                
def load_blocks(dirs,base_list={}, raw_dir='data/gasol/raw',threshold=1, include_no_model=True, remove_dup=False, remove_base_dup=False, remove_consts=False, abstract_consts=False):
    blocks = {}
    rep = 0
    rep_bl = 0
    for d in dirs:
        csv_dir = f'{raw_dir}/{d}/csv'
        json_dir = f'{raw_dir}/{d}/jsons'
        for csv_filename in os.listdir(csv_dir):
            csv_filename_noext = os.path.splitext(csv_filename)[0]
            with open(f'{csv_dir}/{csv_filename}', newline='') as csvfile:
                csv_reader = csv.DictReader(csvfile)
                for block_info in csv_reader:
                    if include_no_model or block_info["model_found"]=="True":
                        block_id = block_info['block_id']
                        tokens = split_bytecode_(block_info["previous_solution"])
                        if abstract_consts:
                            tokens = abstract_constants(tokens)
                        if len(tokens) >= threshold:
                            if remove_consts:
                                tokens = list(filter(lambda x: not x.startswith("#"),tokens))
                            bc = ' '.join(tokens)
                            if base_list.get(bc) is not None and block_info["model_found"]=="True":
                                rep_bl += 1
                                if remove_base_dup:
                                    try:
                                        os.remove(f'{json_dir}/{csv_filename_noext}/{block_id}_input.json')
                                    except Exception as e:
                                        pass
                            elif blocks.get(bc) is None:
                                blocks[bc]=1
                            else:
                                rep +=1
                                blocks[bc] += 1
                                if remove_dup:
                                    try:
                                        print('hello')
                                        os.remove(f'{json_dir}/{csv_filename_noext}/{block_id}_input.json')
                                    except Exception as e:
                                        pass

    return blocks, len(blocks), rep, rep_bl

def conflict(dirs,raw_dir='data/gasol/raw', remove_consts=False, abstract_consts=False):
    blocks = {}
    total = 0
    for d in dirs:
        csv_dir = f'{raw_dir}/{d}/csv'
        json_dir = f'{raw_dir}/{d}/jsons'
        for csv_filename in os.listdir(csv_dir):
            csv_filename_noext = os.path.splitext(csv_filename)[0]
            with open(f'{csv_dir}/{csv_filename}', newline='') as csvfile:
                csv_reader = csv.DictReader(csvfile)
                for block_info in csv_reader:
                    if block_info["model_found"]=="True":
                        total += 1
                        block_id = block_info['block_id']
                        tokens = split_bytecode_(block_info["previous_solution"])
                        if abstract_consts:
                            tokens = abstract_constants(tokens)
                        elif remove_consts:
                            tokens = list(filter(lambda x: not x.startswith("#"),tokens))
                        bc = ' '.join(tokens)
                        l = 1 if int(block_info["saved_size"]) > 0 else 0
                        if blocks.get(bc) is None:
                            blocks[bc] = l
                        else:
                            if blocks[bc] == l:
                                print('conflict')
    print(total)
if __name__ == "__main__":
    conflict(['block_jan_23_8_17_size','block_jul_22_8_17_size','block_march_23_8_17_size'],abstract_consts=True)

