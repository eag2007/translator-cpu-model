from parser import *

class Compile:
    def __init__(self):
        self.instructions = []
        self.identifiers = set()
        self.ast = []

    def load_ast(self, ast: list[Expr]):
        self.ast = ast

        for element_ast in self.ast:
            self.select_identifiers(element_ast)

        for identifier in self.identifiers:
            self.instructions.append(('word', identifier))

        print(self.instructions)


    def select_identifiers(self, expression: Expr):
        if isinstance(expression, IdentifierExpr):
            self.identifiers.add(expression.name)
            return

        if isinstance(expression, SetExpr):
            self.select_identifiers(expression.target)
            return
