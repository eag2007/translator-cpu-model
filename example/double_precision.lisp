# Первое число:
#   знаковый:                              5 000 000 000
#   беззнаковый:                           5 000 000 000
#   hex (старшая и младшая часть):         0x00000001_2A05F200
#   ввод (старшая и младшая часть):        1, 705032704

# Второе число:
#   знаковый:                              7 000 000 000
#   беззнаковый:                           7 000 000 000
#   hex  (старшая и младшая часть):        0x00000001_A13B8600
#   ввод (старшая и младшая часть):        1, -1589934592

# Результат:
#   знаковый:                              12 000 000 000
#   беззнаковый:                           12 000 000 000
#   hex   (старшая и младшая часть):       0x00000002_CB417800
#   вывод (старшая и младшая часть):       2 -884901888



(set a_high (input))
(set a_low (input))

(set b_high (input))
(set b_low (input))

(set result_low (+ a_low b_low))
(set carry 0)

(if (< a_low 0) (
    (if (< b_low 0) (
        (set carry 1)
    )
    (else (
        (if (>= result_low 0) (
            (set carry 1)
        ))
    )))
)
(else (
    (if (< b_low 0) (
        (if (>= result_low 0) (
            (set carry 1)
        ))
    ))
)))

(set result_high (+ (+ a_high b_high) carry))

(funcall print_smart (result_high))
(funcall print_smart (result_low))