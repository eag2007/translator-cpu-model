(defunc factorial (n) (
    (if (<= n 1) (
        (set result 1)
    )
    (else (
        (set result (* n (funcall factorial ((- n 1)))))
    )))

    result
))

(set number (input))
(set answer (funcall factorial (number)))

(funcall print_smart (answer))