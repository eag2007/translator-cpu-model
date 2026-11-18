from compiler.compile import Compile
from compiler.lexer import Lexer
from compiler.parser import Parser
from pprint import pprint
from compiler.binary import binary_function
from hardware.machine import Machine

with open("compiler/system.lisp", "r") as f:
    _system_ = f.read()

with open("example/format_string.lisp", "r") as f:
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
    ("F", 1000),
    ("%", 1400),
    ("4", 1800),
    ("d", 2200),
    (" ", 2600),
    ("r", 3000),
    ("u", 3400),
    ("b", 3800),
    ("\0", 4200),
    ("\0", 4600),

    (42, 5000),
])

machine.load_program("/home/evgeniy/PycharmProjects/computer-architecture/output/bin/main.bin")
machine.run()