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



(defunc is_digit (c) (
    (set result 0)

    (if (>= c 48) (
        (if (<= c 57) (
            (set result 1)
        ))
    ))

    result
))

(defunc number_length (n) (
    (set length 1)

    (if (< n 0) (
        (set length 2)
    ))

    (while (>= n 10) (
        (set n (/ n 10))
        (set length (+ length 1))
    ))

    (while (<= n -10) (
        (set n (/ n 10))
        (set length (+ length 1))
    ))

    length
))

(set fmt (input [32]))
(set i 0)

(while (!= (getchar fmt i) 0) (
    (set c (getchar fmt i))

    (if (== c 37) (
        (set j (+ i 1))
        (set left 0)
        (set width 0)

        (if (== (getchar fmt j) 45) (
            (set left 1)
            (set j (+ j 1))
        ))

        (while (== (funcall is_digit ((getchar fmt j))) 1) (
            (set width (+ (* width 10) (- (getchar fmt j) 48)))
            (set j (+ j 1))
        ))

        (if (== (getchar fmt j) 100) (
            (set number (input))
            (set length (funcall number_length (number)))
            (set spaces (- width length))

            (if (== left 0) (
                (repeat spaces (
                    (print_char 32)
                ))
            ))

            (print_number number)

            (if (== left 1) (
                (repeat spaces (
                    (print_char 32)
                ))
            ))

            (set i (+ j 1))
        )
        (else (
            (print_char c)
            (set i (+ i 1))
        )))
    )
    (else (
        (print_char c)
        (set i (+ i 1))
    )))
))