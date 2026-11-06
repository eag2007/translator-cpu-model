from config import OPCODE_TABLE
from struct import pack


def binary_function(data: list[tuple[str, ...]], instructions: list[tuple[str, ...]]) -> None:
    # ячейка 0 занята под адрес mmio ввода
    # ячейка 1 занята под адрес mmio вывода
    address_data = 2
    address_instructions = 0

    data_labels: dict[str, int] = make_data_labels(data, address_data)
    instructions_labels: dict[str, int] = make_instructions_label(instructions, address_instructions)

    instructions_binary = make_binary_instructions(instructions, data_labels, instructions_labels)
    data_binary = make_binary_data(data)

    instructions_hex = make_hex_instructions(instructions, instructions_binary)
    data_hex = make_hex_data(data, data_binary, address_data)

    with open("output/bin/main.bin", "wb") as file:
        file.write(pack(">I", len(instructions_binary)))

        for instruction_bin in instructions_binary:
            file.write(pack(">I", instruction_bin))

        file.write(pack(">I", len(data_binary)))
        for data_bin in data_binary:
            file.write(pack(">I", data_bin))

    with open("output/hex/main.hex", "w", encoding="UTF-8") as file:
        file.write(f"[instructions: {len(instructions_binary)} words]\n")
        file.write("\n".join(instructions_hex))

        file.write(f"\n\n[data: {len(data_binary)} words]\n")
        file.write("\n".join(data_hex))

        file.write("\n")


def make_data_labels(data, data_counter: int) -> dict[str, int]:
    data_labels: dict[str, int] = {}

    for record in data:
        parts = list(record)

        if parts[0] != ".word" and len(parts) == 3:
            label, _, value = parts
            data_labels[label] = data_counter

        elif len(parts) == 1:
            label = parts[0]
            data_labels[label[:-1]] = data_counter
            continue

        data_counter += 1
    return data_labels


def make_instructions_label(instructions, instruction_counter: int) -> dict[str, int]:
    instructions_labels: dict[str, int] = {}

    for record in instructions:
        parts = list(record)

        if len(parts) == 1 and parts[0][-1] == ":":
            label = parts[0]
            instructions_labels[label[:-1]] = instruction_counter
            continue

        instruction_counter += 1
    return instructions_labels


def make_binary_instructions(instructions: list[tuple[str, ...]], data_labels: dict[str, int],
                             instructions_labels: dict[str, int]) -> list[int]:
    words: list[int] = []

    move_commands = {"JUMP", "BGE", "BEQ", "CALL"}
    signed_commands = {"LOADI", "STORE_SP", "LOAD_SP", "ADDI", "SUBI", "MULI", "DIVI", "MODI", "CMPI"}

    for instruction in instructions:
        if instruction[0][-1] == ":":
            continue

        command = instruction[0]
        operand = 0
        opcode = OPCODE_TABLE[command.lower()][0]

        if len(instruction) == 2:
            argument = instruction[1]

            if command in move_commands:
                labels = instructions_labels
            else:
                labels = data_labels

            if argument in labels:
                operand = labels[argument]
            else:
                operand = int(argument)

        if command in signed_commands:
            if not -(1 << 23) <= operand < (1 << 23):
                raise ValueError(f"Операнд не помещается в знаковые 24 бита: {instruction}")
        elif not 0 <= operand < (1 << 24):
            raise ValueError(f"Операнл не помещается в беззнаковые 24 бита: {instruction}")

        word = (opcode << 24) | (operand & 0xFFFFFF)
        words.append(word)
    return words


def make_binary_data(data: list[tuple[str, ...]]):
    words: list[int] = []

    for word in data:
        if len(word) == 1:
            continue

        value = 0 if word[-1] == "?" else int(word[-1])

        if not -(1 << 31) <= value < (1 << 31):
            raise ValueError(f"Значение не помещается в знаковые 32 битные числа: {word}")

        words.append(value & 0xFFFFFFFF)
    return words


def make_hex_instructions(instructions: list[tuple[str, ...]], instructions_binary: list[int]) -> list[str]:
    lines: list[str] = []
    index = 0

    signed_commands = {
        "LOADI", "STORE_SP", "LOAD_SP",
        "ADDI", "SUBI", "MULI", "DIVI", "MODI", "CMPI",
    }
    for instruction in instructions:
        command = instruction[0]

        if command.endswith(":"):
            continue

        word = instructions_binary[index]
        argument = ""

        if len(instruction) == 2:
            operand = word & 0xFFFFFF

            if command in signed_commands:
                if operand & 0x800000:
                    operand -= 1 << 24

                if command in {"LOAD_SP", "STORE_SP"}:
                    argument = f"{operand:+d}"
                else:
                    argument = f"#{operand}"
            else:
                argument = f"0x{operand:04X}"

        mnemonic = f"{command.lower()   :<12}{argument}"
        lines.append(f"0x{index:04X}   -   {word:08X}   -   {mnemonic}".rstrip())
        index += 1

    return lines


def make_hex_data(data: list[tuple[str, ...]], data_binary: list[int], address_data: int) -> list[str]:
    lines: list[str] = []
    index = 0

    for record in data:
        if len(record) == 1:
            continue

        word = data_binary[index]
        value = 0 if record[-1] == "?" else int(record[-1])
        lines.append(f"0x{address_data:04X}   -   {word:08X}   -   {'.word':<12}{value}")
        index += 1
        address_data += 1

    return lines
