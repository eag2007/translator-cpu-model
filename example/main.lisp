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