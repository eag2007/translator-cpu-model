i                        .word 0
left                     .word 0
$tmp$                    .word 0
fmt                      .word 0
c                        .word 0
width                    .word 0
$tmp_address$            .word 0
length                   .word 0
j                        .word 0
number                   .word 0
spaces                   .word 0
input_str_24:
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
_start:
    JUMP     end_0
$func_is_digit:
    LOADI    0
    PUSH
    LOADI    0
    STORE_SP 1
    LOAD_SP  3
    PUSH
    LOADI    48
    STORE    $tmp$
    POP
    CMP      $tmp$
    BGE      lefteq_true_3
    LOADI    0
    JUMP     end_4
lefteq_true_3:
    LOADI    1
end_4:
    CMPI     0
    BEQ      if_false_1
    LOAD_SP  3
    PUSH
    LOADI    57
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      lefteq_true_7
    BGE      lefteq_false_8
lefteq_true_7:
    LOADI    1
    JUMP     end_9
lefteq_false_8:
    LOADI    0
end_9:
    CMPI     0
    BEQ      if_false_5
    LOADI    1
    STORE_SP 1
    JUMP     end_6
if_false_5:
end_6:
    JUMP     end_2
if_false_1:
end_2:
    LOAD_SP  1
    STORE    $tmp$
    POP
    LOAD     $tmp$
    RET
end_0:
    JUMP     end_10
$func_number_length:
    LOADI    0
    LOADI    1
    STORE    length
    LOAD_SP  2
    PUSH
    LOADI    0
    STORE    $tmp$
    POP
    CMP      $tmp$
    BGE      right_false_13
    LOADI    1
    JUMP     end_14
right_false_13:
    LOADI    0
end_14:
    CMPI     0
    BEQ      if_false_11
    LOADI    2
    STORE    length
    JUMP     end_12
if_false_11:
end_12:
loop_15:
    LOAD_SP  2
    PUSH
    LOADI    10
    STORE    $tmp$
    POP
    CMP      $tmp$
    BGE      lefteq_true_17
    LOADI    0
    JUMP     end_18
lefteq_true_17:
    LOADI    1
end_18:
    CMPI     0
    BEQ      end_16
    LOAD_SP  2
    PUSH
    LOADI    10
    STORE    $tmp$
    POP
    DIV      $tmp$
    STORE_SP 2
    LOAD     length
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    length
    JUMP     loop_15
end_16:
loop_19:
    LOAD_SP  2
    PUSH
    LOADI    -10
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      lefteq_true_21
    BGE      lefteq_false_22
lefteq_true_21:
    LOADI    1
    JUMP     end_23
lefteq_false_22:
    LOADI    0
end_23:
    CMPI     0
    BEQ      end_20
    LOAD_SP  2
    PUSH
    LOADI    10
    STORE    $tmp$
    POP
    DIV      $tmp$
    STORE_SP 2
    LOAD     length
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    length
    JUMP     loop_19
end_20:
    LOAD     length
    RET
end_10:
    LOAD_ADDR input_str_24
    STORE    $tmp_address$
    LOADI    32
    STORE    $tmp$
input_loop_25:
    LOAD     $tmp$
    CMPI     0
    BEQ      input_loop_25_end
in_nbr_wait_26:
    LOAD     system_in_ready
    CMPI     0
    BEQ      in_nbr_wait_26
    DI
    LOAD     system_in_buffer
    PUSH
    LOADI    0
    STORE    system_in_ready
    POP
    EI
    STORE_IND $tmp_address$
    LOAD     $tmp_address$
    ADDI     1
    STORE    $tmp_address$
    LOAD     $tmp$
    SUBI     1
    STORE    $tmp$
    JUMP     input_loop_25
input_loop_25_end:
    LOAD_ADDR input_str_24
    STORE    fmt
    LOADI    0
    STORE    i
loop_27:
    LOAD     fmt
    PUSH
    LOAD     i
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    $tmp$
    LOAD_IND $tmp$
    PUSH
    LOADI    0
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      not_equal_false_30
    JUMP     not_equal_true_29
not_equal_false_30:
    LOADI    0
    JUMP     end_31
not_equal_true_29:
    LOADI    1
end_31:
    CMPI     0
    BEQ      end_28
    LOAD     fmt
    PUSH
    LOAD     i
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    $tmp$
    LOAD_IND $tmp$
    STORE    c
    LOAD     c
    PUSH
    LOADI    37
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      equal_true_34
    JUMP     equal_false_35
equal_true_34:
    LOADI    1
    JUMP     end_36
equal_false_35:
    LOADI    0
    JUMP     end_36
