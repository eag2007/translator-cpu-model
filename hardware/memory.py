from config import MEMORY_SIZE, WORD_SIZE


class Memory:
    def __init__(self):
        self.memory = [0 for _ in range(MEMORY_SIZE)]

    def load(self, index):
        if 0 <= index <= MEMORY_SIZE - WORD_SIZE:
            return (
                (self.memory[index] << 24)
                | (self.memory[index + 1] << 16)
                | (self.memory[index + 2] << 8)
                | self.memory[index + 3]
            )
        return None

    def store(self, index, value):
        if 0 <= index <= MEMORY_SIZE - WORD_SIZE:
            self.memory[index] = (value >> 24) & 0xFF
            self.memory[index + 1] = (value >> 16) & 0xFF
            self.memory[index + 2] = (value >> 8) & 0xFF
            self.memory[index + 3] = value & 0xFF
            return True
        return False


class DataMemory(Memory):
    def load(self, index):
        value = super().load(index)

        if value is not None and value & (1 << 31):
            return value - (1 << 32)

        return value


class InstructionMemory(Memory):
    pass
