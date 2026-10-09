from dataclasses import dataclass
from lexer import Token, TokenType


class Expr:
    """Базовый класс-родитель выражения, задает общий тип"""
    pass


@dataclass
class NumberExpr(Expr):
    """Класс выражения числа
        :var value:         число
    """
    value: int


@dataclass
class StringExpr(Expr):
    """Класс выражения строки
        :var value:         строка
    """
    value: str


@dataclass
class IdentifierExpr(Expr):
    """Класс выражения идентификатора (переменной)
        :var name:          название переменной
    """
    name: str


@dataclass
class BinaryExpr(Expr):
    """Класс выражения бинарной операции
        :var operation:     операция
        :var left:          Expr выражение, левый операнд
        :var right:         Expr выражение, правый операнд
    """
    operation: str
    left: Expr
    right: Expr


@dataclass
class SetExpr(Expr):
    """Класс выражения объявления и изменения переменной
        :var target:        IdentifierExpr выражение, переменная
        :var value:         Expr выражение, значение переменной"""
    target: IdentifierExpr
    value: Expr


@dataclass
class IfExpr(Expr):
    """Класс выражения ветвления выражений
        :var condition:     Expr выражение, условие
        :var body:          list[Expr] выражения, тело если условие верное
        :var else_body:     list[Expr] | None выражение, тело если условие неверное или если блока else нет"""
    condition: Expr
    body: list[Expr]
    else_body: list[Expr] | None


@dataclass
class WhileExpr(Expr):
    """Класс выражение цикла
        :var condition:     Expr выражение, условие
        :var body:          list[Expr] выражений, тело цикла
    """
    condition: Expr
    body: list[Expr]


@dataclass
class RepeatExpr(Expr):
    """Класс выражение цикла со счётчиком
        :var count:     Expr выражение, счётчик
        :var body:          list[Expr] выражений, тело цикла
    """
    count: Expr
    body: list[Expr]


@dataclass
class FuncCallExpr(Expr):
    """Класс выражение вызова функции
        :var name:      имя функции
        :var args:      list[Expr] выражений, список аргументов функции
    """
    name: str
    args: list[Expr]


@dataclass
class DefuncExpr(Expr):
    """Класс объявления функции
        :var name:      имя функции
        :var params:    list[IdentifierExpr] выражений, список аргументов функции
        :var body:      list[Expr] выражений, тело функции"""
    name: str
    params: list[IdentifierExpr]
    body: list[Expr]


@dataclass
class InputExpr(Expr):
    """Класс выражения ввода значения"""
    pass


@dataclass
class PrintStringExpr(Expr):
    """Класс выражения вывода строки"""
    value: Expr


@dataclass
class PrintNumberExpr(Expr):
    """Класс выражения вывода числа"""
    value: Expr


