import argparse
import ast
import sys
from pathlib import Path
from pprint import pprint

from compiler.binary import binary_function
from compiler.compile import Compile
from compiler.lexer import Lexer
from compiler.parser import Parser
from hardware.machine import Machine


if __name__ == "__main__":
    if len(sys.argv) == 2 and sys.argv[1] == "clear":
        output_path = Path("output")

        if output_path.exists():
            for path in sorted(output_path.rglob("*"), reverse=True):
                if path.is_file():
                    path.unlink()
                elif path.is_dir():
                    path.rmdir()

        print("папка output очищена")
        exit()

    parser = argparse.ArgumentParser()

    parser.add_argument("source", help="файл программы на lisp")
    parser.add_argument("--input", help="файл расписания ввода")
    parser.add_argument("--pipeline", nargs="?", const="True", default="False", choices=("True", "False"), help="True — с конвейером, False — без конвейера")

    arg = parser.parse_args()

    source_path = Path(arg.source)
    name = source_path.stem

    input_schedule = []

    if arg.input:
        input_text = Path(arg.input).read_text(encoding="utf-8")
        input_schedule = ast.literal_eval(input_text)

    output_path = Path("output")
    for directory in ("asm", "bin", "expressions", "hex", "logs", "tokens", "results"):
        (output_path / directory).mkdir(parents=True, exist_ok=True)

    asm_path = output_path / "asm" / f"{name}.asm"
    bin_path = output_path / "bin" / f"{name}.asm"
    expressions_path = output_path / "expressions" / f"{name}.conf"
    hex_path = output_path / "hex" / f"{name}.hex"
    logs_path = output_path / "logs" / f"{name}.log"
    tokens_path = output_path / "tokens" / f"{name}.conf"
    results_path = output_path / "results" / f"{name}.text"

    system_source = Path("compiler/system.lisp").read_text(encoding="utf-8")
    program_source = source_path.read_text(encoding="utf-8")

    lexer = Lexer()
    lexer.load_source(system_source + "\n" + program_source)
    tokens = lexer.get_tokens()

    with open(tokens_path, "w", encoding="utf-8") as file:
        pprint(tokens, stream=file, width=80, sort_dicts=False)

    program_parser = Parser()
    program_parser.load_tokens(tokens)
    ast_tree = program_parser.parse()

    with open(expressions_path, "w", encoding="utf-8") as file:
        pprint(ast_tree, stream=file, width=80, sort_dicts=False)

    compiler = Compile()
    compiler.load_ast(ast_tree)
    data, instructions = compiler.get_data(), compiler.get_instructions()

    with open(asm_path, "w", encoding="utf-8") as file:
        for i in data:
            print(f"{i[0]:<24} {' '.join(i[1:])}".rstrip(), file=file)

        for i in instructions:
            if i[0].endswith(":"):
                print(i[0], file=file)
            else:
                print(f"    {i[0]:<8} {' '.join(i[1:])}".rstrip(), file=file)

    binary_function(data, instructions, bin_path, hex_path)

    logs_path.write_text("", encoding="utf-8")

    machine = Machine(logs_path, results_path, input_schedule, arg.pipeline == "True")
    machine.load_program(bin_path)
    machine.run()