end_36:
    CMPI     0
    BEQ      if_false_32
    LOAD     i
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    j
    LOADI    0
    STORE    left
    LOADI    0
    STORE    width
    LOAD     fmt
    PUSH
    LOAD     j
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    $tmp$
    LOAD_IND $tmp$
    PUSH
    LOADI    45
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      equal_true_39
    JUMP     equal_false_40
equal_true_39:
    LOADI    1
    JUMP     end_41
equal_false_40:
    LOADI    0
    JUMP     end_41
end_41:
    CMPI     0
    BEQ      if_false_37
    LOADI    1
    STORE    left
    LOAD     j
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    j
    JUMP     end_38
if_false_37:
end_38:
loop_42:
    LOAD     fmt
    PUSH
    LOAD     j
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    $tmp$
    LOAD_IND $tmp$
    PUSH
    CALL     $func_is_digit
    STORE    $tmp$
    POP
    LOAD     $tmp$
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      equal_true_44
    JUMP     equal_false_45
equal_true_44:
    LOADI    1
    JUMP     end_46
equal_false_45:
    LOADI    0
    JUMP     end_46
end_46:
    CMPI     0
    BEQ      end_43
    LOAD     width
    PUSH
    LOADI    10
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
    LOAD_IND $tmp$
    PUSH
    LOADI    48
    STORE    $tmp$
    POP
    SUB      $tmp$
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    width
    LOAD     j
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    j
    JUMP     loop_42
end_43:
    LOAD     fmt
    PUSH
    LOAD     j
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    $tmp$
    LOAD_IND $tmp$
    PUSH
    LOADI    100
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      equal_true_49
    JUMP     equal_false_50
equal_true_49:
    LOADI    1
    JUMP     end_51
equal_false_50:
    LOADI    0
    JUMP     end_51
end_51:
    CMPI     0
    BEQ      if_false_47
in_nbr_wait_52:
    LOAD     system_in_ready
    CMPI     0
    BEQ      in_nbr_wait_52
    DI
    LOAD     system_in_buffer
    PUSH
    LOADI    0
    STORE    system_in_ready
    POP
    EI
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
    LOADI    0
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      equal_true_55
    JUMP     equal_false_56
equal_true_55:
    LOADI    1
    JUMP     end_57
equal_false_56:
    LOADI    0
    JUMP     end_57
end_57:
    CMPI     0
    BEQ      if_false_53
    LOAD     spaces
repeat_check_58:
    CMPI     0
    BEQ      end_60
    BGE      repeat_loop_59
    JUMP     end_60
repeat_loop_59:
    PUSH
    LOADI    32
    PUSH
wait_61:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_61_end
    JUMP     wait_61
wait_61_end:
    DI
    POP
    STORE    system_out_buffer
    LOADI    1
    STORE    system_out_ready
    EI
    POP
    SUBI     1
    JUMP     repeat_check_58
end_60:
    JUMP     end_54
if_false_53:
end_54:
    LOAD     number
    PUSH
wait_62:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_62_end
    JUMP     wait_62
wait_62_end:
    DI
    POP
    STORE    system_out_buffer
    LOADI    1
    STORE    system_out_ready
    EI
    LOAD     left
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      equal_true_65
    JUMP     equal_false_66
equal_true_65:
    LOADI    1
    JUMP     end_67
equal_false_66:
    LOADI    0
    JUMP     end_67
end_67:
    CMPI     0
    BEQ      if_false_63
    LOAD     spaces
repeat_check_68:
    CMPI     0
    BEQ      end_70
    BGE      repeat_loop_69
    JUMP     end_70
repeat_loop_69:
    PUSH
    LOADI    32
    PUSH
wait_71:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_71_end
    JUMP     wait_71
wait_71_end:
    DI
    POP
    STORE    system_out_buffer
    LOADI    1
    STORE    system_out_ready
    EI
    POP
    SUBI     1
    JUMP     repeat_check_68
end_70:
    JUMP     end_64
if_false_63:
end_64:
    LOAD     j
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    i
    JUMP     end_48
if_false_47:
    LOAD     c
    PUSH
wait_72:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_72_end
    JUMP     wait_72
wait_72_end:
    DI
    POP
    STORE    system_out_buffer
    LOADI    1
    STORE    system_out_ready
    EI
    LOAD     i
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    i
end_48:
    JUMP     end_33
if_false_32:
    LOAD     c
    PUSH
wait_73:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_73_end
    JUMP     wait_73
wait_73_end:
    DI
    POP
    STORE    system_out_buffer
    LOADI    1
    STORE    system_out_ready
    EI
    LOAD     i
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    i
end_33:
    JUMP     loop_27
end_28:
    HALT
