import struct
from pathlib import Path

from config import WORD_SIZE
from hardware.cpu import CPU
from hardware.memory import InstructionMemory, DataMemory
from hardware.pipeline import Pipeline
from logger import Logger


class Machine:
    def __init__(self, path_output):
        self.instruction_memory = InstructionMemory()
        self.data_memory = DataMemory()
        self.pipeline = Pipeline()
        self.cpu = CPU(self.instruction_memory, self.data_memory, self.pipeline)

        self.instruction_count = 0
        self.data_count = 0
        self.tick_count = 0

        import os

        print(os.path.abspath(__file__))
        self.logger = Logger(path_output)

    def run(self):
        while not self.cpu.halted:
            ex_state = (
                self.cpu.pipeline.id_ex_pc,
                self.cpu.pipeline.id_ex_opcode,
                self.cpu.pipeline.id_ex_operand,
                self.cpu.execute_step,
            )

            self.cpu.tick()
            self.tick_count += 1

            self.logger.log(
                self.cpu,
                self.tick_count,
                ex_state,
            )

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