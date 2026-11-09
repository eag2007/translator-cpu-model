import struct
from pathlib import Path

from config import WORD_SIZE
from hardware.cpu import CPU
from hardware.memory import InstructionMemory, DataMemory


class Machine:
    def __init__(self):
        self.instruction_memory = InstructionMemory()
        self.data_memory = DataMemory()
        self.cpu = CPU()

        self.instruction_count = 0
        self.data_count = 0
        self.tick_count = 0

    def load_program(self, path: str):
        binary_file = Path(path).read_bytes()
        offset = 0

        instruction_count = struct.unpack_from(">I", binary_file, offset)[0]
        offset += WORD_SIZE

        instructions = struct.unpack_from(f">{instruction_count}I", binary_file, offset)
        offset += instruction_count * WORD_SIZE

        data_count = struct.unpack_from(f">I", binary_file, offset)[0]
        offset += WORD_SIZE

        data = struct.unpack_from(f">{data_count}i", binary_file, offset)
        offset += data_count * WORD_SIZE

        for address, instruction in enumerate(instructions):
            self.instruction_memory.store(address, instruction)
        self.instruction_count = instruction_count

        for address, record in enumerate(data, start=2):
            self.data_memory.store(address, record)
        self.data_count = data_count