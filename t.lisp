(set system_in_buffer 0)
(set system_in_ready 0)
(set system_out_buffer 0)

(defunc irq_input () (
    (set system_in_buffer (aget 0 0))
    (set system_in_ready 1)
))

(defunc irq_output () (
    (aset 4 0 system_out_buffer)
))

(set number (input))
(set text (input [3]))