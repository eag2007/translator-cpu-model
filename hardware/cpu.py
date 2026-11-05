from config import MEMORY_SIZE


class CPU:
    def __init__(self):
        self.acc = 0
        self.ip = 0
        self.sp = MEMORY_SIZE