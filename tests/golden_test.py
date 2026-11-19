import base64
import os
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
GOLDEN_DIR = ROOT / "golden"
MAX_LINES = 1000

NAMES = (
    "cat",
    "double_precision",
    "double_set",
    "factorial",
    "format_string",
    "hello",
    "hello_user_name",
    "is_prime",
    "sort",
)


def limit_lines(text):
    return "\n".join(text.splitlines()[:MAX_LINES])


def run_program(case):
    with tempfile.TemporaryDirectory() as directory:
        work = Path(directory)

        (work / "compiler").mkdir()
        (work / "compiler/system.lisp").write_bytes(
            (ROOT / "compiler/system.lisp").read_bytes()
        )
        (work / "program.lisp").write_text(case["in_source"], encoding="utf-8")
        (work / "input.txt").write_text(case["in_schedule"], encoding="utf-8")

        result = subprocess.run(
            [
                sys.executable,
                str(ROOT / "main.py"),
                "program.lisp",
                "--input",
                "input.txt",
                "--pipeline",
                str(case["in_pipeline"]),
            ],
            cwd=work,
            env=dict(os.environ, PYTHONIOENCODING="utf-8"),
            capture_output=True,
            text=True,
            encoding="utf-8",
            timeout=45,
            check=False,
        )

        if result.returncode != 0:
            raise RuntimeError(
                f"main.py завершился с кодом {result.returncode}:\n{result.stderr}"
            )

        output = work / "output"

        def read(path):
            return (output / path).read_text(encoding="utf-8")

        return {
            "out_stdout": limit_lines(result.stdout),
            "out_stderr": limit_lines(result.stderr),
            "out_result": limit_lines(read("results/program.text")),
            "out_asm": limit_lines(read("asm/program.asm")),
            "out_binary": (output / "bin/program.asm").read_bytes(),
            "out_hex": limit_lines(read("hex/program.hex")),
            "out_log": limit_lines(read("logs/program.log").expandtabs(4)),
        }


def save_case(path, case):
    with path.open("w", encoding="utf-8", newline="\n") as file:
        for key, value in case.items():
            if isinstance(value, bool):
                text = "true" if value else "false"
                file.write(f"{key}: {text}\n")

            elif isinstance(value, bytes):
                encoded = base64.b64encode(value).decode("ascii")

                file.write(f"{key}: !!binary |\n")

                for start in range(0, len(encoded), 76):
                    line = encoded[start : start + 76]
                    file.write(f"  {line}\n")

            elif isinstance(value, str):
                if not value:
                    file.write(f"{key}: ''\n")
                    continue

                if any(ord(char) < 32 and char not in "\n\t" for char in value):
                    raise ValueError(f"{key}: в тексте найден управляющий символ")

                ending = len(value) - len(value.rstrip("\n"))

                if ending == 0:
                    marker = "|-"
                elif ending == 1:
                    marker = "|"
                else:
                    marker = "|+"

                file.write(f"{key}: {marker}\n")

                for line in value.splitlines(keepends=True):
                    file.write("  " + line)

                    if not line.endswith("\n"):
                        file.write("\n")

            else:
                raise TypeError(f"{key}: неподдерживаемый тип {type(value).__name__}")

    loaded = yaml.safe_load(path.read_text(encoding="utf-8"))

    if loaded != case:
        raise ValueError(f"Не удалось точно сохранить YAML: {path}")


def create_goldens():
    GOLDEN_DIR.mkdir(exist_ok=True)

    for name in NAMES:
        for pipeline in (False, True):
            suffix = "pipeline" if pipeline else "serial"
            path = GOLDEN_DIR / f"{name}_{suffix}.yml"

            if path.exists():
                continue

            source_path = ROOT / "example" / f"{name}.lisp"
            input_path = ROOT / "input" / name

            case = {
                "in_source": limit_lines(source_path.read_text(encoding="utf-8")),
                "in_schedule": limit_lines(input_path.read_text(encoding="utf-8")),
                "in_pipeline": pipeline,
            }

            case.update(run_program(case))
            save_case(path, case)

            print(f"Создан: {path.relative_to(ROOT)}")


def update_goldens():
    paths = sorted(GOLDEN_DIR.glob("*.yml"))

    if not paths:
        raise SystemExit("Нет файлов golden/*.yml")

    for path in paths:
        case = yaml.safe_load(path.read_text(encoding="utf-8"))

        case["in_source"] = limit_lines(case["in_source"])
        case["in_schedule"] = limit_lines(case["in_schedule"])

        case.update(run_program(case))
        save_case(path, case)

        print(f"Обновлён: {path.relative_to(ROOT)}")


class GoldenTests(unittest.TestCase):
    maxDiff = None

    def test_golden(self):
        paths = sorted(GOLDEN_DIR.glob("*.yml"))

        self.assertTrue(paths, "Нет файлов golden/*.yml")

        for path in paths:
            with self.subTest(file=path.name):
                case = yaml.safe_load(path.read_text(encoding="utf-8"))
                actual = run_program(case)

                for field, value in actual.items():
                    self.assertIn(
                        field,
                        case,
                        f"{path.name}: нет поля {field}",
                    )

                    self.assertEqual(
                        case[field],
                        value,
                        f"{path.name}: {field}",
                    )


if __name__ == "__main__":
    if sys.argv[1:] == ["--create"]:
        create_goldens()

    elif sys.argv[1:] == ["--update-goldens"]:
        update_goldens()

    else:
        unittest.main()
