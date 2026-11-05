from config import MEMORY_SIZE


class Memory:
    def __init__(self):
        self.memory = [0 for _ in range(MEMORY_SIZE)]

    def load(self, index):
        if 0 <= index < MEMORY_SIZE:
            return self.memory[index]
        return None

    def store(self, index, value):
        if 0 <= index < MEMORY_SIZE:
            self.memory[index] = value
            return True
        return False


class DataMemory(Memory):
    pass


class InstructionMemory(Memory):
    pass
