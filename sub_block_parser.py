import json
import os
import sys
from typing import List, Dict
from pathlib import Path
import pickle

sys.path.append(os.path.dirname(os.path.dirname(os.path.realpath(__file__))))

from sfs_generator.asm_bytecode import get_push_number_hex
from gasol_asm import AsmBytecode, generate_block_from_plain_instructions


def generate_combinations(tokens: List[AsmBytecode]) -> List[List[AsmBytecode]]:
    return [elem for n in range(1, len(tokens)) for elem in [tokens[:n], tokens[n:]]]


def generate_path(tokens: List[AsmBytecode]) -> str:
    current_idx = 0
    instr_to_value = dict()
    token_str_repr = []

    for token in tokens:
        if token.value is not None:
            plain_repr = token.to_plain()

            if plain_repr not in instr_to_value:
                if token.disasm == 'PUSH':
                    instr_to_value[plain_repr] = f'PUSH{get_push_number_hex(token.value)}_v{current_idx}'
                else:
                    instr_to_value[plain_repr] = f'{token.disasm}_v{current_idx}'

                current_idx += 1

            token_str_repr.append(instr_to_value[plain_repr])
        else:
            token_str_repr.append(token.to_plain())

    return '/'.join((token.replace(' ', '_') for token in token_str_repr))


def process_sub_block_from_asm_list(instructions: List[AsmBytecode], source_path: str) -> Dict:
    if instructions == []:
        return {}

    rep = generate_path(instructions)
    json_file = Path(source_path).joinpath(rep, 'info.json').resolve()

    if not json_file.exists():
        raise ValueError(f'{json_file} not been generated')

    with open(json_file, 'r') as f:
        try:
            return json.load(f)
        except:
            raise ValueError(f'Error loading {json_file}')


def process_sub_block_from_seq_elem(seq_element: str, source_path: str) -> Dict:
    block = generate_block_from_plain_instructions(' '.join(seq_element), 'element', True)
    return process_sub_block_from_asm_list(block.instructions, source_path)


def load_list_of_sequences(source_path):
    with open(Path(source_path).joinpath('hierarchy.txt').resolve(), 'rb') as f:
        list_of_seq = pickle.load(f)
    return list_of_seq

if __name__=="__main__":
    if len(sys.argv) != 2:
        raise ValueError('Wrong number of arguments')

    source_path = sys.argv[1]

    with open(Path(source_path).joinpath('hierarchy.txt').resolve(), 'rb') as f:
        list_of_seq = pickle.load(f)

    for seq in list_of_seq:
        information = process_sub_block_from_seq_elem(seq, source_path)
        print(information)