class Parser:
    """Класс создающий AST дерево из токенов"""

    def __init__(self):
        """Инициализируем поля парсера
            :var self.tokens:               список токенов
            :var self.position:             текущая позиция
            :var self.len_tokens:           длина списка токенов
            :var self.trees:                список деревий, Expr выражений"""
        self.tokens = []
        self.position = 0
        self.len_tokens = 0
        self.trees = []

    def load_tokens(self, tokens: list[Token]) -> None:
        """Загружает токены в парсер
            :var tokens:                    список токенов
            :return None
            """
        self.tokens: list[Token] = tokens
        self.len_tokens = len(self.tokens)
        self.position = 0
        self.trees = []

    def parse(self):
        """Создает дерево и возвращает его
            :return self.tress:             list[Expr] полученный после парсинга токенов
        """
        self.__made_trees()
        return self.trees

    def __made_trees(self):
        """Создает деревья выражений из оставшихся токенов и добавляет их в self.trees
            :return None
        """
        while self.position < self.len_tokens:
            self.trees.append(self.__parse_expr())

    def __get_token(self) -> Token:
        """Возвращает текущий токен и перемещает позицию на следующий
            :return token:          текущий токен
        """
        token = self.tokens[self.position]
        self.position += 1
        return token

    def __parse_expr(self) -> Expr:
        """Возвращает текущий токен и перемещает позицию на следующий
            :return token:          текущий токен
        """
        token = self.__get_token()

        if token.type == TokenType.NUMBER:
            return NumberExpr(token.value)

        elif token.type == TokenType.STRING:
            return StringExpr(token.value)

        elif token.type == TokenType.IDENTIFIER:
            return IdentifierExpr(token.value)

        elif token.type == TokenType.LBRACKET:
            token = self.__get_token()

            if token.type in [
                TokenType.PLUS, TokenType.MINUS, TokenType.MULT, TokenType.DIV,
                TokenType.EQUALS, TokenType.NOTEQUALS, TokenType.LEFT, TokenType.RIGHT,
                TokenType.LEFTEQ, TokenType.RIGHTEQ, TokenType.MOD
            ]:
                return self.__parse_bin(token)

            elif token.type == TokenType.SET:
                return self.__parse_set(token)

            elif token.type == TokenType.INPUT:
                return self.__parse_input(token)

            elif token.type == TokenType.PRINT_STRING:
                return self.__parse_print_string(token)

            elif token.type == TokenType.PRINT_NUMBER:
                return self.__parse_print_number(token)

            elif token.type == TokenType.IF:
                return self.__parse_if(token)

            elif token.type == TokenType.REPEAT:
                return self.__parse_repeat(token)

            elif token.type == TokenType.WHILE:
                return self.__parse_while(token)

            elif token.type == TokenType.DEFUNC:
                return self.__parse_defunc(token)

            elif token.type == TokenType.FUNCALL:
                return self.__parse_funcall(token)

            raise SyntaxError(f"Неизвестное выражение: {token}")
        raise SyntaxError(f"Неизвестное выражение: {token}")

    def __parse_bin(self, operation) -> BinaryExpr:
        """Разбирает два операнда бинарной операции и проверяет закрывающую скобку
            :var operation:             токен бинарной операции
            :return BinaryExpr:         выражение бинарной операции
        """
        left = self.__parse_expr()
        right = self.__parse_expr()

        is_closing = self.__get_token()

        if is_closing.type != TokenType.RBRACKET:
            raise SyntaxError(f"Скобка не закрыта")

        return BinaryExpr(operation.value, left, right)

    def __parse_set(self, _) -> SetExpr:
        """Разбирает имя переменной и ее значение, проверяет закрывающую скобку
            :var _:                     токен set, не используется
            :return SetExpr:            выражение объявления или изменения переменной
        """
        target = self.__get_token()

        if target.type != TokenType.IDENTIFIER:
            raise SyntaxError(f"Переменная названа не правильно")

        value = self.__parse_expr()
        is_closing = self.__get_token()

        if is_closing.type != TokenType.RBRACKET:
            raise SyntaxError(f"Скобка не закрыта")

        return SetExpr(IdentifierExpr(target.value), value)

    def __parse_input(self, _) -> InputExpr:
        """Проверяет закрывающую скобку и создает выражение ввода
            :var _:                     токен input, не используется
            :return InputExpr:          выражение ввода значения
        """
        is_closing = self.__get_token()

        if is_closing.type != TokenType.RBRACKET:
            raise SyntaxError(f"Скобка не закрыта")
        return InputExpr()

    def __parse_print_string(self, _) -> PrintStringExpr:
        """Разбирает выводимую строку и проверяет закрывающую скобку
            :var _:                     токен print_string, не используется
            :return PrintExpr:          выражение вывода значения
        """
        value = self.__parse_expr()
        is_closing = self.__get_token()

        if is_closing.type != TokenType.RBRACKET:
            raise SyntaxError(f"Скобка не закрыта")

        return PrintStringExpr(value)

    def __parse_print_number(self, _) -> PrintNumberExpr:
        """Разбирает код выводимого числа и проверяет закрывающую скобку
            :var _:                     токен print_number, не используется
            :return PrintChrExpr:       выражение вывода символа
        """
        value = self.__parse_expr()
        is_closing = self.__get_token()

        if is_closing.type != TokenType.RBRACKET:
            raise SyntaxError(f"Скобка не закрыта")

        return PrintNumberExpr(value)

    def __parse_if(self, _) -> IfExpr:
        """Разбирает условие, тело if и блок else при его наличии
            :var _:                     токен if, не используется
            :return IfExpr:             выражение ветвления, else_body равно None если блока else нет
        """
        condition = self.__parse_expr()
        body = self.__parse_body()

        else_body = None

        if self.position + 1 < self.len_tokens and \
                self.tokens[self.position].type == TokenType.LBRACKET and \
                self.tokens[self.position + 1].type == TokenType.ELSE:
            self.__get_token()  # (
            self.__get_token()  # else

            else_body = self.__parse_body()
            is_closing = self.__get_token()

            if is_closing.type != TokenType.RBRACKET:
                raise SyntaxError("Скобка else не закрыта")

        is_closing = self.__get_token()

        if is_closing.type != TokenType.RBRACKET:
            raise SyntaxError("Скобка if не закрыта")

        return IfExpr(condition, body, else_body)

    def __parse_funcall(self, _):
        """Разбирает имя функции, список аргументов и проверяет закрывающие скобки
            :var _:                     токен funcall, не используется
            :return FuncCallExpr:       выражение вызова функции
        """
        name = self.__get_token()

        if name.type != TokenType.IDENTIFIER:
            raise SyntaxError("Неправильное имя функции")

        opening = self.__get_token()

        if opening.type != TokenType.LBRACKET:
            raise SyntaxError("Неправильный вызов функции")

        args = []

        while self.tokens[self.position].type != TokenType.RBRACKET:
            args.append(self.__parse_expr())

        self.__get_token()  # закрыть аргументы

        is_closing = self.__get_token()  # закрыть вызов

        if is_closing.type != TokenType.RBRACKET:
            raise SyntaxError("Нет закрывающей скобки при вызове функции")

        return FuncCallExpr(name.value, args)

    def __parse_defunc(self, _):
        """Разбирает имя функции, список параметров, тело и проверяет закрывающую скобку
            :var _:                     токен defunc, не используется
            :return DefuncExpr:         выражение объявления функции
        """
        name = self.__get_token()

        if name.type != TokenType.IDENTIFIER:
            raise SyntaxError("Неправильное имя функции")

        opening = self.__get_token()

        if opening.type != TokenType.LBRACKET:
            raise SyntaxError("Неправильно заданы параметры")

        params = []

        while self.tokens[self.position].type != TokenType.RBRACKET:
            param = self.__get_token()

            if param.type != TokenType.IDENTIFIER:
                raise SyntaxError("Неправильное имя параметра")

            params.append(IdentifierExpr(param.value))

        self.__get_token()  # закрыть (a, ...)

        body = self.__parse_body()
        is_closing = self.__get_token()

        if is_closing.type != TokenType.RBRACKET:
            raise SyntaxError("Функция не закрыта")

        return DefuncExpr(name.value, params, body)

    def __parse_while(self, _) -> WhileExpr:
        """Разбирает условие, тело цикла while и проверяет закрывающую скобку
            :var _:                     токен while, не используется
            :return WhileExpr:          выражение цикла с условием
        """
        condition = self.__parse_expr()
        body = self.__parse_body()

        is_closing = self.__get_token()

        if is_closing.type != TokenType.RBRACKET:
            raise SyntaxError("Скобка while не закрыта")

        return WhileExpr(condition, body)

    def __parse_repeat(self, _) -> RepeatExpr:
        """Разбирает количество повторений, тело цикла repeat и проверяет закрывающую скобку
            :var _:                     токен repeat, не используется
            :return RepeatExpr:         выражение цикла со счетчиком
        """
        count = self.__parse_expr()
        body = self.__parse_body()

        is_closing = self.__get_token()

        if is_closing.type != TokenType.RBRACKET:
            raise SyntaxError("Скобка repeat не закрыта")

        return RepeatExpr(count, body)

    def __parse_body(self) -> list[Expr]:
        """Разбирает количество повторений, тело цикла repeat и проверяет закрывающую скобку
            :var _:                     токен repeat, не используется
            :return RepeatExpr:         выражение цикла со счетчиком
        """
        opening = self.__get_token()

        if opening.type != TokenType.LBRACKET:
            raise SyntaxError(f"Ожидалась открывающаяся скобка для открытия блока")

        body = []
        while self.tokens[self.position].type != TokenType.RBRACKET:
            body.append(self.__parse_expr())

        is_closing = self.__get_token()
        if is_closing.type != TokenType.RBRACKET:
            raise SyntaxError(f"Скобка блока не закрыта")

        return body
