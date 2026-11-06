left                     .word 0
system_out_ready         .word 0
$tmp_address$            .word 0
length                   .word 0
width                    .word 0
j                        .word 0
$tmp$                    .word 0
system_out_buffer        .word 0
number                   .word 0
spaces                   .word 0
system_in_buffer         .word 0
system_in_ready          .word 0
i                        .word 0
c                        .word 0
fmt                      .word 0
input_str_26:
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
    DI
    LOADI    0
    STORE    system_in_buffer
    LOADI    0
    STORE    system_in_ready
    LOADI    0
    STORE    system_out_buffer
    LOADI    0
    STORE    system_out_ready
    EI
    JUMP     end_0
$func_irq_input:
    LOAD     $tmp$
    PUSH
    LOAD     $tmp_address$
    PUSH
    LOADI    0
    DI
    LOADI    0
    PUSH
    LOADI    0
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    $tmp$
    LOAD_IND $tmp$
    STORE    system_in_buffer
    LOADI    1
    STORE    system_in_ready
    POP
    STORE    $tmp_address$
    POP
    STORE    $tmp$
    IRET
end_0:
    JUMP     end_1
$func_irq_output:
    LOAD     $tmp$
    PUSH
    LOAD     $tmp_address$
    PUSH
    LOADI    0
    DI
    LOADI    1
    PUSH
    LOADI    0
    STORE    $tmp$
    POP
    ADD      $tmp$
    PUSH
    LOAD     system_out_buffer
    STORE    $tmp$
    POP
    STORE    $tmp_address$
    LOAD     $tmp$
    STORE_IND $tmp_address$
    LOADI    0
    STORE    system_out_ready
    POP
    STORE    $tmp_address$
    POP
    STORE    $tmp$
    IRET
end_1:
    JUMP     end_2
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
    BGE      lefteq_true_5
    LOADI    0
    JUMP     end_6
lefteq_true_5:
    LOADI    1
end_6:
    CMPI     0
    BEQ      if_false_3
    LOAD_SP  3
    PUSH
    LOADI    57
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      lefteq_true_9
    BGE      lefteq_false_10
lefteq_true_9:
    LOADI    1
    JUMP     end_11
lefteq_false_10:
    LOADI    0
end_11:
    CMPI     0
    BEQ      if_false_7
    LOADI    1
    STORE_SP 1
    JUMP     end_8
if_false_7:
end_8:
    JUMP     end_4
if_false_3:
end_4:
    LOAD_SP  1
    STORE    $tmp$
    POP
    LOAD     $tmp$
    RET
end_2:
    JUMP     end_12
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
    BGE      right_false_15
    LOADI    1
    JUMP     end_16
right_false_15:
    LOADI    0
end_16:
    CMPI     0
    BEQ      if_false_13
    LOADI    2
    STORE    length
    JUMP     end_14
if_false_13:
end_14:
loop_17:
    LOAD_SP  2
    PUSH
    LOADI    10
    STORE    $tmp$
    POP
    CMP      $tmp$
    BGE      lefteq_true_19
    LOADI    0
    JUMP     end_20
lefteq_true_19:
    LOADI    1
end_20:
    CMPI     0
    BEQ      end_18
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
    JUMP     loop_17
end_18:
loop_21:
    LOAD_SP  2
    PUSH
    LOADI    -10
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      lefteq_true_23
    BGE      lefteq_false_24
lefteq_true_23:
    LOADI    1
    JUMP     end_25
lefteq_false_24:
    LOADI    0
end_25:
    CMPI     0
    BEQ      end_22
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
    JUMP     loop_21
end_22:
    LOAD     length
    RET
end_12:
    LOAD_ADDR input_str_26
    STORE    $tmp_address$
    LOADI    32
    STORE    $tmp$
input_loop_27:
    LOAD     $tmp$
    CMPI     0
    BEQ      input_loop_27_end
