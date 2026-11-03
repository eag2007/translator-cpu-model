i                .word ?
j                .word ?
left             .word ?
c                .word ?
fmt              .word ?
width            .word ?
length           .word ?
number           .word ?
spaces           .word ?
$tmp_address$    .word ?
$tmp$            .word ?
_start:
    JUMP     end_0
$func_is_digit:
    LOAD     #0
    PUSH
    LOAD     #0
    STORE    [4]
    LOAD     [12]
    PUSH
    LOAD     #48
    STORE    $tmp$
    POP
    CMP      $tmp$
    BGE      lefteq_true_3
    LOAD     #0
    JUMP     end_4
lefteq_true_3:
    LOAD     #1
end_4:
    CMP      #0
    BEQ      if_false_1
    LOAD     [12]
    PUSH
    LOAD     #57
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      lefteq_true_7
    BGE      lefteq_false_8
lefteq_true_7:
    LOAD     #1
    JUMP     end_9
lefteq_false_8:
    LOAD     #0
end_9:
    CMP      #0
    BEQ      if_false_5
    LOAD     #1
    STORE    [4]
    JUMP     end_6
if_false_5:
end_6:
    JUMP     end_2
if_false_1:
end_2:
    LOAD     [4]
    STORE    $tmp$
    POP
    LOAD     $tmp$
    RET
end_0:
    JUMP     end_10
$func_number_length:
    LOAD     #0
    PUSH
    LOAD     #1
    STORE    [4]
    LOAD     [12]
    PUSH
    LOAD     #0
    STORE    $tmp$
    POP
    CMP      $tmp$
    BGE      right_false_13
    LOAD     #1
    JUMP     end_14
right_false_13:
    LOAD     #0
end_14:
    CMP      #0
    BEQ      if_false_11
    LOAD     #2
    STORE    [4]
    JUMP     end_12
if_false_11:
end_12:
loop_15:
    LOAD     [12]
    PUSH
    LOAD     #10
    STORE    $tmp$
    POP
    CMP      $tmp$
    BGE      lefteq_true_17
    LOAD     #0
    JUMP     end_18
lefteq_true_17:
    LOAD     #1
end_18:
    CMP      #0
    BEQ      end_16
    LOAD     [12]
    PUSH
    LOAD     #10
    STORE    $tmp$
    POP
    DIV      $tmp$
    STORE    [12]
    LOAD     [4]
    PUSH
    LOAD     #1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    [4]
    JUMP     loop_15
end_16:
loop_19:
    LOAD     [12]
    PUSH
    LOAD     #-10
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      lefteq_true_21
    BGE      lefteq_false_22
lefteq_true_21:
    LOAD     #1
    JUMP     end_23
lefteq_false_22:
    LOAD     #0
end_23:
    CMP      #0
    BEQ      end_20
    LOAD     [12]
    PUSH
    LOAD     #10
    STORE    $tmp$
    POP
    DIV      $tmp$
    STORE    [12]
    LOAD     [4]
    PUSH
    LOAD     #1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    [4]
    JUMP     loop_19
end_20:
    LOAD     [4]
    STORE    $tmp$
    POP
    LOAD     $tmp$
    RET
end_10:
    STORE    fmt
    LOAD     #0
    STORE    i
loop_24:
    LOAD     fmt
    PUSH
    LOAD     i
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    $tmp$
    LOAD.b   @$tmp$
    PUSH
    LOAD     #0
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      not_equal_false_27
    JUMP     not_equal_true_26
not_equal_false_27:
    LOAD     #0
    JUMP     end_28
not_equal_true_26:
    LOAD     #1
end_28:
    CMP      #0
    BEQ      end_25
    LOAD     fmt
    PUSH
    LOAD     i
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    $tmp$
    LOAD.b   @$tmp$
    STORE    c
    LOAD     c
    PUSH
    LOAD     #37
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      equal_true_31
    JUMP     equal_false_32
equal_true_31:
    LOAD     #1
    JUMP     end_33
equal_false_32:
    LOAD     #0
    JUMP     end_33
