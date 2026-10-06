from enum import Enum, auto
from pprint import pprint
from parser import *


class Command(Enum):
    PUSH = auto()
    POP = auto()
    ADD = auto()
    STORE = auto()


class Compile:
    def __init__(self):
        self.instructions = []
        self.identifiers = set()
        self.ast = []

    def load_ast(self, ast: list[Expr]):
        self.ast = ast
        self.__select(self.ast)
        self.__translate(self.ast)

    def __translate(self, ast_tree):
        for expression in ast_tree:
            self.__translate_expr(expression)
        pprint(self.instructions)

    def __translate_expr(self, expression):
        if isinstance(expression, BinaryExpr):
            if expression.operation == "+":
                self.__translate_expr_sum(expression)
            elif expression.operation == "-":
                self.__translate_expr_sub(expression)
            elif expression.operation == "*":
                self.__translate_expr_mul(expression)
            elif expression.operation == "/":
                self.__translate_expr_div(expression)
            elif expression.operation == "%":
                self.__translate_expr_mod(expression)
            else:
                raise SyntaxError

        if isinstance(expression, NumberExpr):
            self.__translate_expr_number(expression)

    def __translate_expr_number(self, expression: NumberExpr):
        self.instructions.append(("LOAD", f"#{expression.value}"))

    def __translate_expr_sum(self, expression: BinaryExpr):
        self.__translate_expr(expression.left)
        self.instructions.append(("PUSH",))
        self.__translate_expr(expression.right)
        self.instructions.append(("STORE", "$tmp$"))
        self.instructions.append(("POP",))
        self.instructions.append(("ADD", "$tmp$"))
        return

    def __translate_expr_sub(self, expression: BinaryExpr):
        self.__translate_expr(expression.left)
        self.instructions.append(("PUSH",))
        self.__translate_expr(expression.right)
        self.instructions.append(("STORE", "$tmp$"))
        self.instructions.append(("POP",))
        self.instructions.append(("SUB", "$tmp$"))
        return

    def __translate_expr_mul(self, expression: BinaryExpr):
        self.__translate_expr(expression.left)
        self.instructions.append(("PUSH",))
        self.__translate_expr(expression.right)
        self.instructions.append(("STORE", "$tmp$"))
        self.instructions.append(("POP",))
        self.instructions.append(("MUL", "$tmp$"))
        return

    def __translate_expr_div(self, expression: BinaryExpr):
        self.__translate_expr(expression.left)
        self.instructions.append(("PUSH",))
        self.__translate_expr(expression.right)
        self.instructions.append(("STORE", "$tmp$"))
        self.instructions.append(("POP",))
        self.instructions.append(("DIV", "$tmp$"))
        return

    def __translate_expr_mod(self, expression: BinaryExpr):
        self.__translate_expr(expression.left)
        self.instructions.append(("PUSH",))
        self.__translate_expr(expression.right)
        self.instructions.append(("STORE", "$tmp$"))
        self.instructions.append(("POP",))
        self.instructions.append(("MOD", "$tmp$"))
        return

    """
    Создает список из глобальных переменных вычисленных из Expression выражений
    
    args:
        ast_tree:   дерево выражений
        
    returns:
        None
    """
    def __select(self, ast_tree):
        for element_ast in ast_tree:
            self.__select_identifiers(element_ast, True)

        self.identifiers.add('$tmp$')

        for identifier in self.identifiers:
            self.instructions.append((identifier, '.word'))

    """
    Выбирает глобальные переменные из Expression выражений
       
    args:
        expression: выражение
        is_global:  переменная флаг (отвечает за то является ли переменная локальной или глобальной)
        
    returns:
        None
    """
    def __select_identifiers(self, expression: Expr, is_global: bool):
        if isinstance(expression, SetExpr) and is_global:
            self.identifiers.add(expression.target.name)
            self.__select_identifiers(expression.value, is_global)
            return

        if isinstance(expression, NumberExpr):
            return

        if isinstance(expression, StringExpr):
            return

        if isinstance(expression, IdentifierExpr):
            return

        if isinstance(expression, BinaryExpr):
            self.__select_identifiers(expression.left, is_global)
            self.__select_identifiers(expression.right, is_global)
            return

        if isinstance(expression, IfExpr):
            self.__select_identifiers(expression.condition, is_global)
            for _expression in expression.body:
                self.__select_identifiers(_expression, is_global)

            if expression.else_body is None:
                return

            for _expression in expression.else_body:
                self.__select_identifiers(_expression, is_global)
            return

        if isinstance(expression, WhileExpr):
            self.__select_identifiers(expression.condition, is_global)
            for _expression in expression.body:
                self.__select_identifiers(_expression, is_global)
            return

        if isinstance(expression, RepeatExpr):
            self.__select_identifiers(expression.count, is_global)
            for _expression in expression.body:
                self.__select_identifiers(_expression, is_global)
            return

        if isinstance(expression, FuncCallExpr):
            for _expression in expression.args:
                self.__select_identifiers(_expression, is_global)
            return

        if isinstance(expression, PrintExpr):
            self.__select_identifiers(expression.value, is_global)
            return

        if isinstance(expression, PrintChrExpr):
            self.__select_identifiers(expression.value, is_global)
            return
        return
