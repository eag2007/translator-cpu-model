from compiler.compile import Compile
from compiler.lexer import Lexer
from compiler.parser import Parser
from pprint import pprint
from compiler.binary import binary_function
from hardware.machine import Machine

with open("compiler/system.lisp", "r") as f:
    _system_ = f.read()

with open("example/a_add_b.lisp", "r") as f:
    s = f.read()

lexer = Lexer()
lexer.load_source(_system_ + "\n" + s)

tokens = lexer.get_tokens()
with open("./output/tokens/tokens.conf", "w") as f:
    pprint(tokens, stream=f, width=80, sort_dicts=False)

parser = Parser()
parser.load_tokens(tokens)

ast_tree = parser.parse()
with open("./output/expressions/expressions.conf", "w") as f:
    pprint(ast_tree, stream=f, width=80, sort_dicts=False)

compilator = Compile()
compilator.load_ast(ast_tree)

binary_function(compilator.get_data(), compilator.get_instructions())

with open("./output/logs/main.log", "w") as f:
    print(file=f, end="")

machine = Machine("./output/logs/main.log", [
    ("%", 50), ("9", 200), ("d", 350),
    ("\0", 500), ("\0", 650), ("\0", 800), ("\0", 950),
    ("\0", 1100), ("\0", 1250), ("\0", 1400), ("\0", 1550),
    ("\0", 1700), ("\0", 1850), ("\0", 2000), ("\0", 2150),
    ("\0", 2300), ("\0", 2450), ("\0", 2600), ("\0", 2750),
    ("\0", 2900), ("\0", 3050), ("\0", 3200), ("\0", 3350),
    ("\0", 3500), ("\0", 3650), ("\0", 3800), ("\0", 3950),
    ("\0", 4100), ("\0", 4250), ("\0", 4400), ("\0", 4550),
    ("\0", 4700),
    (-7, 6000),
])

machine.load_program("/home/evgeniy/PycharmProjects/computer-architecture/output/bin/main.bin")
machine.run()