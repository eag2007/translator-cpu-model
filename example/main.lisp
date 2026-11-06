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



(set x (+ 2 3))

(input)

(print_string "hello")

(print_number 65)

(if (> x 10)
    (
        (print_string "big")
    )
    (else
        (
            (print_string "small")
        )
    )
)

(while (> x 0)
    (
        (print_number x)
        (set x (- x 1))
    )
)

(repeat 3
    (
        (print_string "hello")
    )
)

(defunc add (a b)
    (
        (+ a b)
    )
)

(funcall add (10 20))