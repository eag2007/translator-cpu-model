from config import MEMORY_SIZE, OPCODE_TABLE, IMM_BINARY_OPS, MEM_BINARY_OPS
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

        self.interrupts_enable = True
        self.in_interrupts = False
        self.pending_interrupts = False
        self.interrupt_return_pc = None

        self.interrupt_saved_acc = None
        self.interrupt_saved_flags = None

        self.instruction_memory = instruction_memory
        self.data_memory = data_memory

        self.pipeline = pipeline
        self.execute_step = 0

    def branch(self, address):
        self.pc = address
        self.pipeline.if_id_instruction = None

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

    def execute_imm_bin_operation(self, operand, operation):
        if operand & 0x800000:
            operand = -((operand ^ 0xFFFFFF) + 1)

        self.acc = self.alu(self.acc, operand, operation)
        return True

    def execute_bin_operation(self, operand, operation):
        if self.execute_step == 0:
            self.ar = operand
            self.execute_step = 1
            return False

        if self.execute_step == 1:
            self.dr = self.data_memory.load(self.ar)
            self.execute_step = 2
            return False

        if self.execute_step == 2:
            self.acc = self.alu(self.acc, self.dr, operation)
            self.execute_step = 0
            return True
        return False

    def execute_fetch(self):
        opcode = self.pipeline.id_ex_opcode
        operand = self.pipeline.id_ex_operand

        if opcode == OPCODE_TABLE["loadi"][0]:
            if operand & 0x800000:
                operand = -((operand ^ 0xFFFFFF) + 1)
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
            if operand & 0x800000:
                operand = -((operand ^ 0xFFFFFF) + 1)

            if self.execute_step == 0:
                self.ar = self.alu(self.sp, operand, "add", update_flags=False)
                self.execute_step = 1
                return False

            if self.execute_step == 1:
                self.dr = self.data_memory.load(self.ar)
                self.execute_step = 2
                return False

            if self.execute_step == 2:
                self.acc = self.dr
                self.execute_step = 0

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

        if opcode in IMM_BINARY_OPS.keys():
            return self.execute_imm_bin_operation(operand, IMM_BINARY_OPS[opcode])

        if opcode in MEM_BINARY_OPS.keys():
            return self.execute_bin_operation(operand, MEM_BINARY_OPS[opcode])

        if opcode == OPCODE_TABLE["cmpi"][0]:
            if operand & 0x800000:
                operand = -((operand ^ 0xFFFFFF) + 1)

            self.alu(self.acc, operand, "sub")

        if opcode == OPCODE_TABLE["cmp"][0]:
            if self.execute_step == 0:
                self.ar = operand
                self.execute_step = 1
                return False

            if self.execute_step == 1:
                self.dr = self.data_memory.load(self.ar)
                self.execute_step = 2
                return False

            if self.execute_step == 2:
                self.alu(self.acc, self.dr, "sub")
                self.execute_step = 0

        if opcode == OPCODE_TABLE["store"][0]:
            if self.execute_step == 0:
                self.ar = operand
                self.execute_step = 1
                return False

            if self.execute_step == 1:
                self.dr = self.acc
                self.execute_step = 2
                return False

            if self.execute_step == 2:
                self.data_memory.store(self.ar, self.dr)
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
                self.dr = self.acc
                self.execute_step = 4
                return False

            if self.execute_step == 4:
                self.data_memory.store(self.ar, self.dr)
                self.execute_step = 0

        if opcode == OPCODE_TABLE["store_sp"][0]:
            if operand & 0x800000:
                operand = -((operand ^ 0xFFFFFF) + 1)

            if self.execute_step == 0:
                self.ar = self.alu(self.sp, operand, "add", update_flags=False)
                self.execute_step = 1
                return False

            if self.execute_step == 1:
                self.dr = self.acc
                self.execute_step = 2
                return False

            if self.execute_step == 2:
                self.data_memory.store(self.ar, self.dr)
                self.execute_step = 0

        if opcode == OPCODE_TABLE["beq"][0]:
            if self.flags[1]:
                self.branch(operand)

        if opcode == OPCODE_TABLE["bge"][0]:
            if self.flags[0] == self.flags[2]:
                self.branch(operand)

        if opcode == OPCODE_TABLE["call"][0]:
            if self.execute_step == 0:
                self.sp = self.alu(self.sp, 1, "sub", update_flags=False)
                self.execute_step = 1
                return False

            if self.execute_step == 1:
                self.ar = self.sp
                self.execute_step = 2
                return False

            if self.execute_step == 2:
                self.dr = self.alu(self.pipeline.id_ex_pc, 1, "add", update_flags=False)
                self.execute_step = 3
                return False

            if self.execute_step == 3:
                self.data_memory.store(self.ar, self.dr)
                self.execute_step = 4
                return False

            if self.execute_step == 4:
                self.branch(operand)
                self.execute_step = 0

        if opcode == OPCODE_TABLE["ret"][0]:
            if self.execute_step == 0:
                self.ar = self.sp
                self.execute_step = 1
                return False

            if self.execute_step == 1:
                self.dr = self.data_memory.load(self.ar)
                self.execute_step = 2
                return False

            if self.execute_step == 2:
                self.sp = self.alu(self.sp, 1, "add", update_flags=False)
                self.execute_step = 3
                return False

            if self.execute_step == 3:
                self.branch(self.dr)
                self.execute_step = 0

        if opcode == OPCODE_TABLE["iret"][0]:
            self.acc = self.interrupt_saved_acc
            self.flags = self.interrupt_saved_flags.copy()

            self.branch(self.interrupt_return_pc)

            self.interrupt_return_pc = None
            self.in_interrupts = False
            self.interrupts_enable = True

        if opcode == OPCODE_TABLE["halt"][0]:
            self.halted = True

        if opcode == OPCODE_TABLE["push"][0]:
            if self.execute_step == 0:
                self.sp = self.alu(self.sp, 1, "sub", update_flags=False)
                self.execute_step = 1
                return False

            if self.execute_step == 1:
                self.ar = self.sp
                self.execute_step = 2
                return False

            if self.execute_step == 2:
                self.dr = self.acc
                self.execute_step = 3
                return False

            if self.execute_step == 3:
                self.data_memory.store(self.ar, self.dr)
                self.execute_step = 0

        if opcode == OPCODE_TABLE["pop"][0]:
            if self.execute_step == 0:
                self.ar = self.sp
                self.execute_step = 1
                return False

            if self.execute_step == 1:
                self.dr = self.data_memory.load(self.ar)
                self.execute_step = 2
                return False

            if self.execute_step == 2:
                self.acc = self.dr
                self.execute_step = 3
                return False

            if self.execute_step == 3:
                self.sp = self.alu(self.sp, 1, "add", update_flags=False)
                self.execute_step = 0

        if opcode == OPCODE_TABLE["ei"][0]:
            self.interrupts_enable = True

        if opcode == OPCODE_TABLE["di"][0]:
            self.interrupts_enable = False

        if opcode == OPCODE_TABLE["jump"][0]:
            self.branch(operand)

        return True

    def alu(self, left, right, operation, update_flags=True):
        a = left & 0xFFFFFFFF
        b = right & 0xFFFFFFFF

        sign_a = -((a ^ 0xFFFFFFFF) + 1) if a & 0x80000000 else a
        sign_b = -((b ^ 0xFFFFFFFF) + 1) if b & 0x80000000 else b

        carry = 0
        total = 0

        if operation == "add":
            total = sign_a + sign_b
            carry = int(a + b > 0xFFFFFFFF)
        if operation == "sub":
            total = sign_a - sign_b
            carry = int(a < b)
        if operation == "mul":
            total = sign_a * sign_b
            carry = int(a * b > 0xFFFFFFFF)
        if operation == "div":
            total = abs(sign_a) // abs(sign_b)
            if (sign_a < 0) != (sign_b < 0):
                total = -total

        if operation == "mod":
            quotient = abs(sign_a) // abs(sign_b)
            if (sign_a < 0) != (sign_b < 0):
                quotient = -quotient

            total = sign_a - quotient * sign_b

        result = total & 0xFFFFFFFF
        
        if update_flags:
            self.flags[0] = int(bool(result & 0x80000000))
            self.flags[1] = int(result == 0)
            self.flags[2] = int(not -0x80000000 <= total <= 0x7FFFFFFF)
            self.flags[3] = carry

        if result & 0x80000000:
            return -((result ^ 0xFFFFFFFF) + 1)
        return result

    def tick(self):
        if self.halted:
            return

        # EX
        if not self.execute_fetch():
            return

        if self.halted:
            return

        if self.pending_interrupts:
            if self.accept_interrupt():
                return

        # ID
        self.decode_fetch()

        # IF
        self.instruction_fetch()

        self.pc += 1

    def request_interrupt(self):
        if not self.interrupts_enable:
            return

        if self.in_interrupts:
            return

        self.pending_interrupts = True

    def accept_interrupt(self):
        self.interrupt_saved_acc = self.acc
        self.interrupt_saved_flags = self.flags.copy()

        if self.pipeline.if_id_instruction is not None:
            self.interrupt_return_pc = self.pipeline.if_id_pc
        else:
            self.interrupt_return_pc = self.pc

        handler_address = self.data_memory.load(2)

        self.pending_interrupts = False
        self.interrupts_enable = False
        self.in_interrupts = True

        self.pipeline.if_id_instruction = None
        self.pipeline.if_id_pc = None

        self.pipeline.id_ex_pc = None
        self.pipeline.id_ex_opcode = None
        self.pipeline.id_ex_operand = None

        self.execute_step = 0

        self.pc = handler_address

        return True