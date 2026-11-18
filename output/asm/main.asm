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
input_str_65:
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
$func_print_smart_inline:
    LOADI    0
    PUSH
    LOAD_SP  2
    PUSH
    LOADI    0
    STORE    $tmp$
    POP
    CMP      $tmp$
    BGE      right_false_27
    LOADI    1
    JUMP     end_28
right_false_27:
    LOADI    0
end_28:
    CMPI     0
    BEQ      if_false_25
    LOADI    45
    PUSH
wait_29:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_29_end
    JUMP     wait_29
wait_29_end:
    DI
    POP
    STORE    system_out_buffer
    LOADI    1
    STORE    system_out_ready
    EI
    JUMP     end_26
if_false_25:
    LOADI    0
    PUSH
    LOAD_SP  3
    STORE    $tmp$
    POP
    SUB      $tmp$
    STORE_SP 2
end_26:
    LOADI    1
    STORE_SP 0
loop_30:
    LOAD_SP  2
    PUSH
    LOAD_SP  1
    STORE    $tmp$
    POP
    DIV      $tmp$
    PUSH
    LOADI    -10
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      lefteq_true_32
    BGE      lefteq_false_33
lefteq_true_32:
    LOADI    1
    JUMP     end_34
lefteq_false_33:
    LOADI    0
end_34:
    CMPI     0
    BEQ      end_31
    LOAD_SP  0
    PUSH
    LOADI    10
    STORE    $tmp$
    POP
    MUL      $tmp$
    STORE_SP 0
    JUMP     loop_30
end_31:
loop_35:
    LOAD_SP  0
    PUSH
    LOADI    0
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      left_false_38
    BGE      left_true_37
left_false_38:
    LOADI    0
    JUMP     end_39
left_true_37:
    LOADI    1
end_39:
    CMPI     0
    BEQ      end_36
    LOADI    0
    PUSH
    LOAD_SP  3
    PUSH
    LOAD_SP  2
    STORE    $tmp$
    POP
    DIV      $tmp$
    STORE    $tmp$
    POP
    SUB      $tmp$
    PUSH
    LOADI    48
    STORE    $tmp$
    POP
    ADD      $tmp$
    PUSH
wait_40:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_40_end
    JUMP     wait_40
wait_40_end:
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
    JUMP     loop_35
end_36:
    STORE    $tmp$
    POP
    LOAD     $tmp$
    RET
end_24:
    JUMP     end_41
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
    BGE      lefteq_true_44
    LOADI    0
    JUMP     end_45
lefteq_true_44:
    LOADI    1
end_45:
    CMPI     0
    BEQ      if_false_42
    LOAD_SP  2
    PUSH
    LOADI    57
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      lefteq_true_48
    BGE      lefteq_false_49
lefteq_true_48:
    LOADI    1
    JUMP     end_50
lefteq_false_49:
    LOADI    0
end_50:
    CMPI     0
    BEQ      if_false_46
    LOADI    1
    STORE_SP 0
    JUMP     end_47
if_false_46:
end_47:
    JUMP     end_43
if_false_42:
end_43:
    LOAD_SP  0
    STORE    $tmp$
    POP
    LOAD     $tmp$
    RET
end_41:
    JUMP     end_51
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
    BGE      right_false_54
    LOADI    1
    JUMP     end_55
right_false_54:
    LOADI    0
end_55:
    CMPI     0
    BEQ      if_false_52
    LOADI    2
    STORE    length
    JUMP     end_53
if_false_52:
end_53:
loop_56:
    LOAD_SP  1
    PUSH
    LOADI    10
    STORE    $tmp$
    POP
    CMP      $tmp$
    BGE      lefteq_true_58
    LOADI    0
    JUMP     end_59
lefteq_true_58:
    LOADI    1
end_59:
    CMPI     0
    BEQ      end_57
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
    JUMP     loop_56
end_57:
loop_60:
    LOAD_SP  1
    PUSH
    LOADI    -10
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      lefteq_true_62
    BGE      lefteq_false_63
lefteq_true_62:
    LOADI    1
    JUMP     end_64
lefteq_false_63:
    LOADI    0
end_64:
    CMPI     0
    BEQ      end_61
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
    JUMP     loop_60
end_61:
    LOAD     length
    RET
end_51:
    LOAD_ADDR input_str_65
    STORE    $tmp_address$
    LOADI    10
    STORE    $tmp$
