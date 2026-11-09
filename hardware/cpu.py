from config import MEMORY_SIZE, OPCODE_TABLE
from hardware.memory import InstructionMemory, DataMemory
from hardware.pipeline import Pipeline


class CPU:
    def __init__(self, instruction_memory: InstructionMemory, data_memory: DataMemory, pipeline: Pipeline):
        self.acc = 0
        self.dr = 0
        self.sp = MEMORY_SIZE
        self.pc = 0
        self.ir = 0
        self.flags = [0, 0, 0, 0]  # NZVC
        self.ar = 0
        self.halted = False

        self.instruction_memory = instruction_memory
        self.data_memory = data_memory

        self.pipeline = pipeline
        self.execute_step = 0

    def instruction_fetch(self):
        self.pipeline.if_id_pc = self.pc
        self.pipeline.if_id_instruction = self.instruction_memory.load(self.pc)

    def decode_fetch(self):
        instruction = self.pipeline.if_id_instruction

        if instruction is not None:
            self.ir = instruction

            self.pipeline.id_ex_pc = self.pipeline.if_id_pc
            self.pipeline.id_ex_opcode = self.pipeline.if_id_instruction >> 24
            self.pipeline.id_ex_operand = self.pipeline.if_id_instruction & 0xFFFFFF
        else:
            self.pipeline.id_ex_pc = None
            self.pipeline.id_ex_opcode = None
            self.pipeline.id_ex_operand = None

    def execute_fetch(self):
        opcode = self.pipeline.id_ex_opcode
        operand = self.pipeline.id_ex_operand

        if opcode == OPCODE_TABLE["loadi"][0]:
            if operand & 0x800000:
                operand -= 0x1000000
            self.acc = operand

        if opcode == OPCODE_TABLE["load"][0]:
            if self.execute_step == 0:
                self.ar = operand
                self.execute_step = 1
                return False

            if self.execute_step == 1:
                self.dr = self.data_memory.load(self.ar)
                self.execute_step = 2
                return False

            if self.execute_step == 2:
                self.acc = self.dr
                self.execute_step = 0

        if opcode == OPCODE_TABLE["load_sp"][0]:
            pass

        if opcode == OPCODE_TABLE["load_addr"][0]:
            self.acc = operand

        if opcode == OPCODE_TABLE["load_ind"][0]:
            if self.execute_step == 0:
                self.ar = operand
                self.execute_step = 1
                return False

            if self.execute_step == 1:
                self.dr = self.data_memory.load(self.ar)
                self.execute_step = 2
                return False

            if self.execute_step == 2:
                self.ar = self.dr
                self.execute_step = 3
                return False

            if self.execute_step == 3:
                self.dr = self.data_memory.load(self.ar)
                self.execute_step = 4
                return False

            if self.execute_step == 4:
                self.acc = self.dr
                self.execute_step = 0

        if opcode == OPCODE_TABLE["addi"][0]:
            pass

        if opcode == OPCODE_TABLE["subi"][0]:
            pass

        if opcode == OPCODE_TABLE["muli"][0]:
            pass

        if opcode == OPCODE_TABLE["divi"][0]:
            pass

        if opcode == OPCODE_TABLE["modi"][0]:
            pass

        if opcode == OPCODE_TABLE["cmpi"][0]:
            pass

        if opcode == OPCODE_TABLE["store"][0]:
            if self.execute_step == 0:
                self.ar = operand
                self.execute_step = 1
                return False

            if self.execute_step == 1:
                self.data_memory.store(self.ar, self.acc)
                self.execute_step = 0

        if opcode == OPCODE_TABLE["store_ind"][0]:
            if self.execute_step == 0:
                self.ar = operand
                self.execute_step = 1
                return False

            if self.execute_step == 1:
                self.dr = self.data_memory.load(self.ar)
                self.execute_step = 2
                return False

            if self.execute_step == 2:
                self.ar = self.dr
                self.execute_step = 3
                return False

            if self.execute_step == 3:
                self.data_memory.store(self.ar, self.acc)
                self.execute_step = 0

        if opcode == OPCODE_TABLE["store_sp"][0]:
            pass

        if opcode == OPCODE_TABLE["jump"][0]:
            self.pc = operand

        return True

    def alu(self, left, right, operation):
        # изменить выставку флагов
        if operation == "add":
            return left + right
        if operation == "sub":
            return left - right
        if operation == "mul":
            return left * right
        if operation == "div":
            return left // right
        return left % right

    def tick(self):
        if self.halted:
            return

        # EX
        if not self.execute_fetch():
            return

        # ID
        self.decode_fetch()

        # IF
        self.instruction_fetch()

        self.pc += 1