end_33:
    CMP      #0
    BEQ      if_false_29
    LOAD     i
    PUSH
    LOAD     #1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    j
    LOAD     #0
    STORE    left
    LOAD     #0
    STORE    width
    LOAD     fmt
    PUSH
    LOAD     j
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    $tmp$
    LOAD.b   @$tmp$
    PUSH
    LOAD     #45
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      equal_true_36
    JUMP     equal_false_37
equal_true_36:
    LOAD     #1
    JUMP     end_38
equal_false_37:
    LOAD     #0
    JUMP     end_38
end_38:
    CMP      #0
    BEQ      if_false_34
    LOAD     #1
    STORE    left
    LOAD     j
    PUSH
    LOAD     #1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    j
    JUMP     end_35
if_false_34:
end_35:
loop_39:
    LOAD     fmt
    PUSH
    LOAD     j
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    $tmp$
    LOAD.b   @$tmp$
    PUSH
    CALL     $func_is_digit
    STORE    $tmp$
    POP
    LOAD     $tmp$
    PUSH
    LOAD     #1
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      equal_true_41
    JUMP     equal_false_42
equal_true_41:
    LOAD     #1
    JUMP     end_43
equal_false_42:
    LOAD     #0
    JUMP     end_43
end_43:
    CMP      #0
    BEQ      end_40
    LOAD     width
    PUSH
    LOAD     #10
    STORE    $tmp$
    POP
    MUL      $tmp$
    PUSH
    LOAD     fmt
    PUSH
    LOAD     j
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    $tmp$
    LOAD.b   @$tmp$
    PUSH
    LOAD     #48
    STORE    $tmp$
    POP
    SUB      $tmp$
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    width
    LOAD     j
    PUSH
    LOAD     #1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    j
    JUMP     loop_39
end_40:
    LOAD     fmt
    PUSH
    LOAD     j
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    $tmp$
    LOAD.b   @$tmp$
    PUSH
    LOAD     #100
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      equal_true_46
    JUMP     equal_false_47
equal_true_46:
    LOAD     #1
    JUMP     end_48
equal_false_47:
    LOAD     #0
    JUMP     end_48
end_48:
    CMP      #0
    BEQ      if_false_44
    STORE    number
    LOAD     number
    PUSH
    CALL     $func_number_length
    STORE    $tmp$
    POP
    LOAD     $tmp$
    STORE    length
    LOAD     width
    PUSH
    LOAD     length
    STORE    $tmp$
    POP
    SUB      $tmp$
    STORE    spaces
    LOAD     left
    PUSH
    LOAD     #0
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      equal_true_51
    JUMP     equal_false_52
equal_true_51:
    LOAD     #1
    JUMP     end_53
equal_false_52:
    LOAD     #0
    JUMP     end_53
end_53:
    CMP      #0
    BEQ      if_false_49
    LOAD     spaces
repeat_check_54:
    CMP      #0
    BEQ      end_56
    BGE      repeat_loop_55
    JUMP     end_56
repeat_loop_55:
    PUSH
    POP
    SUB      #1
    JUMP     repeat_check_54
end_56:
    JUMP     end_50
if_false_49:
end_50:
    LOAD     left
    PUSH
    LOAD     #1
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      equal_true_59
    JUMP     equal_false_60
equal_true_59:
    LOAD     #1
    JUMP     end_61
equal_false_60:
    LOAD     #0
    JUMP     end_61
end_61:
    CMP      #0
    BEQ      if_false_57
    LOAD     spaces
repeat_check_62:
    CMP      #0
    BEQ      end_64
    BGE      repeat_loop_63
    JUMP     end_64
repeat_loop_63:
    PUSH
    POP
    SUB      #1
    JUMP     repeat_check_62
end_64:
    JUMP     end_58
if_false_57:
end_58:
    LOAD     j
    PUSH
    LOAD     #1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    i
    JUMP     end_45
if_false_44:
    LOAD     i
    PUSH
    LOAD     #1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    i
end_45:
    JUMP     end_30
if_false_29:
    LOAD     i
    PUSH
    LOAD     #1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    i
end_30:
    JUMP     loop_24
end_25:
    HALT
