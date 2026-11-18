(set n (input))
(set result 1)

(if (< n 1) (
    (set result -1)
)
(else (
    (if (== n 1) (
        (set result 0)
    )
    (else (
        (set i 2)

        (while (<= i (/ n i)) (
            (if (== (% n i) 0) (
                (set result 0)
                (set i n)
            )
            (else (
                (set i (+ i 1))
            )))
        ))
    )))
)))

(funcall print_smart (result))