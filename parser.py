from dataclasses import dataclass
from lexer import Token, TokenType


class Expr:
    pass


@dataclass
class NumberExpr(Expr):
    value: int


@dataclass
class StringExpr(Expr):
    value: str


@dataclass
class IdentifierExpr(Expr):
    name: str


@dataclass
class BinaryExpr(Expr):
    operation: str
    left: Expr
    right: Expr


@dataclass
class SetExpr(Expr):
    target: IdentifierExpr
    value: Expr


@dataclass
class IfExpr(Expr):
    condition: Expr
    body: list[Expr]
    else_body: list[Expr] | None


@dataclass
class WhileExpr(Expr):
    condition: Expr
    body: list[Expr]


@dataclass
class RepeatExpr(Expr):
    count: Expr
    body: list[Expr]


@dataclass
class FuncCallExpr(Expr):
    name: str
    args: list[Expr]


@dataclass
class DefuncExpr(Expr):
    name: str
    params: list[IdentifierExpr]
    body: list[Expr]


@dataclass
class InputExpr(Expr):
    pass


@dataclass
class PrintExpr(Expr):
    value: Expr


@dataclass
class PrintChrExpr(Expr):
    value: Expr


class Parser:
    def __init__(self):
        self.tokens = []
        self.position = 0
        self.len_tokens = 0
        self.trees = []

    def load_tokens(self, tokens: list[Token]) -> None:
        self.tokens: list[Token] = tokens
        self.len_tokens = len(self.tokens)
        self.position = 0
        self.trees = []

    def parse(self):
        self.__made_trees()
        return self.trees

    def __made_trees(self):
        while self.position < self.len_tokens:
            self.trees.append(self.__parse_expr())

    def __get_token(self) -> Token:
        token = self.tokens[self.position]
        self.position += 1
        return token

    def __parse_expr(self) -> Expr:
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
                TokenType.LEFTEQ, TokenType.RIGHTEQ
            ]:
                return self.__parse_bin(token)

            elif token.type == TokenType.SET:
                return self.__parse_set(token)

            elif token.type == TokenType.INPUT:
                return self.__parse_input(token)

            elif token.type == TokenType.PRINT:
                return self.__parse_print(token)

            elif token.type == TokenType.PRINTCHR:
                return self.__parse_printchr(token)

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
        left = self.__parse_expr()
        right = self.__parse_expr()

        is_closing = self.__get_token()

        if is_closing.type != TokenType.RBRACKET:
            raise SyntaxError(f"Скобка не закрыта")

        return BinaryExpr(operation.value, left, right)

    def __parse_set(self, _) -> SetExpr:
        target = self.__get_token()

        if target.type != TokenType.IDENTIFIER:
            raise SyntaxError(f"Переменная названа не правильно")

        value = self.__parse_expr()
        is_closing = self.__get_token()

        if is_closing.type != TokenType.RBRACKET:
            raise SyntaxError(f"Скобка не закрыта")

        return SetExpr(IdentifierExpr(target.value), value)

    def __parse_input(self, _) -> InputExpr:
        is_closing = self.__get_token()

        if is_closing.type != TokenType.RBRACKET:
            raise SyntaxError(f"Скобка не закрыта")
        return InputExpr()

    def __parse_print(self, _) -> PrintExpr:
        value = self.__parse_expr()
        is_closing = self.__get_token()

        if is_closing.type != TokenType.RBRACKET:
            raise SyntaxError(f"Скобка не закрыта")

        return PrintExpr(value)

    def __parse_printchr(self, _) -> PrintChrExpr:
        value = self.__parse_expr()
        is_closing = self.__get_token()

        if is_closing.type != TokenType.RBRACKET:
            raise SyntaxError(f"Скобка не закрыта")

        return PrintChrExpr(value)

    def __parse_if(self, _) -> IfExpr:
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

        is_closing = self.__get_token()     # закрыть вызов

        if is_closing.type != TokenType.RBRACKET:
            raise SyntaxError("Нет закрывающей скобки при вызове функции")

        return FuncCallExpr(name.value, args)

    def __parse_defunc(self, _):
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

        self.__get_token() # закрыть (a, ...)

        body = self.__parse_body()
        is_closing = self.__get_token()

        if is_closing.type != TokenType.RBRACKET:
            raise SyntaxError("Функция не закрыта")

        return DefuncExpr(name.value, params, body)

    def __parse_while(self, _) -> WhileExpr:
        condition = self.__parse_expr()
        body = self.__parse_body()

        is_closing = self.__get_token()

        if is_closing.type != TokenType.RBRACKET:
            raise SyntaxError("Скобка while не закрыта")

        return WhileExpr(condition, body)

    def __parse_repeat(self, _) -> RepeatExpr:
        count = self.__parse_expr()
        body = self.__parse_body()

        is_closing = self.__get_token()

        if is_closing.type != TokenType.RBRACKET:
            raise SyntaxError("Скобка repeat не закрыта")

        return RepeatExpr(count, body)

    def __parse_body(self) -> list[Expr]:
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