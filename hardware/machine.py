import struct
from pathlib import Path

from config import WORD_SIZE
from hardware.cpu import CPU
from hardware.interrupts import Interrupts
from hardware.memory import InstructionMemory, DataMemory
from hardware.pipeline import Pipeline
from logger import Logger


class Machine:
    def __init__(self, path_output, result_path, input_schedule):
        self.instruction_memory = InstructionMemory()
        self.data_memory = DataMemory()
        self.pipeline = Pipeline()
        self.cpu = CPU(self.instruction_memory, self.data_memory, self.pipeline)
        self.interrupts = Interrupts(input_schedule)
        self.output_buffer = []

        self.instruction_count = 0
        self.data_count = 0
        self.tick_count = 0

        self.logger = Logger(path_output)
        self.result_path = result_path

    def run(self):
        while not self.cpu.halted and self.tick_count <= 100_000:
            self.tick_count += 1

            input_event = self.interrupts.tick_input(self.tick_count, self.data_memory)
            output_event = self.interrupts.tick_output(self.tick_count, self.data_memory)

            if input_event:
                self.cpu.request_interrupt("input")
            if output_event:
                self.cpu.request_interrupt("output")

            ex_state = (
                self.cpu.pipeline.id_ex_pc,
                self.cpu.pipeline.id_ex_opcode,
                self.cpu.pipeline.id_ex_operand,
                self.cpu.execute_step,
            )

            self.cpu.tick()

            if output_event == 1 and self.data_memory.load(7 * WORD_SIZE) == 0:
                self.output_buffer.append(self.data_memory.load(WORD_SIZE))

            self.logger.log(
                self.cpu,
                self.tick_count,
                ex_state,
            )

        print(self.output_buffer)
        print(''.join(chr(i) for i in self.output_buffer if isinstance(i, int) and 0 <= i <= 255))

        with open(self.result_path, "w", encoding="utf-8") as file:
            print(self.output_buffer, file=file)
            print(''.join(chr(i) for i in self.output_buffer if isinstance(i, int) and 0 <= i <= 255), file=file)

    def load_program(self, path: Path):
        binary_file = path.read_bytes()
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
            self.instruction_memory.store(address * WORD_SIZE, instruction)
        self.instruction_count = instruction_count

        for address, record in enumerate(data, start=2):
            self.data_memory.store(address * WORD_SIZE, record)
        self.data_count = data_count