(set x 10)
(set y 20)
(set result 0)

(set name "John")
(set message "hello world")
(set spaces "   text with spaces   ")

(print "Program started")
(print message)

(set result (+ x y))
(print result)

(set result (- y x))
(print result)

(set result (* x y))
(print result)

(set result (/ y x))
(print result)


(if (== x 10)
    (print "x equals 10")
)

(if (!= x y)
    (print "x and y are different")
)

(if (> y x)
    (print "y is greater than x")
)

(if (< x y)
    (print "x is less than y")
)

(if (>= y 20)
    (print "y is at least 20")
)

(if (<= x 10)
    (print "x is at most 10")
)


(if (> x y)
    (print "x greater")
    (elif (== x y)
        (print "x equals y")
    )
    (else
        (print "x less")
    )
)


(set counter 0)

(while (< counter 10)
    (print counter)
    (set counter (+ counter 1))
)


(set i 5)

(repeat 5
    (print i)
    (set i (- i 1))
)


(input user_name)
(print "Hello ")
(print user_name)


(input first)
(input second)

(set sum (+ first second))
(set difference (- first second))

(print "sum = ")
(print sum)

(print "difference = ")
(print difference)


(printchr 65)
(printchr 66)
(printchr 67)
(printchr 10)


(defunc add (a b) (
    (+ a b)
))


(defunc subtract (a b) (
    (- a b)
))


(defunc square (x) (
    (* x x)
))


(defunc max (a b) (
    (if (> a b)
        (a)
        (b)
    )
))


(set add_result (funcall add (10 20)))
(set sub_result (funcall subtract (100 30)))
(set square_result (funcall square (8)))

(print add_result)
(print sub_result)
(print square_result)


(defunc countdown (n) (
    (print n)

    (if (== n 0)
        (0)
        (funcall countdown ((- n 1)))
    )
))

(funcall countdown (10))


(defunc factorial (n) (
    (if (== n 0)
        (1)
        (* n (funcall factorial ((- n 1))))
    )
))

(set factorial_result (funcall factorial (5)))

(print "factorial = ")
(print factorial_result)


(defunc fibonacci (n) (
    (if (<= n 1)
        (n)
        (+
            (funcall fibonacci ((- n 1)))
            (funcall fibonacci ((- n 2)))
        )
    )
))

(set fib_result (funcall fibonacci (8)))

(print "fibonacci = ")
(print fib_result)


(set long_identifier_name_123 100)
(set another_variable_999 200)

(set calculated_value
    (+
        (* long_identifier_name_123 2)
        (/ another_variable_999 4)
    )
)

(print calculated_value)


(set text1 "hello")
(set text2 "hello world")
(set text3 "  hello world  ")
(set text4 "123 456 789")
(set text5 "a b c d e")
(set empty_string "")

(print text1)
(print text2)
(print text3)
(print text4)
(print text5)
(print empty_string)