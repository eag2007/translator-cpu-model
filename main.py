from compile import Compile
from lexer import Lexer
from parser import Parser
from pprint import pprint

with open("test.lisp", "r") as f:
    s = f.read()

lexer = Lexer()
lexer.load_source(s)

tokens = lexer.get_tokens()
pprint(tokens)

parser = Parser()
parser.load_tokens(tokens)

ast_tree = parser.parse()
pprint(ast_tree)


compilator = Compile()
compilator.load_ast(ast_tree)