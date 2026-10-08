from enum import auto
from pprint import pprint
from parser import *


class TypesAssembler:
    LABEL = auto()
    COMMAND_NOT_ADDRESS = auto()
    COMMAND_ADDRESS = auto()
    COMMAND_BRANCHING = auto()


class Compile:
    def __init__(self):
        self.instructions = []
        self.identifiers = set()
        self.ast = []
        self.label_count = 0
        self.data = []
        self.functions = {}
        self.stack_depth = 0
        self.stack_ident = {}

    """
    Загружает AST дерево expressions
    args:
        Список выражений expressions
    returns:
        None
    """

    def load_ast(self, ast: list[Expr]):
        self.ast = ast
        self.__select(self.ast)
        self.__translate(self.ast)

    def __push(self):
        self.instructions += [("PUSH",)]
        self.stack_depth -= 4

    def __pop(self):
        self.instructions += [("POP",)]
        self.stack_depth += 4

    def __variable_address(self, name):
        if name in self.stack_ident:
            offset = self.stack_ident[name] - self.stack_depth
            return f"[{offset}]"
        return name

    def __translate(self, ast_tree):
        for expression in ast_tree:
            self.__translate_expr(expression)
        pprint(self.data)
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
            elif expression.operation == ">":
                self.__translate_expr_left(expression)
            elif expression.operation == ">=":
                self.__translate_expr_lefteq(expression)
            elif expression.operation == "==":
                self.__translate_expr_eq(expression)
            elif expression.operation == "!=":
                self.__translate_expr_not_eq(expression)
            elif expression.operation == "<":
                self.__translate_expr_right(expression)
            elif expression.operation == "<=":
                self.__translate_expr_righteq(expression)
            else:
                raise SyntaxError

        if isinstance(expression, StringExpr):
            self.__translate_expr_string(expression)

        if isinstance(expression, IfExpr):
            self.__translate_expr_if(expression)

        if isinstance(expression, NumberExpr):
            self.__translate_expr_number(expression)

        if isinstance(expression, SetExpr):
            self.__translate_expr_set(expression)

        if isinstance(expression, IdentifierExpr):
            self.__translate_expr_ident(expression)

        if isinstance(expression, WhileExpr):
            self.__translate_expr_while(expression)

        if isinstance(expression, RepeatExpr):
            self.__translate_expr_repeat(expression)

        if isinstance(expression, DefuncExpr):
            self.__translate_expr_defunc(expression)

        if isinstance(expression, FuncCallExpr):
            self.__translate_expr_funcall(expression)

    def __new_label(self, prefix) -> str:
        label = f"{prefix}_{self.label_count}"
        self.label_count += 1
        return label

    def __see_local_variable(self, expr):
        if isinstance(expr, DefuncExpr):
            return

        if isinstance(expr, SetExpr):
            name = expr.target.name

            if name not in self.stack_ident:
                self.__push()
                self.stack_ident[name] = self.stack_depth + 4

            self.__see_local_variable(expr.value)
        elif isinstance(expr, BinaryExpr):
            self.__see_local_variable(expr.left)
            self.__see_local_variable(expr.right)

        elif isinstance(expr, IfExpr):
            self.__see_local_variable(expr.condition)

            for item in expr.body:
                self.__see_local_variable(item)

            if expr.else_body is not None:
                for item in expr.else_body:
                    self.__see_local_variable(item)

        elif isinstance(expr, WhileExpr):
            self.__see_local_variable(expr.condition)

            for item in expr.body:
                self.__see_local_variable(item)

        elif isinstance(expr, RepeatExpr):
            self.__see_local_variable(expr.count)

            for item in expr.body:
                self.__see_local_variable(item)

        elif isinstance(expr, FuncCallExpr):
            for arg in expr.args:
                self.__see_local_variable(arg)

        elif isinstance(expr, (PrintExpr, PrintChrExpr)):
            self.__see_local_variable(expr.value)

    def __create_memory_for_local_variables(self, funcexpr: DefuncExpr):
        for expr in funcexpr.body:
            self.__see_local_variable(expr)

    def __translate_expr_defunc(self, expression: DefuncExpr):
        label_function = f"$func_{expression.name}"
        label_end = self.__new_label("end")

        external_ident = self.stack_ident
        external_depth = self.stack_depth

        self.stack_ident = {}
        self.stack_depth = 0

        count_params = len(expression.params)

        for index, param in enumerate(expression.params):
            self.stack_ident[param.name] = (count_params - index + 1) * 4

        self.instructions += [
            ("JUMP", label_end),
            (label_function + ":",),
            ("LOAD", "#0")
        ]

        self.__create_memory_for_local_variables(expression)
        local_count = -self.stack_depth // 4

        for expr in expression.body:
            self.__translate_expr(expr)

        if local_count:
            self.instructions += [("STORE", "$tmp$")]

            for delete_variable in range(local_count):
                self.__pop()

            self.instructions += [("LOAD", "$tmp$")]

        self.instructions += [
            ("RET",),
            (label_end + ":",)
        ]

        self.stack_ident = external_ident
        self.stack_depth = external_depth

    def __translate_expr_funcall(self, expression: FuncCallExpr):
        for arg in expression.args:
            self.__translate_expr(arg)
            self.__push()

        self.instructions += [("CALL", f"$func_{expression.name}")]
        if expression.args:
            self.instructions += [("STORE", "$tmp$")]

            for _ in expression.args:
                self.__pop()

            self.instructions += [("LOAD", "$tmp$")]

    def __translate_expr_repeat(self, expression: RepeatExpr):
        label_check = self.__new_label("repeat_check")
        label_loop = self.__new_label("repeat_loop")
        label_end = self.__new_label("end")

        self.__translate_expr(expression.count)
        self.instructions += [
            (label_check + ":",),
            ("CMP", "#0"),
            ("BEQ", label_end),
            ("BGE", label_loop),
            ("JUMP", label_end),
            (label_loop + ":",),
        ]
        self.__push()
        for expr in expression.body:
            self.__translate_expr(expr)
        self.__pop()
        self.instructions += [
            ("SUB", "#1"),
            ("JUMP", label_check),
            (label_end + ":",)
        ]

    def __translate_expr_while(self, expression: WhileExpr):
        label_loop = self.__new_label("loop")
        label_end = self.__new_label("end")

        self.instructions += [(label_loop + ":",)]
        self.__translate_expr(expression.condition)
        self.instructions += [
            ("CMP", "#0"),
            ("BEQ", label_end)
        ]
        for expr in expression.body:
            self.__translate_expr(expr)
        self.instructions += [
            ("JUMP", label_loop),
            (label_end + ":",)
        ]

    def __translate_expr_string(self, expression: StringExpr):
        label_string = self.__new_label("string")

        self.data += [(label_string + ":",)]
        for symbol in expression.value:
            self.data += [(".byte", str(ord(symbol)))]
        self.data += [(".byte", str(00))]
        self.instructions += [("LOAD", "?" + label_string)]

    def __translate_expr_if(self, expression: IfExpr):
        label_false = self.__new_label("if_false")
        label_end = self.__new_label("end")

        self.__translate_expr(expression.condition)
        self.instructions += [
            ("CMP", "#0"),
            ("BEQ", label_false)
        ]
        for expr in expression.body:
            self.__translate_expr(expr)
        self.instructions += [
            ("JUMP", label_end),
            (label_false + ":",)
        ]

        if not (expression.else_body is None):
            for expr in expression.else_body:
                self.__translate_expr(expr)
        self.instructions += [(label_end + ":",)]

    def __translate_expr_left(self, expression: BinaryExpr):
        label_true = self.__new_label("left_true")
        label_false = self.__new_label("left_false")
        label_end = self.__new_label("end")

        self.__translate_expr(expression.left)
        self.__push()
        self.__translate_expr(expression.right)
        self.instructions += [("STORE", "$tmp$")]
        self.__pop()
        self.instructions += [
            ("CMP", "$tmp$"),
            ("BEQ", label_false),
            ("BGE", label_true),
            (label_false + ":",),
            ("LOAD", "#0"),
            ("JUMP", label_end),
            (label_true + ":",),
            ("LOAD", "#1"),
            (label_end + ":",)
        ]

    def __translate_expr_right(self, expression: BinaryExpr):
        label_false = self.__new_label("right_false")
        label_end = self.__new_label("end")

        self.__translate_expr(expression.left)
        self.__push()
        self.__translate_expr(expression.right)
        self.instructions += [("STORE", "$tmp$")]
        self.__pop()
        self.instructions += [
            ("CMP", "$tmp$"),
            ("BGE", label_false),
            ("LOAD", "#1"),
            ("JUMP", label_end),
            (label_false + ":",),
            ("LOAD", "#0"),
            (label_end + ":",)
        ]

    def __translate_expr_lefteq(self, expression: BinaryExpr):
        label_true = self.__new_label("lefteq_true")
        label_end = self.__new_label("end")

        self.__translate_expr(expression.left)
        self.__push()
        self.__translate_expr(expression.right)
        self.instructions += [("STORE", "$tmp$")]
        self.__pop()
        self.instructions += [
            ("CMP", "$tmp$"),
            ("BGE", label_true),
            ("LOAD", "#0"),
            ("JUMP", label_end),
            (label_true + ":",),
            ("LOAD", "#1"),
            (label_end + ":",)
        ]

    def __translate_expr_righteq(self, expression: BinaryExpr):
        label_true = self.__new_label("lefteq_true")
        label_false = self.__new_label("lefteq_false")
        label_end = self.__new_label("end")

        self.__translate_expr(expression.left)
        self.__push()
        self.__translate_expr(expression.right)

        self.instructions += [("STORE", "$tmp$")]
        self.__pop()
        self.instructions += [
            ("CMP", "$tmp$"),
            ("BEQ", label_true),
            ("BGE", label_false),
            (label_true + ":",),
            ("LOAD", "#1"),
            ("JUMP", label_end),
            (label_false + ":",),
            ("LOAD", "#0"),
            (label_end + ":",)
        ]

    def __translate_expr_eq(self, expression: BinaryExpr):
        label_true = self.__new_label("equal_true")
        label_false = self.__new_label("equal_false")
        label_end = self.__new_label("end")

        self.__translate_expr(expression.left)
        self.__push()
        self.__translate_expr(expression.right)
        self.instructions += [
            ("STORE", "$tmp$")]
        self.__pop()
        self.instructions += [
            ("CMP", "$tmp$"),
            ("BEQ", label_true),
            ("JUMP", label_false),
            (label_true + ":",),
            ("LOAD", "#1"),
            ("JUMP", label_end),
            (label_false + ":",),
            ("LOAD", "#0"),
            ("JUMP", label_end),
            (label_end + ":",)
        ]

    def __translate_expr_not_eq(self, expression: BinaryExpr):
        label_true = self.__new_label("not_equal_true")
        label_false = self.__new_label("not_equal_false")
        label_end = self.__new_label("end")

        self.__translate_expr(expression.left)
        self.__push()
        self.__translate_expr(expression.right)
        self.instructions += [("STORE", "$tmp$")]
        self.__pop()
        self.instructions += [
            ("CMP", "$tmp$"),
            ("BEQ", label_false),
            ("JUMP", label_true),
            (label_false + ":",),
            ("LOAD", "#0"),
            ("JUMP", label_end),
            (label_true + ":",),
            ("LOAD", "#1"),
            (label_end + ":",)
        ]

    def __translate_expr_ident(self, expression: IdentifierExpr):
        address = self.__variable_address(expression.name)
        self.instructions += [("LOAD", address)]

    def __translate_expr_set(self, expression: SetExpr):
        self.__translate_expr(expression.value)
        address = self.__variable_address(expression.target.name)
        self.instructions += [("STORE", address)]

    def __translate_expr_number(self, expression: NumberExpr):
        self.instructions += [("LOAD", f"#{expression.value}")]

    def __translate_expr_sum(self, expression: BinaryExpr):
        self.__translate_expr(expression.left)
        self.__push()
        self.__translate_expr(expression.right)
        self.instructions += [("STORE", "$tmp$")]
        self.__pop()
        self.instructions += [("ADD", "$tmp$")]

    def __translate_expr_sub(self, expression: BinaryExpr):
        self.__translate_expr(expression.left)
        self.__push()
        self.__translate_expr(expression.right)
        self.instructions += [("STORE", "$tmp$")]
        self.__pop()
        self.instructions += [("SUB", "$tmp$")]

    def __translate_expr_mul(self, expression: BinaryExpr):
        self.__translate_expr(expression.left)
        self.__push()
        self.__translate_expr(expression.right)
        self.instructions += [("STORE", "$tmp$")]
        self.__pop()
        self.instructions += [("MUL", "$tmp$")]

    def __translate_expr_div(self, expression: BinaryExpr):
        self.__translate_expr(expression.left)
        self.__push()
        self.__translate_expr(expression.right)
        self.instructions += [("STORE", "$tmp$")]
        self.__pop()
        self.instructions += [("DIV", "$tmp$")]

    def __translate_expr_mod(self, expression: BinaryExpr):
        self.__translate_expr(expression.left)
        self.__push()
        self.__translate_expr(expression.right)
        self.instructions += [("STORE", "$tmp$")]
        self.__pop()
        self.instructions += [("MOD", "$tmp$")]

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
            self.data.append((identifier, '.word'))

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
