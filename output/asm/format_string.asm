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
input_str_71:
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
    MULI     4
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
    LOADI    4
    PUSH
    LOADI    0
    MULI     4
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
    LOAD_SP  8
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
    LOAD_SP  12
    STORE    $tmp$
    POP
    SUB      $tmp$
    STORE_SP 8
    JUMP     end_4
if_false_3:
end_4:
    LOADI    1
    STORE_SP 0
loop_8:
    LOAD_SP  8
    PUSH
    LOAD_SP  4
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
    LOAD_SP  8
    PUSH
    LOAD_SP  4
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
    LOAD_SP  8
    PUSH
    LOAD_SP  4
    STORE    $tmp$
    POP
    MOD      $tmp$
    STORE_SP 8
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
    LOAD_SP  8
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
    LOAD_SP  12
    STORE    $tmp$
    POP
    SUB      $tmp$
    STORE_SP 8
end_26:
    LOADI    1
    STORE_SP 0
loop_30:
    LOAD_SP  8
    PUSH
    LOAD_SP  4
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
    LOAD_SP  12
    PUSH
    LOAD_SP  8
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
    LOAD_SP  8
    PUSH
    LOAD_SP  4
    STORE    $tmp$
    POP
    MOD      $tmp$
    STORE_SP 8
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
$func_len:
    LOADI    0
    LOADI    0
    STORE    length
loop_42:
    LOAD_SP  4
    PUSH
    LOAD     length
    MULI     4
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
    BEQ      not_equal_false_45
    JUMP     not_equal_true_44
not_equal_false_45:
    LOADI    0
    JUMP     end_46
not_equal_true_44:
    LOADI    1
end_46:
    CMPI     0
    BEQ      end_43
    LOAD     length
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    length
    JUMP     loop_42
end_43:
    LOAD     length
    RET
end_41:
    JUMP     end_47
$func_is_digit:
    LOADI    0
    PUSH
    LOADI    0
    STORE_SP 0
    LOAD_SP  8
    PUSH
    LOADI    48
    STORE    $tmp$
    POP
    CMP      $tmp$
    BGE      lefteq_true_50
    LOADI    0
    JUMP     end_51
lefteq_true_50:
    LOADI    1
end_51:
    CMPI     0
    BEQ      if_false_48
    LOAD_SP  8
    PUSH
    LOADI    57
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      lefteq_true_54
    BGE      lefteq_false_55
lefteq_true_54:
    LOADI    1
    JUMP     end_56
lefteq_false_55:
    LOADI    0
end_56:
    CMPI     0
    BEQ      if_false_52
    LOADI    1
    STORE_SP 0
    JUMP     end_53
if_false_52:
end_53:
    JUMP     end_49
if_false_48:
end_49:
    LOAD_SP  0
    STORE    $tmp$
    POP
    LOAD     $tmp$
    RET
end_47:
    JUMP     end_57
$func_number_length:
    LOADI    0
    LOADI    1
    STORE    length
    LOAD_SP  4
    PUSH
    LOADI    0
    STORE    $tmp$
    POP
    CMP      $tmp$
    BGE      right_false_60
    LOADI    1
    JUMP     end_61
right_false_60:
    LOADI    0
end_61:
    CMPI     0
    BEQ      if_false_58
    LOADI    2
    STORE    length
    JUMP     end_59
if_false_58:
end_59:
loop_62:
    LOAD_SP  4
    PUSH
    LOADI    10
    STORE    $tmp$
    POP
    CMP      $tmp$
    BGE      lefteq_true_64
    LOADI    0
    JUMP     end_65
lefteq_true_64:
    LOADI    1
end_65:
    CMPI     0
    BEQ      end_63
    LOAD_SP  4
    PUSH
    LOADI    10
    STORE    $tmp$
    POP
    DIV      $tmp$
    STORE_SP 4
    LOAD     length
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    length
    JUMP     loop_62
end_63:
loop_66:
    LOAD_SP  4
    PUSH
    LOADI    -10
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      lefteq_true_68
    BGE      lefteq_false_69
lefteq_true_68:
    LOADI    1
    JUMP     end_70
lefteq_false_69:
    LOADI    0
end_70:
    CMPI     0
    BEQ      end_67
    LOAD_SP  4
    PUSH
    LOADI    10
    STORE    $tmp$
    POP
    DIV      $tmp$
    STORE_SP 4
    LOAD     length
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    length
    JUMP     loop_66
end_67:
    LOAD     length
    RET
end_57:
    LOAD_ADDR input_str_71
    STORE    $tmp_address$
    LOADI    10
    STORE    $tmp$
