class Interrupts:
    def __init__(self, input_schedule):
        self.input_schedule = {_tick: _char for _char, _tick in input_schedule}

    def tick(self, tick_count, data_memory):
        if tick_count not in self.input_schedule:
            return None

        char = self.input_schedule.pop(tick_count)
        data_memory.store(0, ord(char))

        return "input"