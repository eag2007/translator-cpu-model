system_in_buffer         .word 0
system_in_ready          .word 0
system_out_buffer        .word 0
system_out_ready         .word 0
fmt                      .word 0
i                        .word 0
c                        .word 0
j                        .word 0
left                     .word 0
width                    .word 0
number                   .word 0
length                   .word 0
spaces                   .word 0
$tmp$                    .word 0
$tmp_address$            .word 0
input_str_48:
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
$func_print_smart:
    LOADI    0
    PUSH
    LOAD_SP  2
    PUSH
    LOADI    0
    STORE    $tmp$
    POP
    CMP      $tmp$
    BGE      right_false_5
    LOADI    1
    JUMP     end_6
right_false_5:
    LOADI    0
end_6:
    CMPI     0
    BEQ      if_false_3
    LOADI    45
    PUSH
wait_7:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_7_end
    JUMP     wait_7
wait_7_end:
    DI
    POP
    STORE    system_out_buffer
    LOADI    1
    STORE    system_out_ready
    EI
    LOADI    0
    PUSH
    LOAD_SP  3
    STORE    $tmp$
    POP
    SUB      $tmp$
    STORE_SP 2
    JUMP     end_4
if_false_3:
end_4:
    LOADI    1
    STORE_SP 0
loop_8:
    LOAD_SP  2
    PUSH
    LOAD_SP  1
    STORE    $tmp$
    POP
    DIV      $tmp$
    PUSH
    LOADI    10
    STORE    $tmp$
    POP
    CMP      $tmp$
    BGE      lefteq_true_10
    LOADI    0
    JUMP     end_11
lefteq_true_10:
    LOADI    1
end_11:
    CMPI     0
    BEQ      end_9
    LOAD_SP  0
    PUSH
    LOADI    10
    STORE    $tmp$
    POP
    MUL      $tmp$
    STORE_SP 0
    JUMP     loop_8
end_9:
loop_12:
    LOAD_SP  0
    PUSH
    LOADI    0
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      left_false_15
    BGE      left_true_14
left_false_15:
    LOADI    0
    JUMP     end_16
left_true_14:
    LOADI    1
end_16:
    CMPI     0
    BEQ      end_13
    LOAD_SP  2
    PUSH
    LOAD_SP  1
    STORE    $tmp$
    POP
    DIV      $tmp$
    PUSH
    LOADI    48
    STORE    $tmp$
    POP
    ADD      $tmp$
    PUSH
wait_17:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_17_end
    JUMP     wait_17
wait_17_end:
    DI
    POP
    STORE    system_out_buffer
    LOADI    1
    STORE    system_out_ready
    EI
    LOAD_SP  2
    PUSH
    LOAD_SP  1
    STORE    $tmp$
    POP
    MOD      $tmp$
    STORE_SP 2
    LOAD_SP  0
    PUSH
    LOADI    10
    STORE    $tmp$
    POP
    DIV      $tmp$
    STORE_SP 0
    LOAD_SP  0
    PUSH
    LOADI    0
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      left_false_21
    BGE      left_true_20
left_false_21:
    LOADI    0
    JUMP     end_22
left_true_20:
    LOADI    1
end_22:
    CMPI     0
    BEQ      if_false_18
    JUMP     end_19
if_false_18:
end_19:
    JUMP     loop_12
end_13:
    LOADI    10
    PUSH
wait_23:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_23_end
    JUMP     wait_23
wait_23_end:
    DI
    POP
    STORE    system_out_buffer
    LOADI    1
    STORE    system_out_ready
    EI
    STORE    $tmp$
    POP
    LOAD     $tmp$
    RET
end_2:
    JUMP     end_24
$func_is_digit:
    LOADI    0
    PUSH
    LOADI    0
    STORE_SP 0
    LOAD_SP  2
    PUSH
    LOADI    48
    STORE    $tmp$
    POP
    CMP      $tmp$
    BGE      lefteq_true_27
    LOADI    0
    JUMP     end_28
lefteq_true_27:
    LOADI    1
end_28:
    CMPI     0
    BEQ      if_false_25
    LOAD_SP  2
    PUSH
    LOADI    57
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      lefteq_true_31
    BGE      lefteq_false_32
lefteq_true_31:
    LOADI    1
    JUMP     end_33
lefteq_false_32:
    LOADI    0
end_33:
    CMPI     0
    BEQ      if_false_29
    LOADI    1
    STORE_SP 0
    JUMP     end_30
if_false_29:
end_30:
    JUMP     end_26
if_false_25:
end_26:
    LOAD_SP  0
    STORE    $tmp$
    POP
    LOAD     $tmp$
    RET
end_24:
    JUMP     end_34
$func_number_length:
    LOADI    0
    LOADI    1
    STORE    length
    LOAD_SP  1
    PUSH
    LOADI    0
    STORE    $tmp$
    POP
    CMP      $tmp$
    BGE      right_false_37
    LOADI    1
    JUMP     end_38
right_false_37:
    LOADI    0
end_38:
    CMPI     0
    BEQ      if_false_35
    LOADI    2
    STORE    length
    JUMP     end_36
if_false_35:
end_36:
loop_39:
    LOAD_SP  1
    PUSH
    LOADI    10
    STORE    $tmp$
    POP
    CMP      $tmp$
    BGE      lefteq_true_41
    LOADI    0
    JUMP     end_42
