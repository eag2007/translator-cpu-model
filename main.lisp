(set x (+ 2 3))

(input)

(print "hello")

(printchr 65)

(if (> x 10)
    (
        (print "big")
    )
    (else
        (
            (print "small")
        )
    )
)

(while (> x 0)
    (
        (print x)
        (set x (- x 1))
    )
)

(repeat 3
    (
        (print "hello")
    )
)

(defunc add (a b)
    (
        (+ a b)
    )
)

(funcall add (10 20))