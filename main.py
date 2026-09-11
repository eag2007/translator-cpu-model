from lexer import Lexer
from parser import Parser
from pprint import pprint

with open("main.lisp", "r") as f:
    s = f.read()

lexer = Lexer()
lexer.load_source(s)

tokens = lexer.get_tokens()

parser = Parser()
parser.load_tokens(tokens)

pprint(parser.parse())