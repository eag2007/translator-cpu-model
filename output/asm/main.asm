system_in_buffer         .word 0
system_in_ready          .word 0
length                   .word 0
$tmp$                    .word 0
i                        .word 0
$tmp_address$            .word 0
j                        .word 0
system_out_buffer        .word 0
left                     .word 0
c                        .word 0
fmt                      .word 0
width                    .word 0
number                   .word 0
system_out_ready         .word 0
spaces                   .word 0
input_str_28:
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
    JUMP     end_2
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
end_2:
    JUMP     end_3
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
end_3:
    JUMP     end_4
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
    BGE      lefteq_true_7
    LOADI    0
    JUMP     end_8
lefteq_true_7:
    LOADI    1
end_8:
    CMPI     0
    BEQ      if_false_5
    LOAD_SP  3
    PUSH
    LOADI    57
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      lefteq_true_11
    BGE      lefteq_false_12
lefteq_true_11:
    LOADI    1
    JUMP     end_13
lefteq_false_12:
    LOADI    0
end_13:
    CMPI     0
    BEQ      if_false_9
    LOADI    1
    STORE_SP 1
    JUMP     end_10
if_false_9:
end_10:
    JUMP     end_6
if_false_5:
end_6:
    LOAD_SP  1
    STORE    $tmp$
    POP
    LOAD     $tmp$
    RET
end_4:
    JUMP     end_14
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
    BGE      right_false_17
    LOADI    1
    JUMP     end_18
right_false_17:
    LOADI    0
end_18:
    CMPI     0
    BEQ      if_false_15
    LOADI    2
    STORE    length
    JUMP     end_16
if_false_15:
end_16:
loop_19:
    LOAD_SP  2
    PUSH
    LOADI    10
    STORE    $tmp$
    POP
    CMP      $tmp$
    BGE      lefteq_true_21
    LOADI    0
    JUMP     end_22
lefteq_true_21:
    LOADI    1
end_22:
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
loop_23:
    LOAD_SP  2
    PUSH
    LOADI    -10
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      lefteq_true_25
    BGE      lefteq_false_26
lefteq_true_25:
    LOADI    1
    JUMP     end_27
lefteq_false_26:
    LOADI    0
end_27:
    CMPI     0
    BEQ      end_24
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
    JUMP     loop_23
end_24:
    LOAD     length
    RET
end_14:
    LOAD_ADDR input_str_28
    STORE    $tmp_address$
    LOADI    32
    STORE    $tmp$
input_loop_29:
    LOAD     $tmp$
    CMPI     0
    BEQ      input_loop_29_end
in_nbr_wait_30:
    LOAD     system_in_ready
    CMPI     0
    BEQ      in_nbr_wait_30
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
    JUMP     input_loop_29
input_loop_29_end:
    LOAD_ADDR input_str_28
    STORE    fmt
    LOADI    0
    STORE    i
loop_31:
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
    BEQ      not_equal_false_34
    JUMP     not_equal_true_33
not_equal_false_34:
    LOADI    0
    JUMP     end_35
not_equal_true_33:
    LOADI    1
end_35:
    CMPI     0
    BEQ      end_32
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
    BEQ      equal_true_38
    JUMP     equal_false_39
equal_true_38:
    LOADI    1
    JUMP     end_40
equal_false_39:
    LOADI    0
    JUMP     end_40
end_40:
    CMPI     0
    BEQ      if_false_36
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
    BEQ      equal_true_43
    JUMP     equal_false_44
equal_true_43:
    LOADI    1
    JUMP     end_45
equal_false_44:
    LOADI    0
    JUMP     end_45
end_45:
    CMPI     0
    BEQ      if_false_41
    LOADI    1
    STORE    left
    LOAD     j
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    j
    JUMP     end_42
if_false_41:
end_42:
loop_46:
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
    BEQ      equal_true_48
    JUMP     equal_false_49
equal_true_48:
    LOADI    1
    JUMP     end_50
equal_false_49:
    LOADI    0
    JUMP     end_50
end_50:
    CMPI     0
    BEQ      end_47
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
    JUMP     loop_46
end_47:
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
    BEQ      equal_true_53
    JUMP     equal_false_54
equal_true_53:
    LOADI    1
    JUMP     end_55
equal_false_54:
    LOADI    0
    JUMP     end_55
end_55:
    CMPI     0
    BEQ      if_false_51
in_nbr_wait_56:
    LOAD     system_in_ready
    CMPI     0
    BEQ      in_nbr_wait_56
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
    BEQ      equal_true_59
    JUMP     equal_false_60
equal_true_59:
    LOADI    1
    JUMP     end_61
equal_false_60:
    LOADI    0
    JUMP     end_61
end_61:
    CMPI     0
    BEQ      if_false_57
    LOAD     spaces
repeat_check_62:
    CMPI     0
    BEQ      end_64
    BGE      repeat_loop_63
    JUMP     end_64
repeat_loop_63:
    PUSH
    LOADI    32
    PUSH
wait_65:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_65_end
    JUMP     wait_65
wait_65_end:
    DI
    POP
    STORE    system_out_buffer
    LOADI    1
    STORE    system_out_ready
    EI
    POP
    SUBI     1
    JUMP     repeat_check_62
end_64:
    JUMP     end_58
if_false_57:
end_58:
    LOAD     number
    PUSH
wait_66:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_66_end
    JUMP     wait_66
wait_66_end:
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
    BEQ      equal_true_69
    JUMP     equal_false_70
equal_true_69:
    LOADI    1
    JUMP     end_71
equal_false_70:
    LOADI    0
    JUMP     end_71
end_71:
    CMPI     0
    BEQ      if_false_67
    LOAD     spaces
repeat_check_72:
    CMPI     0
    BEQ      end_74
    BGE      repeat_loop_73
    JUMP     end_74
repeat_loop_73:
    PUSH
    LOADI    32
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
    POP
    SUBI     1
    JUMP     repeat_check_72
end_74:
    JUMP     end_68
if_false_67:
end_68:
    LOAD     j
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    i
    JUMP     end_52
if_false_51:
    LOAD     c
    PUSH
wait_76:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_76_end
    JUMP     wait_76
wait_76_end:
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
end_52:
    JUMP     end_37
if_false_36:
    LOAD     c
    PUSH
wait_77:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_77_end
    JUMP     wait_77
wait_77_end:
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
end_37:
    JUMP     loop_31
end_32:
    HALT
