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

(defunc print_smart (n) (
    (if (< n 0) (
        (print_char 45)
        (set n (- 0 n))
    ))

    (set divider 1)
    (while (>= (/ n divider) 10) (
        (set divider (* divider 10))
    ))

    (while (> divider 0) (
        (print_char (+ (/ n divider) 48))
        (set n (% n divider))
        (set divider (/ divider 10))

        (if (> divider 0) (
        ))
    ))

    (print_char 10)
))