(set x (set y 13))
(funcall print_smart (x))

(set x (set y 13))

(set sum (+ (set a 7) (* 2 (set b 3))))

(set maximum
    (if (> x a) (
        x
    )
    (else (
        a
    )))
)

(defunc twice_plus_one (n) (
    (set doubled (* n 2))
    (+ doubled 1)
))

(set nested
    (+ (funcall twice_plus_one (a))
       (if (== x y) (
           100
       )
       (else (
           0
       )))
    )
)

(print_string "x, y: ")
(funcall print_smart (x))
(funcall print_smart (y))

(print_string "a, b, sum: ")
(funcall print_smart (a))
(funcall print_smart (b))
(funcall print_smart (sum))

(print_string "maximum: ")
(funcall print_smart (maximum))

(print_string "nested: ")
(funcall print_smart (nested))