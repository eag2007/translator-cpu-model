$tmp$       .word    ?
x           .word    ?
    LOAD    #2
    PUSH
    LOAD    #3
    STORE   $tmp$
    POP
    ADD     $tmp$
    STORE   x
    LOAD    x
    PUSH
    LOAD    #10
    STORE   $tmp$
    POP
    CMP     $tmp$
    BEQ     left_false_3
    BGE     left_true_2
left_false_3:
    LOAD    #0
    JUMP    end_4
left_true_2:
    LOAD    #1
end_4:
    CMP     #0
    BEQ     if_false_0
    JUMP    end_1
if_false_0:
end_1:
loop_5:
    LOAD    x
    PUSH
    LOAD    #0
    STORE   $tmp$
    POP
    CMP     $tmp$
    BEQ     left_false_8
    BGE     left_true_7
left_false_8:
    LOAD    #0
    JUMP    end_9
left_true_7:
    LOAD    #1
end_9:
    CMP     #0
    BEQ     end_6
    LOAD    x
    PUSH
    LOAD    #1
    STORE   $tmp$
    POP
    SUB     $tmp$
    STORE   x
    JUMP    loop_5
end_6:
    LOAD    #3
repeat_check_10:
    CMP     #0
    BEQ     end_12
    BGE     repeat_loop_11
    JUMP    end_12
repeat_loop_11:
    PUSH
    POP
    SUB     #1
    JUMP    repeat_check_10
end_12:
    JUMP    end_13
$func_add:
    LOAD    #0
    LOAD    [12]
    PUSH
    LOAD    [12]
    STORE   $tmp$
    POP
    ADD     $tmp$
    RET
end_13:
    LOAD    #10
    PUSH
    LOAD    #20
    PUSH
    CALL    $func_add
    STORE   $tmp$
    POP
    POP
    LOAD    $tmp$
