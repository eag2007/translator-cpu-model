from parser import *


class Compile:
    def __init__(self):
        self.instructions = []
        self.identifiers = set()
        self.ast = []

    def load_ast(self, ast: list[Expr]):
        self.ast = ast
        self.select(self.ast)

    def select(self, ast_tree):
        for element_ast in ast_tree:
            self.select_identifiers(element_ast, True)

        for identifier in self.identifiers:
            self.instructions.append(('word', identifier))

        print(self.instructions)

    def select_identifiers(self, expression: Expr, is_global: bool):
        if isinstance(expression, SetExpr) and is_global:
            self.identifiers.add(expression.target.name)
            self.select_identifiers(expression.value, is_global)
            return

        if isinstance(expression, NumberExpr):
            return

        if isinstance(expression, StringExpr):
            return

        if isinstance(expression, IdentifierExpr):
            return

        if isinstance(expression, BinaryExpr):
            self.select_identifiers(expression.left, is_global)
            self.select_identifiers(expression.right, is_global)
            return

        if isinstance(expression, IfExpr):
            self.select_identifiers(expression.condition, is_global)
            for _expression in expression.body:
                self.select_identifiers(_expression, is_global)

            if expression.else_body is None:
                return

            for _expression in expression.else_body:
                self.select_identifiers(_expression, is_global)
            return

        if isinstance(expression, WhileExpr):
            self.select_identifiers(expression.condition, is_global)
            for _expression in expression.body:
                self.select_identifiers(_expression, is_global)
            return

        if isinstance(expression, RepeatExpr):
            self.select_identifiers(expression.count, is_global)
            for _expression in expression.body:
                self.select_identifiers(_expression, is_global)
            return

        if isinstance(expression, FuncCallExpr):
            for _expression in expression.args:
                self.select_identifiers(_expression, is_global)
            return

        if isinstance(expression, PrintExpr):
            self.select_identifiers(expression.value, is_global)
            return

        if isinstance(expression, PrintChrExpr):
            self.select_identifiers(expression.value, is_global)
            return
        return
