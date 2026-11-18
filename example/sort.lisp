(set numbers (array 64))
(set count 0)
(set number (input))

# Считываем числа до нулевого терминатора.
(while (!= number 0) (
    (if (< count 64) (
        (aset numbers count number)
        (set count (+ count 1))
    ))
    (set number (input))
))

# Сортировка пузырьком.
(set i 0)
(while (< i count) (
    (set j 0)

    (while (< (+ j 1) (- count i)) (
        (set left (aget numbers j))
        (set right (aget numbers (+ j 1)))

        (if (> left right) (
            (aset numbers j right)
            (aset numbers (+ j 1) left)
        ))

        (set j (+ j 1))
    ))

    (set i (+ i 1))
))

# print_smart системная функция в compiler/system.lisp.
(set i 0)
(while (< i count) (
    (funcall print_smart ((aget numbers i)))
    (set i (+ i 1))
))