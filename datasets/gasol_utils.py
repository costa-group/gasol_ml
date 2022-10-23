import re
from typing import List


def is_pseudo_keyword(opcode: str) -> bool:
    if opcode.find("tag") ==-1 and opcode.find("#") ==-1 and opcode.find("$") ==-1 \
            and opcode.find("data") ==-1:
        return False
    else:
        return True


def split_bytecode(raw_instruction_str: str) -> List[str]:
    ops = raw_instruction_str.split(' ')
    opcodes = []
    i = 0

    while i < len(ops):
        op = ops[i]

        # In theory, they should not appear inside a block, as they are removed beforehand.
        # Nevertheless, we include them just in case
        if op.startswith("ASSIGNIMMUTABLE") or op.startswith("tag"):
            opcodes.append(op)
            i += 1
        elif not op.startswith("PUSH"):
            opcodes.append(op)
        else:
            # PUSHDEPLOYADDRESS and PUSHSIZE has no value associated
            if op.find("DEPLOYADDRESS") != -1 or op.find("SIZE") != -1:
                final_op = op

            # Just in case PUSHx instructions are included, we assign to them PUSH name instead
            elif re.fullmatch("PUSH([0-9]+)", op) is not None:
                final_op = "PUSH"
                i = i + 1

            # If position t+1 is a Yul Keyword, then it means we either have a simple PUSH instruction or one of the
            # pseudo PUSH that include a value as a second parameter
            elif not is_pseudo_keyword(ops[i + 1]):
                final_op = op
                i = i + 1
            # Otherwise, the opcode name is composed
            else:
                name_keyword = ops[i + 1]
                final_op = f'{op} {name_keyword}'
                i += 2
            opcodes.append(final_op)

        i += 1

    return opcodes

# this one keeps the 'i' in PUSHi and also its operand
#
def split_bytecode_(raw_instruction_str: str) -> List[str]:
    ops = raw_instruction_str.split(' ')
    opcodes = []
    i = 0
    operand = None
    size = None
    while i < len(ops):
        op = ops[i]
        # In theory, they should not appear inside a block, as they are removed beforehand.
        # Nevertheless, we include them just in case
        if op.startswith("ASSIGNIMMUTABLE") or op.startswith("tag"): # or op.startswith("PUSHIMMUTABLE"):
            opcodes.append(op)
            i += 1
        elif not op.startswith("PUSH"):
            opcodes.append(op)
        else:
            # PUSHDEPLOYADDRESS and PUSHSIZE has no value associated
            if op.find("DEPLOYADDRESS") != -1 or op.find("SIZE") != -1:
                final_op = op

            # Just in case PUSHx instructions are included, we assign to them PUSH name instead
            elif re.fullmatch("PUSH([0-9]+)", op) is not None:
                match = re.fullmatch("PUSH([0-9]+)", op)
                final_op = op
                operand = f'#{ops[i+1]}'
                i = i + 1
            # If position t+1 is a Yul Keyword, then it means we either have a simple PUSH instruction or one of the
            # pseudo PUSH that include a value as a second parameter
            elif not is_pseudo_keyword(ops[i + 1]):
                if op == "PUSH":
                    n =  (len(ops[i+1])+1) // 2
                    assert n >= 1 and n <= 32
                    final_op = f'PUSH{n}'
                    operand = f'#{ops[i+1]}'
                    i = i + 1
                else:
                    final_op = op
                    i = i + 1
            # Otherwise, the opcode name is composed
            else:
                name_keyword = ops[i + 1]
                final_op = f'{op} {name_keyword}'
                i += 2
            
            opcodes.append(final_op)
            if operand is not None:
                opcodes.append(operand)
                operand=None

        i += 1

    return opcodes


if __name__ == "__main__":
    test1 = "DUP2 ADD SWAP1 PUSH 40 PUSH1 40 DUP2 DUP4 SUB SLT PUSH [tag] 11 PUSHSIZE PUSH4 2222"
    test2 = "PUSH 20 SWAP1 MLOAD PUSH FF PUSHIMMUTABLE 921 AND DUP2 MSTORE"
    print(split_bytecode_(test1))
    print(split_bytecode_(test2))
