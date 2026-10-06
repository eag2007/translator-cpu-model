(set x 2)
(set x 3)
(set y x)

(set x (set y 2))
(+ (set a 3) (set b 4))

(if (set flag 1)
    (
        (set x 2)
    )
    (else
        (
            (set x 3)
            (set y 4)
        )
    )
)

(if 1
    (
        (set a 2)
    )
)

(while (set condition 0)
    (
        (set b 3)
    )
)

(repeat (set count 2)
    (
        (set c 4)
    )
)

(defunc f (param)
    (
        (set local 10)
        (if 1
            (
                (set nested 20)
            )
        )
        param
    )
)

(funcall f ((set argument 5)))

(print (set text "hello"))
(printchr (set symbol 65))
(print unknown)