input_loop_66:
    LOAD     $tmp$
    CMPI     0
    BEQ      input_loop_66_end
in_nbr_wait_67:
    LOAD     system_in_ready
    CMPI     0
    BEQ      in_nbr_wait_67
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
    JUMP     input_loop_66
input_loop_66_end:
    LOAD_ADDR input_str_65
    STORE    fmt
    LOADI    0
    STORE    i
loop_68:
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
    BEQ      not_equal_false_71
    JUMP     not_equal_true_70
not_equal_false_71:
    LOADI    0
    JUMP     end_72
not_equal_true_70:
    LOADI    1
end_72:
    CMPI     0
    BEQ      end_69
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
    BEQ      equal_true_75
    JUMP     equal_false_76
equal_true_75:
    LOADI    1
    JUMP     end_77
equal_false_76:
    LOADI    0
    JUMP     end_77
end_77:
    CMPI     0
    BEQ      if_false_73
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
    BEQ      equal_true_80
    JUMP     equal_false_81
equal_true_80:
    LOADI    1
    JUMP     end_82
equal_false_81:
    LOADI    0
    JUMP     end_82
end_82:
    CMPI     0
    BEQ      if_false_78
    LOADI    1
    STORE    left
    LOAD     j
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    j
    JUMP     end_79
if_false_78:
end_79:
loop_83:
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
    BEQ      equal_true_85
    JUMP     equal_false_86
equal_true_85:
    LOADI    1
    JUMP     end_87
equal_false_86:
    LOADI    0
    JUMP     end_87
end_87:
    CMPI     0
    BEQ      end_84
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
    JUMP     loop_83
end_84:
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
    BEQ      equal_true_90
    JUMP     equal_false_91
equal_true_90:
    LOADI    1
    JUMP     end_92
equal_false_91:
    LOADI    0
    JUMP     end_92
end_92:
    CMPI     0
    BEQ      if_false_88
in_nbr_wait_93:
    LOAD     system_in_ready
    CMPI     0
    BEQ      in_nbr_wait_93
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
    BEQ      equal_true_96
    JUMP     equal_false_97
equal_true_96:
    LOADI    1
    JUMP     end_98
equal_false_97:
    LOADI    0
    JUMP     end_98
end_98:
    CMPI     0
    BEQ      if_false_94
    LOAD     spaces
repeat_check_99:
    CMPI     0
    BEQ      end_101
    BGE      repeat_loop_100
    JUMP     end_101
repeat_loop_100:
    PUSH
    LOADI    32
    PUSH
wait_102:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_102_end
    JUMP     wait_102
wait_102_end:
    DI
    POP
    STORE    system_out_buffer
    LOADI    1
    STORE    system_out_ready
    EI
    POP
    SUBI     1
    JUMP     repeat_check_99
end_101:
    JUMP     end_95
if_false_94:
end_95:
    LOAD     number
    PUSH
    CALL     $func_print_smart_inline
    STORE    $tmp$
    POP
    LOAD     $tmp$
    LOAD     left
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      equal_true_105
    JUMP     equal_false_106
equal_true_105:
    LOADI    1
    JUMP     end_107
equal_false_106:
    LOADI    0
    JUMP     end_107
end_107:
    CMPI     0
    BEQ      if_false_103
    LOAD     spaces
repeat_check_108:
    CMPI     0
    BEQ      end_110
    BGE      repeat_loop_109
    JUMP     end_110
repeat_loop_109:
    PUSH
    LOADI    32
    PUSH
wait_111:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_111_end
    JUMP     wait_111
wait_111_end:
    DI
    POP
    STORE    system_out_buffer
    LOADI    1
    STORE    system_out_ready
    EI
    POP
    SUBI     1
    JUMP     repeat_check_108
end_110:
    JUMP     end_104
if_false_103:
end_104:
    LOAD     j
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    i
    JUMP     end_89
if_false_88:
    LOADI    -1
    PUSH
    CALL     $func_print_smart_inline
    STORE    $tmp$
    POP
    LOAD     $tmp$
    LOADI    10
    STORE    i
end_89:
    JUMP     end_74
if_false_73:
    LOAD     c
    PUSH
wait_112:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_112_end
    JUMP     wait_112
wait_112_end:
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
end_74:
    JUMP     loop_68
end_69:
    HALT
