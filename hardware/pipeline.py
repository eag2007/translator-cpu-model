class Pipeline:
    def __init__(self):
        # if/id
        self.if_id_instruction = None
        self.if_id_pc = None

        # id/ex
        self.id_ex_pc = None
        self.id_ex_operand = None
        self.id_ex_opcode = None