import random


#This class just implements a random decision. 0 optimize, 1 non optimize
class ModelQuery:

    # input: --
    # output: 0 if the block is classified as "gas will be saved", 1 or None othewise
    #
    def eval(self, bytecode: str): # as a string
        return random.choice([0,1])


if __name__ == "__main__":
    m = ModelQuery()
    for i in range(0,10):
        print(m.eval(""))
