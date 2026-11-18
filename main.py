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

machine = Machine("./output/logs/main.log", [("H", 50), ("e", 200), ("l", 350), ("l", 500), ("0", 650)])
machine.load_program("/home/evgeniy/PycharmProjects/computer-architecture/output/bin/main.bin")
machine.run()