lefteq_true_41:
    LOADI    1
end_42:
    CMPI     0
    BEQ      end_40
    LOAD_SP  1
    PUSH
    LOADI    10
    STORE    $tmp$
    POP
    DIV      $tmp$
    STORE_SP 1
    LOAD     length
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    length
    JUMP     loop_39
end_40:
loop_43:
    LOAD_SP  1
    PUSH
    LOADI    -10
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      lefteq_true_45
    BGE      lefteq_false_46
lefteq_true_45:
    LOADI    1
    JUMP     end_47
lefteq_false_46:
    LOADI    0
end_47:
    CMPI     0
    BEQ      end_44
    LOAD_SP  1
    PUSH
    LOADI    10
    STORE    $tmp$
    POP
    DIV      $tmp$
    STORE_SP 1
    LOAD     length
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    length
    JUMP     loop_43
end_44:
    LOAD     length
    RET
end_34:
    LOAD_ADDR input_str_48
    STORE    $tmp_address$
    LOADI    32
    STORE    $tmp$
input_loop_49:
    LOAD     $tmp$
    CMPI     0
    BEQ      input_loop_49_end
in_nbr_wait_50:
    LOAD     system_in_ready
    CMPI     0
    BEQ      in_nbr_wait_50
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
    JUMP     input_loop_49
input_loop_49_end:
    LOAD_ADDR input_str_48
    STORE    fmt
    LOADI    0
    STORE    i
loop_51:
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
    BEQ      not_equal_false_54
    JUMP     not_equal_true_53
not_equal_false_54:
    LOADI    0
    JUMP     end_55
not_equal_true_53:
    LOADI    1
end_55:
    CMPI     0
    BEQ      end_52
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
    BEQ      equal_true_58
    JUMP     equal_false_59
equal_true_58:
    LOADI    1
    JUMP     end_60
equal_false_59:
    LOADI    0
    JUMP     end_60
end_60:
    CMPI     0
    BEQ      if_false_56
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
    BEQ      equal_true_63
    JUMP     equal_false_64
equal_true_63:
    LOADI    1
    JUMP     end_65
equal_false_64:
    LOADI    0
    JUMP     end_65
end_65:
    CMPI     0
    BEQ      if_false_61
    LOADI    1
    STORE    left
    LOAD     j
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    j
    JUMP     end_62
if_false_61:
end_62:
loop_66:
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
    BEQ      equal_true_68
    JUMP     equal_false_69
equal_true_68:
    LOADI    1
    JUMP     end_70
equal_false_69:
    LOADI    0
    JUMP     end_70
end_70:
    CMPI     0
    BEQ      end_67
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
    JUMP     loop_66
end_67:
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
    BEQ      equal_true_73
    JUMP     equal_false_74
equal_true_73:
    LOADI    1
    JUMP     end_75
equal_false_74:
    LOADI    0
    JUMP     end_75
end_75:
    CMPI     0
    BEQ      if_false_71
in_nbr_wait_76:
    LOAD     system_in_ready
    CMPI     0
    BEQ      in_nbr_wait_76
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
    BEQ      equal_true_79
    JUMP     equal_false_80
equal_true_79:
    LOADI    1
    JUMP     end_81
equal_false_80:
    LOADI    0
    JUMP     end_81
end_81:
    CMPI     0
    BEQ      if_false_77
    LOAD     spaces
repeat_check_82:
    CMPI     0
    BEQ      end_84
    BGE      repeat_loop_83
    JUMP     end_84
repeat_loop_83:
    PUSH
    LOADI    32
    PUSH
wait_85:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_85_end
    JUMP     wait_85
wait_85_end:
    DI
    POP
    STORE    system_out_buffer
    LOADI    1
    STORE    system_out_ready
    EI
    POP
    SUBI     1
    JUMP     repeat_check_82
end_84:
    JUMP     end_78
if_false_77:
end_78:
    LOAD     number
    PUSH
    CALL     $func_print_smart
    STORE    $tmp$
    POP
    LOAD     $tmp$
    LOAD     left
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      equal_true_88
    JUMP     equal_false_89
equal_true_88:
    LOADI    1
    JUMP     end_90
equal_false_89:
    LOADI    0
    JUMP     end_90
end_90:
    CMPI     0
    BEQ      if_false_86
    LOAD     spaces
repeat_check_91:
    CMPI     0
    BEQ      end_93
    BGE      repeat_loop_92
    JUMP     end_93
repeat_loop_92:
    PUSH
    LOADI    32
    PUSH
wait_94:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_94_end
    JUMP     wait_94
wait_94_end:
    DI
    POP
    STORE    system_out_buffer
    LOADI    1
    STORE    system_out_ready
    EI
    POP
    SUBI     1
    JUMP     repeat_check_91
end_93:
    JUMP     end_87
if_false_86:
end_87:
    LOAD     j
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    i
    JUMP     end_72
if_false_71:
    LOAD     c
    PUSH
wait_95:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_95_end
    JUMP     wait_95
wait_95_end:
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
end_72:
    JUMP     end_57
if_false_56:
    LOAD     c
    PUSH
wait_96:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_96_end
    JUMP     wait_96
wait_96_end:
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
end_57:
    JUMP     loop_51
end_52:
    HALT
