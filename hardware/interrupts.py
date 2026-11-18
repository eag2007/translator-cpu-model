class Interrupts:
    def __init__(self, input_schedule):
        self.input_schedule = {_tick: _char for _char, _tick in input_schedule}

    def tick_input(self, tick_count, data_memory):
        if tick_count not in self.input_schedule:
            return 0

        value = self.input_schedule.pop(tick_count)

        if isinstance(value, str):
            value = ord(value)

        data_memory.store(0, value)

        return 1

    def tick_output(self, tick_count, data_memory):
        if data_memory.load(7) == 1:
            return 1

        return 0