in_nbr_wait_28:
    LOAD     system_in_ready
    CMPI     0
    BEQ      in_nbr_wait_28
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
    JUMP     input_loop_27
input_loop_27_end:
    LOAD_ADDR input_str_26
    STORE    fmt
    LOADI    0
    STORE    i
loop_29:
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
    BEQ      not_equal_false_32
    JUMP     not_equal_true_31
not_equal_false_32:
    LOADI    0
    JUMP     end_33
not_equal_true_31:
    LOADI    1
end_33:
    CMPI     0
    BEQ      end_30
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
    BEQ      equal_true_36
    JUMP     equal_false_37
equal_true_36:
    LOADI    1
    JUMP     end_38
equal_false_37:
    LOADI    0
    JUMP     end_38
end_38:
    CMPI     0
    BEQ      if_false_34
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
    BEQ      equal_true_41
    JUMP     equal_false_42
equal_true_41:
    LOADI    1
    JUMP     end_43
equal_false_42:
    LOADI    0
    JUMP     end_43
end_43:
    CMPI     0
    BEQ      if_false_39
    LOADI    1
    STORE    left
    LOAD     j
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    j
    JUMP     end_40
if_false_39:
end_40:
loop_44:
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
    BEQ      equal_true_46
    JUMP     equal_false_47
equal_true_46:
    LOADI    1
    JUMP     end_48
equal_false_47:
    LOADI    0
    JUMP     end_48
end_48:
    CMPI     0
    BEQ      end_45
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
    JUMP     loop_44
end_45:
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
    BEQ      equal_true_51
    JUMP     equal_false_52
equal_true_51:
    LOADI    1
    JUMP     end_53
equal_false_52:
    LOADI    0
    JUMP     end_53
end_53:
    CMPI     0
    BEQ      if_false_49
in_nbr_wait_54:
    LOAD     system_in_ready
    CMPI     0
    BEQ      in_nbr_wait_54
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
    BEQ      equal_true_57
    JUMP     equal_false_58
equal_true_57:
    LOADI    1
    JUMP     end_59
equal_false_58:
    LOADI    0
    JUMP     end_59
end_59:
    CMPI     0
    BEQ      if_false_55
    LOAD     spaces
repeat_check_60:
    CMPI     0
    BEQ      end_62
    BGE      repeat_loop_61
    JUMP     end_62
repeat_loop_61:
    PUSH
    LOADI    32
    PUSH
wait_63:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_63_end
    JUMP     wait_63
wait_63_end:
    DI
    POP
    STORE    system_out_buffer
    LOADI    1
    STORE    system_out_ready
    EI
    POP
    SUBI     1
    JUMP     repeat_check_60
end_62:
    JUMP     end_56
if_false_55:
end_56:
    LOAD     number
    PUSH
wait_64:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_64_end
    JUMP     wait_64
wait_64_end:
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
    BEQ      equal_true_67
    JUMP     equal_false_68
equal_true_67:
    LOADI    1
    JUMP     end_69
equal_false_68:
    LOADI    0
    JUMP     end_69
end_69:
    CMPI     0
    BEQ      if_false_65
    LOAD     spaces
repeat_check_70:
    CMPI     0
    BEQ      end_72
    BGE      repeat_loop_71
    JUMP     end_72
repeat_loop_71:
    PUSH
    LOADI    32
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
    POP
    SUBI     1
    JUMP     repeat_check_70
end_72:
    JUMP     end_66
if_false_65:
end_66:
    LOAD     j
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    i
    JUMP     end_50
if_false_49:
    LOAD     c
    PUSH
wait_74:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_74_end
    JUMP     wait_74
wait_74_end:
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
end_50:
    JUMP     end_35
if_false_34:
    LOAD     c
    PUSH
wait_75:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_75_end
    JUMP     wait_75
wait_75_end:
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
end_35:
    JUMP     loop_29
end_30:
    HALT