input_loop_72:
    LOAD     $tmp$
    CMPI     0
    BEQ      input_loop_72_end
in_nbr_wait_73:
    LOAD     system_in_ready
    CMPI     0
    BEQ      in_nbr_wait_73
    DI
    LOAD     system_in_buffer
    PUSH
    LOADI    0
    STORE    system_in_ready
    POP
    EI
    STORE_IND $tmp_address$
    LOAD     $tmp_address$
    ADDI     4
    STORE    $tmp_address$
    LOAD     $tmp$
    SUBI     1
    STORE    $tmp$
    JUMP     input_loop_72
input_loop_72_end:
    LOAD_ADDR input_str_71
    STORE    fmt
    LOADI    0
    STORE    i
loop_74:
    LOAD     fmt
    PUSH
    LOAD     i
    MULI     4
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
    BEQ      not_equal_false_77
    JUMP     not_equal_true_76
not_equal_false_77:
    LOADI    0
    JUMP     end_78
not_equal_true_76:
    LOADI    1
end_78:
    CMPI     0
    BEQ      end_75
    LOAD     fmt
    PUSH
    LOAD     i
    MULI     4
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
    BEQ      equal_true_81
    JUMP     equal_false_82
equal_true_81:
    LOADI    1
    JUMP     end_83
equal_false_82:
    LOADI    0
    JUMP     end_83
end_83:
    CMPI     0
    BEQ      if_false_79
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
    MULI     4
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
    BEQ      equal_true_86
    JUMP     equal_false_87
equal_true_86:
    LOADI    1
    JUMP     end_88
equal_false_87:
    LOADI    0
    JUMP     end_88
end_88:
    CMPI     0
    BEQ      if_false_84
    LOADI    1
    STORE    left
    LOAD     j
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    j
    JUMP     end_85
if_false_84:
end_85:
loop_89:
    LOAD     fmt
    PUSH
    LOAD     j
    MULI     4
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
    BEQ      equal_true_91
    JUMP     equal_false_92
equal_true_91:
    LOADI    1
    JUMP     end_93
equal_false_92:
    LOADI    0
    JUMP     end_93
end_93:
    CMPI     0
    BEQ      end_90
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
    MULI     4
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
    JUMP     loop_89
end_90:
    LOAD     fmt
    PUSH
    LOAD     j
    MULI     4
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
in_nbr_wait_99:
    LOAD     system_in_ready
    CMPI     0
    BEQ      in_nbr_wait_99
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
    BEQ      equal_true_102
    JUMP     equal_false_103
equal_true_102:
    LOADI    1
    JUMP     end_104
equal_false_103:
    LOADI    0
    JUMP     end_104
end_104:
    CMPI     0
    BEQ      if_false_100
    LOAD     spaces
repeat_check_105:
    CMPI     0
    BEQ      end_107
    BGE      repeat_loop_106
    JUMP     end_107
repeat_loop_106:
    PUSH
    LOADI    32
    PUSH
wait_108:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_108_end
    JUMP     wait_108
wait_108_end:
    DI
    POP
    STORE    system_out_buffer
    LOADI    1
    STORE    system_out_ready
    EI
    POP
    SUBI     1
    JUMP     repeat_check_105
end_107:
    JUMP     end_101
if_false_100:
end_101:
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
    BEQ      equal_true_111
    JUMP     equal_false_112
equal_true_111:
    LOADI    1
    JUMP     end_113
equal_false_112:
    LOADI    0
    JUMP     end_113
end_113:
    CMPI     0
    BEQ      if_false_109
    LOAD     spaces
repeat_check_114:
    CMPI     0
    BEQ      end_116
    BGE      repeat_loop_115
    JUMP     end_116
repeat_loop_115:
    PUSH
    LOADI    32
    PUSH
wait_117:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_117_end
    JUMP     wait_117
wait_117_end:
    DI
    POP
    STORE    system_out_buffer
    LOADI    1
    STORE    system_out_ready
    EI
    POP
    SUBI     1
    JUMP     repeat_check_114
end_116:
    JUMP     end_110
if_false_109:
end_110:
    LOAD     j
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    i
    JUMP     end_95
if_false_94:
    LOADI    -1
    PUSH
    CALL     $func_print_smart_inline
    STORE    $tmp$
    POP
    LOAD     $tmp$
    LOADI    10
    STORE    i
end_95:
    JUMP     end_80
if_false_79:
    LOAD     c
    PUSH
wait_118:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_118_end
    JUMP     wait_118
wait_118_end:
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
end_80:
    JUMP     loop_74
end_75:
    HALT
