from dataclasses import dataclass
from enum import Enum, auto


class TokenType(Enum):
    LBRACKET = auto()
    RBRACKET = auto()

    NUMBER = auto()
    STRING = auto()
    IDENTIFIER = auto()

    DEFUNC = auto()
    SET = auto()
    IF = auto()
    ELSE = auto()
    WHILE = auto()
    REPEAT = auto()
    FUNCALL = auto()

    INPUT = auto()
    PRINT = auto()
    PRINTCHR = auto()

    PLUS = auto()
    MINUS = auto()
    MULT = auto()
    DIV = auto()
    MOD = auto()

    EQUALS = auto()
    NOTEQUALS = auto()
    LEFT = auto()
    RIGHT = auto()
    LEFTEQ = auto()
    RIGHTEQ = auto()


@dataclass
class Token:
    type: TokenType
    value: object

    def __repr__(self) -> str:
        return f"Token({self.type.name}, {self.value!r})"


class Lexer:
    NUMBER_PATTERN = r"-?\d+"
    STRING_PATTERN = r'"[^"\\]*(?:\\.[^"\\]*)*"'
    IDENTIFIER_PATTERN = r"[a-zA-Z_][a-zA-Z0-9_]*"

    KEYWORDS = {
        "(": TokenType.LBRACKET,
        ")": TokenType.RBRACKET,
        # r"-?\d+": TokenType.NUMBER,
        # r"'[^'\\]*(?:\\.[^'\\]*)*'": TokenType.STRING,
        # r'[a-zA-Z_][a-zA-Z0-9_]*': TokenType.IDENTIFIER,
        "defunc": TokenType.DEFUNC,
        "set": TokenType.SET,
        "if": TokenType.IF,
        "else": TokenType.ELSE,
        "while": TokenType.WHILE,
        "repeat": TokenType.REPEAT,
        "funcall": TokenType.FUNCALL,
        "input": TokenType.INPUT,
        "print": TokenType.PRINT,
        "printchr": TokenType.PRINTCHR,
        "+": TokenType.PLUS,
        "-": TokenType.MINUS,
        "*": TokenType.MULT,
        "/": TokenType.DIV,
        "%": TokenType.MOD,
        "==": TokenType.EQUALS,
        "!=": TokenType.NOTEQUALS,
        ">": TokenType.LEFT,
        "<": TokenType.RIGHT,
        ">=": TokenType.LEFTEQ,
        "<=": TokenType.RIGHTEQ
    }

    def __init__(self) -> None:
        self.source: str = ""
        self.len_source: int = 0
        self.position: int = 0
        self.tokens: list[Token] = []

    def __made_tokens(self) -> None:
        while self.position < self.len_source:
            mask1 = self.source[self.position]
            mask2 = self.source[self.position:self.position + 2]
            mask3 = self.source[self.position:self.position + 3]
            mask4 = self.source[self.position:self.position + 4]
            mask5 = self.source[self.position:self.position + 5]
            mask6 = self.source[self.position:self.position + 6]
            mask7 = self.source[self.position:self.position + 7]
            mask8 = self.source[self.position:self.position + 8]

            if mask1 in [" ", "\t", "\n"]:
                self.position += 1

            elif mask1 == "-" and self.position + 1 < self.len_source and self.source[self.position + 1].isdigit():
                end = self.position + 1

                while end < self.len_source and self.source[end].isdigit():
                    end += 1

                value = self.source[self.position:end]
                self.tokens.append(Token(TokenType.NUMBER, int(value)))
                self.position = end

            elif mask2 in ["if", "==", "<=", ">=", "!="]:
                self.position += 2
                self.tokens.append(Token(self.KEYWORDS[mask2], mask2))

            elif mask1 in ["-", "+", "*", "/", "(", ")", "<", ">", "%"]:
                self.position += 1
                self.tokens.append(Token(self.KEYWORDS[mask1], mask1))

            elif mask3 in ["set"]:
                self.position += 3
                self.tokens.append(Token(self.KEYWORDS[mask3], mask3))

            elif mask4 in ["else"]:
                self.position += 4
                self.tokens.append(Token(self.KEYWORDS[mask4], mask4))

            elif mask8 in ["printchr"]:
                self.position += 8
                self.tokens.append(Token(self.KEYWORDS[mask8], mask8))

            elif mask5 in ["while", "print", "input"]:
                self.position += 5
                self.tokens.append(Token(self.KEYWORDS[mask5], mask5))

            elif mask6 in ["repeat", "defunc"]:
                self.position += 6
                self.tokens.append(Token(self.KEYWORDS[mask6], mask6))

            elif mask7 in ["funcall"]:
                self.position += 7
                self.tokens.append(Token(self.KEYWORDS[mask7], mask7))

            elif mask1 == '"':
                end = self.position + 1
                while end < self.len_source and self.source[end] != '"':
                    end += 1
                value = self.source[self.position + 1:end]
                self.tokens.append(Token(TokenType.STRING, value))
                self.position = end + 1

            elif mask1.isdigit():
                end = self.position
                while end < self.len_source and self.source[end].isdigit():
                    end += 1
                value = self.source[self.position:end]
                self.tokens.append(Token(TokenType.NUMBER, int(value)))
                self.position = end

            elif mask1.isalpha() or mask1 == "_":
                end = self.position
                while end < self.len_source and (self.source[end].isalnum() or self.source[end] == "_"):
                    end += 1
                value = self.source[self.position:end]
                self.tokens.append(Token(TokenType.IDENTIFIER, value))
                self.position = end

            else:
                self.position += 1

    def get_tokens(self) -> list[Token]:
        return self.tokens

    def load_source(self, source: str) -> None:
        self.source = source
        self.len_source = len(source)
        self.position = 0
        self.__made_tokens()