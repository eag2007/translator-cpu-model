(_di)
(set system_in_buffer 0)
(set system_in_ready 0)
(set system_out_buffer 0)
(set system_out_ready 0)
(_ei)

(defunc irq_input () (
    (_di)
    (set system_in_buffer (aget 0 0))
    (set system_in_ready 1)
))

(defunc irq_output () (
    (_di)
    (aset 1 0 system_out_buffer)
    (set system_out_ready 0)
))