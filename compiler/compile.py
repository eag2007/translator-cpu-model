from compiler.parser import *


class Compile:
    """Класс отвечающий за компиляцию ast дерева в ассемблер код"""

    def __init__(self):
        """Инициализация полей компилятора
            :var self.instructions:     список всех команд ассемблера
            :var self.indetifiers:      множество названий глобальных элементов
            :var self.ast:              переменная которая будет хранить принимаемое ast дерево на вход
            :var self.label_count:      счётчик меток, благодаря нему делаются уникальные метки
            :var self.data:             список зарезервированных мест под глобальные переменные
            :var self.functions:        словарь названий функций и их меток
            :var self.stack_depth:      считает глубину стека (нужен для вычислений адресов локальных переменных)
            :var self.stack_ident:      словарь локальных переменных функции и их адресов в стеке
                (a: -12, b: -8)
        """
        self.instructions = [("_start:",)]
        self.identifiers = set()
        self.ast = []
        self.label_count = 0
        self.data = []
        self.functions = {}
        self.stack_depth = 0
        self.stack_ident = {}

    def load_ast(self, ast: list[Expr]):
        """Загружает AST дерево expressions
            :param ast: Список выражений expressions
            :return None
        """
        self.ast = ast
        self.__select(self.ast)
        self.__translate(self.ast)
        self.instructions += [("HALT",)]
        self.save_asm()

    def get_data(self):
        return self.data

    def get_instructions(self):
        return self.instructions

    def save_asm(self):
        """Сохраняет assembler код в файл
            :return None
        """
        with open("./output/asm/main.asm", "w") as f:
            for i in self.data:
                print(f"{i[0]:<24} {' '.join(i[1:])}".rstrip(), file=f)

            for i in self.instructions:
                if i[0].endswith(":"):
                    print(i[0], file=f)
                else:
                    print(f"    {i[0]:<8} {' '.join(i[1:])}".rstrip(), file=f)

    def __push(self):
        """Кладет значение из ACC в верхушку стека, меняет глубину стека
            :return None
        """
        self.instructions += [("PUSH",)]
        self.stack_depth -= 1

    def __pop(self):
        """Снимает значение из верхушки стека и кладет его в ACC, меняет глубину стека
            :return None
        """
        self.instructions += [("POP",)]
        self.stack_depth += 1

    def __variable_address(self, name):
        """Дает ссылку на переменную (если переменная локальная то адрес в стеке, иначе метку на глобальную)
            :param name:            название переменной
            :return str:            возвращает метку или соответсвующее смешение в стеке, где лежит переменная
        """
        if name in self.stack_ident:
            offset = self.stack_ident[name] - self.stack_depth
            return True, str(offset)
        return False, name

    def __translate(self, ast_tree):
        """Первый обход по всем expression для выявления всех глобальных переменных и статических значений
            :param ast_tree:        дерево expressions
            :return None
        """
        for expression in ast_tree:
            self.__translate_expr(expression)

    def __translate_expr(self, expression):
        """Производит обход по expression и если находит в нем глобальную переменную или значение,
                то оставляет под нее место в памяти
            :param expression       выражение expression
            :return None
        """
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
            if expression.name == "irq_input":
                self.__translate_expr_irq_input(expression)
            elif expression.name == "irq_output":
                self.__translate_expr_irq_output(expression)
            else:
                self.__translate_expr_defunc(expression)

        if isinstance(expression, FuncCallExpr):
            self.__translate_expr_funcall(expression)

        if isinstance(expression, ArrayExpr):
            self.__translate_expr_array(expression)

        if isinstance(expression, ArrayGetExpr):
            self.__translate_expr_array_get(expression)

        if isinstance(expression, ArraySetExpr):
            self.__translate_expr_array_set(expression)

        if isinstance(expression, StringAllocExpr):
            self.__translate_expr_string_alloc(expression)

        if isinstance(expression, SetCharExpr):
            self.__translate_expr_set_char(expression)

        if isinstance(expression, GetCharExpr):
            self.__translate_expr_get_char(expression)

        if isinstance(expression, InputExpr):
            self.__translate_expr_input(expression)

        if isinstance(expression, PrintCharExpr):
            self.__translate_expr_print_char(expression)

        if isinstance(expression, PrintNumberExpr):
            self.__translate_expr_print_number(expression)

        if isinstance(expression, PrintStringExpr):
            self.__translate_expr_print_string(expression)

    def __new_label(self, prefix) -> str:
        """Создает новую уникальную метку
            :param prefix:      название метки
            :return str:        строку с названием метки
        """
        label = f"{prefix}_{self.label_count}"
        self.label_count += 1
        return label

    def __see_local_variable(self, expr):
        """Выделяет память в стеке под локальные переменные конкретной функции
            :param expr:        выражение
            :return None
        """
        if isinstance(expr, DefuncExpr):
            return

        if isinstance(expr, SetExpr):
            name = expr.target.name

            if name not in self.stack_ident and name not in self.identifiers:
                self.__push()
                self.stack_ident[name] = self.stack_depth + 1

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

        elif isinstance(expr, (PrintNumberExpr, PrintStringExpr, PrintCharExpr)):
            self.__see_local_variable(expr.value)

        elif isinstance(expr, (ArrayExpr, StringAllocExpr)):
            self.__see_local_variable(expr.size)

        elif isinstance(expr, (ArrayGetExpr, GetCharExpr)):
            self.__see_local_variable(expr.index)
            self.__see_local_variable(expr.address)

        elif isinstance(expr, (ArraySetExpr, SetCharExpr)):
            self.__see_local_variable(expr.address)
            self.__see_local_variable(expr.index)
            self.__see_local_variable(expr.value)

    def __create_memory_for_local_variables(self, funcexpr: DefuncExpr):
        """Перебирает expression в функции, чтобы выделить память в стеке под локальные переменные
            :param funcexpr:        выражение тела функции
            :return None
        """
        for expr in funcexpr.body:
            self.__see_local_variable(expr)

    def __translate_expr_input(self, expression: InputExpr):
        if expression.size is None:
            self.__translate_expr_input_number()
        else:
            self.__translate_expr_input_string(expression)

    def __move_from_acc_to_buffer(self, expression: PrintCharExpr | PrintNumberExpr):
        wait = self.__new_label("wait")

        self.instructions += [
            (wait + ":",),
            ("LOAD", "system_out_ready"),
            ("CMPI", "0"),
            ("BEQ", wait + "_end"),
            ("JUMP", wait),
            (wait + "_end:",)
        ]
        self.__translate_expr(expression.value)
        self.instructions += [
            ("STORE", "system_out_buffer"),
            ("LOADI", "1"),
            ("STORE", "system_out_ready")
        ]

    def __translate_expr_print_char(self, expression: PrintCharExpr):
        self.__move_from_acc_to_buffer(expression)

    def __translate_expr_print_number(self, expression: PrintNumberExpr):
        self.__move_from_acc_to_buffer(expression)

    def __translate_expr_print_string(self, expression: PrintStringExpr):
        ptr = self.__new_label("print_str_ptr")
        loop = self.__new_label("print_str_loop")
        check = self.__new_label("print_str_check")
        end = self.__new_label("print_str_end")

        self.data += [
            (ptr + ":",),
            (".word", "0")
        ]

        self.__translate_expr(expression.value)
        self.instructions += [
            ("STORE", ptr),
            (loop + ":",),
            # проверим сигнал готовности
            ("LOAD", "system_out_ready"),
            ("CMPI", "0"),
            ("BEQ", check),
            ("JUMP", loop),
            # проверим на конец символа
            (check + ":",),
            ("LOAD_IND", ptr),
            ("CMPI", "0"),
            ("BEQ", end),
            # передаем в буфер символ
            ("LOAD_IND", ptr),
            ("STORE", "system_out_buffer"),
            ("LOADI", "1"),
            ("STORE", "system_out_ready"),

            ("LOAD", ptr),
            ("ADDI", "1"),
            ("STORE", ptr),
            ("JUMP", loop),
            (end + ":",)
        ]

    def __translate_expr_input_number(self):
        label_wait = self.__new_label("in_nbr_wait")

        self.instructions += [
            (label_wait + ":",),
            ("LOAD", "system_in_ready"),
            ("CMPI", "0"),
            ("BEQ", label_wait),
            ("LOAD", "system_in_buffer")
        ]
        self.__push()
        self.instructions += [
            ("LOADI", "0"),
            ("STORE", "system_in_ready")
        ]
        self.__pop()

    def __translate_expr_input_string(self, expression: InputExpr):
        size = expression.size.value
        label = self.__new_label("input_str")
        loop = self.__new_label("input_loop")

        self.data += [(label + ":",), ]
        self.data += [(".word", "0")] * (size + 1)

        self.instructions += [
            ("LOAD_ADDR", label),
            ("STORE", "$tmp_address$"),
            ("LOADI", f"{size}"),
            ("STORE", "$tmp$"),
            (loop + ":",),
            ("LOAD", "$tmp$"),
            ("CMPI", "0"),
            ("BEQ", loop + "_end")
        ]

        self.__translate_expr_input_number()

        self.instructions += [
            ("STORE_IND", "$tmp_address$"),
            ("LOAD", "$tmp_address$"),
            ("ADDI", "1"),
            ("STORE", "$tmp_address$"),
            ("LOAD", "$tmp$"),
            ("SUBI", "1"),
            ("STORE", "$tmp$"),
            ("JUMP", loop),
            (loop + "_end:",),
            ("LOAD_ADDR", label)
        ]

    def __translate_expr_defunc(self, expression: DefuncExpr, return_opcode="RET"):
        """Перевод из defunc expression в ассемблер код
            :param expression:      выражение функции
            :return None
        """
        label_function = f"$func_{expression.name}"
        label_end = self.__new_label("end")

        external_ident = self.stack_ident
        external_depth = self.stack_depth

        self.stack_ident = {}
        self.stack_depth = 0

        count_params = len(expression.params)

        for index, param in enumerate(expression.params):
            self.stack_ident[param.name] = count_params - index + 1

        self.instructions += [
            ("JUMP", label_end),
            (label_function + ":",),
        ]

        if return_opcode == "IRET":
            self.instructions += [("LOAD", "$tmp$")]
            self.__push()
            self.instructions += [("LOAD", "$tmp_address$")]
            self.__push()

        self.instructions += [("LOADI", "0")]

        self.__create_memory_for_local_variables(expression)
        local_count = -self.stack_depth - (2 if return_opcode == "IRET" else 0)

        for expr in expression.body:
            self.__translate_expr(expr)

        if local_count:
            self.instructions += [("STORE", "$tmp$")]

            for delete_variable in range(local_count):
                self.__pop()

            self.instructions += [("LOAD", "$tmp$")]

        if return_opcode == "IRET":
            self.__pop()
            self.instructions += [("STORE", "$tmp_address$")]
            self.__pop()
            self.instructions += [("STORE", "$tmp$")]

        self.instructions += [
            (return_opcode,),
            (label_end + ":",)
        ]

        self.stack_ident = external_ident
        self.stack_depth = external_depth

    def __translate_expr_funcall(self, expression: FuncCallExpr):
        """Перевод func call expression в ассемблер код
            :param expression:      выражение вызова функции
            :return None
        """
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
        """Перевод из repeat expression в ассемблер код (цикл с счётчиком)
            :param expression:      выражение цикла с счётчиком
            :return None
        """
        label_check = self.__new_label("repeat_check")
        label_loop = self.__new_label("repeat_loop")
        label_end = self.__new_label("end")

        self.__translate_expr(expression.count)
        self.instructions += [
            (label_check + ":",),
            ("CMPI", "0"),
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
            ("SUBI", "1"),
            ("JUMP", label_check),
            (label_end + ":",)
        ]

    def __translate_expr_while(self, expression: WhileExpr):
        """Перевод из while expression в ассемблер код
            :param expression:      выражение цикла
            :return None
        """
        label_loop = self.__new_label("loop")
        label_end = self.__new_label("end")

        self.instructions += [(label_loop + ":",)]
        self.__translate_expr(expression.condition)
        self.instructions += [
            ("CMPI", "0"),
            ("BEQ", label_end)
        ]
        for expr in expression.body:
            self.__translate_expr(expr)
        self.instructions += [
            ("JUMP", label_loop),
            (label_end + ":",)
        ]

    def __translate_expr_string(self, expression: StringExpr):
        """Перевод string expression в ассемблер код
            :param expression:      выражение строки
            :return None
        """
        label_string = self.__new_label("string")

        self.data += [(label_string + ":",)]
        for symbol in expression.value:
            self.data += [(".word", str(ord(symbol)))]
        self.data += [(".word", str(00))]
        self.instructions += [("LOAD_ADDR", label_string)]

    def __translate_expr_if(self, expression: IfExpr):
        """Перевод if expression в ассемблер код
            :param expression:      выражение условий
            :return None
        """
        label_false = self.__new_label("if_false")
        label_end = self.__new_label("end")

        self.__translate_expr(expression.condition)
        self.instructions += [
            ("CMPI", "0"),
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
        """Перевод binary operation > expression в ассемблер код
            :param expression:      выражение бинарной операции
            :return None
        """
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
            ("LOADI", "0"),
            ("JUMP", label_end),
            (label_true + ":",),
            ("LOADI", "1"),
            (label_end + ":",)
        ]

    def __translate_expr_right(self, expression: BinaryExpr):
        """Перевод binary operation < expression в ассемблер код
            :param expression:      выражение бинарной операции
            :return None
        """
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
            ("LOADI", "1"),
            ("JUMP", label_end),
            (label_false + ":",),
            ("LOADI", "0"),
            (label_end + ":",)
        ]

    def __translate_expr_lefteq(self, expression: BinaryExpr):
        """Перевод binary operation >= expression в ассемблер код
            :param expression:      выражение бинарной операции
            :return None
        """
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
            ("LOADI", "0"),
            ("JUMP", label_end),
            (label_true + ":",),
            ("LOADI", "1"),
            (label_end + ":",)
        ]

    def __translate_expr_righteq(self, expression: BinaryExpr):
        """Перевод binary operation <= expression в ассемблер код
            :param expression:      выражение бинарной операции
            :return None
        """
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
            ("LOADI", "1"),
            ("JUMP", label_end),
            (label_false + ":",),
            ("LOADI", "0"),
            (label_end + ":",)
        ]

    def __translate_expr_eq(self, expression: BinaryExpr):
        """Перевод binary operation == expression в ассемблер код
            :param expression:      выражение бинарной операции
            :return None
        """
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
            ("LOADI", "1"),
            ("JUMP", label_end),
            (label_false + ":",),
            ("LOADI", "0"),
            ("JUMP", label_end),
            (label_end + ":",)
        ]

    def __translate_expr_not_eq(self, expression: BinaryExpr):
        """Перевод binary operation != expression в ассемблер код
            :param expression:      выражение бинарной операции
            :return None
        """
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
            ("LOADI", "0"),
            ("JUMP", label_end),
            (label_true + ":",),
            ("LOADI", "1"),
            (label_end + ":",)
        ]

    def __translate_expr_ident(self, expression: IdentifierExpr):
        """Перевод identifier expression в ассемблер код
            :param expression:      выражение уникального идентификатора
            :return None
        """
        is_local, address = self.__variable_address(expression.name)
        opcode = "LOAD_SP" if is_local else "LOAD"
        self.instructions += [(opcode, address)]

    def __translate_expr_set(self, expression: SetExpr):
        """Перевод set expression в ассемблер код
            :param expression:      выражение сохранения в переменную
            :return None
        """
        self.__translate_expr(expression.value)
        is_local, address = self.__variable_address(expression.target.name)
        opcode = "STORE_SP" if is_local else "STORE"
        self.instructions += [(opcode, address)]

    def __translate_expr_number(self, expression: NumberExpr):
        """Перевод number expression в ассемблер код
            :param expression:      выражение числа
            :return None
        """
        self.instructions += [("LOADI", f"{expression.value}")]

    def __translate_expr_sum(self, expression: BinaryExpr):
        """Перевод binary operation + expression в ассемблер код
            :param expression:      выражение бинарной операции
            :return None
        """
        self.__translate_expr(expression.left)
        self.__push()
        self.__translate_expr(expression.right)
        self.instructions += [("STORE", "$tmp$")]
        self.__pop()
        self.instructions += [("ADD", "$tmp$")]

    def __translate_expr_sub(self, expression: BinaryExpr):
        """Перевод binary operation - expression в ассемблер код
            :param expression:      выражение бинарной операции
            :return None
        """
        self.__translate_expr(expression.left)
        self.__push()
        self.__translate_expr(expression.right)
        self.instructions += [("STORE", "$tmp$")]
        self.__pop()
        self.instructions += [("SUB", "$tmp$")]

    def __translate_expr_mul(self, expression: BinaryExpr):
        """Перевод binary operation * expression в ассемблер код
            :param expression:      выражение бинарной операции
            :return None
        """
        self.__translate_expr(expression.left)
        self.__push()
        self.__translate_expr(expression.right)
        self.instructions += [("STORE", "$tmp$")]
        self.__pop()
        self.instructions += [("MUL", "$tmp$")]

    def __translate_expr_div(self, expression: BinaryExpr):
        """Перевод binary operation // expression в ассемблер код
            :param expression:      выражение бинарной операции
            :return None
        """
        self.__translate_expr(expression.left)
        self.__push()
        self.__translate_expr(expression.right)
        self.instructions += [("STORE", "$tmp$")]
        self.__pop()
        self.instructions += [("DIV", "$tmp$")]

    def __translate_expr_mod(self, expression: BinaryExpr):
        """Перевод binary operation % expression в ассемблер код
            :param expression:      выражение бинарной операции
            :return None
        """
        self.__translate_expr(expression.left)
        self.__push()
        self.__translate_expr(expression.right)
        self.instructions += [("STORE", "$tmp$")]
        self.__pop()
        self.instructions += [("MOD", "$tmp$")]

    def __translate_expr_array(self, expression: ArrayExpr):
        size = expression.size.value
        label_array = self.__new_label("array")
        self.data += [(label_array + ":",)]

        for _ in range(size):
            self.data += [(".word", "0")]

        self.instructions += [("LOAD_ADDR", label_array)]

    def __translate_expr_array_get(self, expression: ArrayGetExpr):
        address = expression.address
        index = expression.index

        self.__translate_expr(address)
        self.__push()
        self.__translate_expr(index)
        self.instructions += [
            ("STORE", "$tmp$")
        ]
        self.__pop()
        self.instructions += [
            ("ADD", "$tmp$"),
            ("STORE", "$tmp$"),
            ("LOAD_IND", "$tmp$")
        ]

    def __translate_expr_array_set(self, expression: ArraySetExpr):
        address = expression.address
        index = expression.index
        value = expression.value

        self.__translate_expr(address)
        self.__push()
        self.__translate_expr(index)
        self.instructions += [
            ("STORE", "$tmp$")
        ]
        self.__pop()
        self.instructions += [
            ("ADD", "$tmp$")
        ]
        self.__push()
        self.__translate_expr(value)

        self.instructions += [("STORE", "$tmp$")]
        self.__pop()
        self.instructions += [
            ("STORE", "$tmp_address$"),
            ("LOAD", "$tmp$"),
            ("STORE_IND", "$tmp_address$")
        ]

    def __translate_expr_string_alloc(self, expression: StringAllocExpr):
        size = expression.size.value
        label_string = self.__new_label("string")
        self.data += [(label_string + ":",)]

        for i in range(size):
            self.data += [(".word", "0")]
        self.data += [(".word", "0")]

        self.instructions += [("LOAD_ADDR", label_string)]

    def __translate_expr_get_char(self, expression: GetCharExpr):
        address = expression.address
        index = expression.index

        self.__translate_expr(address)
        self.__push()
        self.__translate_expr(index)

        self.instructions += [("STORE", "$tmp$")]
        self.__pop()

        self.instructions += [
            ("ADD", "$tmp$"),
            ("STORE", "$tmp$"),
            ("LOAD_IND", "$tmp$")
        ]

    def __translate_expr_set_char(self, expression: SetCharExpr):
        address = expression.address
        index = expression.index
        value = expression.value

        self.__translate_expr(address)
        self.__push()
        self.__translate_expr(index)

        self.instructions += [("STORE", "$tmp$")]

        self.__pop()

        self.instructions += [
            ("ADD", "$tmp$")
        ]

        self.__push()
        self.__translate_expr(value)

        self.instructions += [("STORE", "$tmp$")]
        self.__pop()

        self.instructions += [
            ("STORE", "$tmp_address$"),
            ("LOAD", "$tmp$"),
            ("STORE_IND", "$tmp_address$")
        ]

    def __translate_expr_irq_input(self, expression: DefuncExpr):
        self.__translate_expr_defunc(expression, "IRET")

    def __translate_expr_irq_output(self, expression: DefuncExpr):
        self.__translate_expr_defunc(expression, "IRET")

    def __select(self, ast_tree):
        """Создает список из глобальных переменных вычисленных из Expression выражений
            :param ast_tree:   дерево выражений
            :return None
        """
        for element_ast in ast_tree:
            self.__select_identifiers(element_ast, True)

        self.identifiers.add('$tmp$')
        self.identifiers.add("$tmp_address$")

        for identifier in self.identifiers:
            self.data.append((identifier, '.word', "0"))

    def __select_identifiers(self, expression: Expr, is_global: bool):
        """Выбирает глобальные переменные из Expression выражений
            :param expression: выражение
            :param is_global:  переменная флаг (отвечает за то является ли переменная локальной или глобальной)
            :return None
        """
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

        if isinstance(expression, PrintStringExpr):
            self.__select_identifiers(expression.value, is_global)
            return

        if isinstance(expression, PrintNumberExpr):
            self.__select_identifiers(expression.value, is_global)
            return

        if isinstance(expression, PrintCharExpr):
            self.__select_identifiers(expression.value, is_global)
            return

        if isinstance(expression, (ArraySetExpr, SetCharExpr)):
            self.__select_identifiers(expression.value, is_global)
            self.__select_identifiers(expression.index, is_global)
            self.__select_identifiers(expression.address, is_global)

        if isinstance(expression, (ArrayGetExpr, GetCharExpr)):
            self.__select_identifiers(expression.index, is_global)
            self.__select_identifiers(expression.address, is_global)

        if isinstance(expression, (ArrayExpr, StringAllocExpr)):
            self.__select_identifiers(expression.size, is_global)
        return
