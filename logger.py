from config import OPCODE_TABLE


class Logger:
    def __init__(self, path):
        self.opcodes = {
            value[0]: name.upper()
            for name, value in OPCODE_TABLE.items()
        }
        self.path = path

    def instruction_name(self, opcode, operand):
        if opcode is None:
            return "EMPTY"

        name = self.opcodes.get(opcode)

        if name in ("PUSH", "POP", "RET", "IRET", "HALT", "EI", "DI"):
            return name

        return f"{name} {operand}"

    def log(self, cpu, tick_count, ex_state):
        with open(self.path, "a") as f:
            p = cpu.pipeline

            if_instruction = (
                f"0x{p.if_id_instruction:08X}"
                if p.if_id_instruction is not None
                else "EMPTY"
            )

            id_instruction = self.instruction_name(
                p.id_ex_opcode,
                p.id_ex_operand,
            )

            ex_pc, ex_opcode, ex_operand, ex_step = ex_state
            ex_instruction = self.instruction_name(
                ex_opcode,
                ex_operand,
            )

            print("=" * 60, file=f)
            print(f"TICK {tick_count}", file=f)
            if cpu.in_interrupts:
                print(" --- INTERRUPT HANDLER ---", file=f)
                print(
                    f"IRQ:\tIN_HANDLER={int(cpu.in_interrupts)}\t"
                    f"ENABLED={int(cpu.interrupts_enable)}\t"
                    f"PENDING={int(cpu.pending_interrupts)}\t"
                    f"RETURN_PC={int(cpu.interrupt_return_pc)}",
                    file=f,
                )
            print(file=f)

            print(
                f"IF:\tPC={p.if_id_pc}\t"
                f"INSTR={if_instruction}", file=f
            )

            print(
                f"ID:\tPC={p.id_ex_pc}\t"
                f"INSTR={id_instruction}", file=f
            )

            print(
                f"EX:\tPC={ex_pc}\t"
                f"INSTR={ex_instruction}\t"
                f"STEP={ex_step}", file=f
            )

            print(file=f)

            print(
                f"REG:\t\tACC={cpu.acc}\t"
                f"DR={cpu.dr}\t"
                f"AR={cpu.ar}\t"
                f"SP={cpu.sp}\t"
                f"PC={cpu.pc}\t"
                f"IR={cpu.ir:08X}", file=f
            )

            n, z, v, c = cpu.flags

            print(
                f"FLAGS:\t\tN={n}\t"
                f"Z={z}\t"
                f"V={v}\t"
                f"C={c}", file=f
            )

            if_id = (
                "VALID"
                if p.if_id_instruction is not None
                else "EMPTY"
            )

            id_ex = (
                "VALID"
                if p.id_ex_opcode is not None
                else "EMPTY"
            )

            print(
                f"PIPELINE:\tIF/ID={if_id}\t"
                f"ID/EX={id_ex}", file=f
            )

