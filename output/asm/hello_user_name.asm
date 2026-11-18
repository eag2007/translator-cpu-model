system_in_buffer         .word 0
system_in_ready          .word 0
system_out_buffer        .word 0
system_out_ready         .word 0
name                     .word 0
$tmp$                    .word 0
$tmp_address$            .word 0
print_str_ptr_47:
.word                    0
string_51:
.word                    87
.word                    104
.word                    97
.word                    116
.word                    32
.word                    105
.word                    115
.word                    32
.word                    121
.word                    111
.word                    117
.word                    114
.word                    32
.word                    110
.word                    97
.word                    109
.word                    101
.word                    63
.word                    0
input_str_53:
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
.word                    0
print_str_ptr_63:
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
    PUSH
    LOADI    0
    STORE_SP 0
loop_42:
    LOAD_SP  8
    PUSH
    LOAD_SP  4
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
    LOAD_SP  0
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE_SP 0
    JUMP     loop_42
end_43:
    LOAD_SP  0
    STORE    $tmp$
    POP
    LOAD     $tmp$
    RET
end_41:
    LOAD_ADDR string_51
    STORE    print_str_ptr_47
print_str_loop_48:
    LOAD     system_out_ready
    CMPI     0
    BEQ      print_str_check_49
    JUMP     print_str_loop_48
print_str_check_49:
    LOAD_IND print_str_ptr_47
    CMPI     0
    BEQ      print_str_end_50
    DI
    LOAD_IND print_str_ptr_47
    STORE    system_out_buffer
    LOADI    1
    STORE    system_out_ready
    EI
    LOAD     print_str_ptr_47
    ADDI     4
    STORE    print_str_ptr_47
    JUMP     print_str_loop_48
print_str_end_50:
    LOADI    10
    PUSH
wait_52:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_52_end
    JUMP     wait_52
wait_52_end:
    DI
    POP
    STORE    system_out_buffer
    LOADI    1
    STORE    system_out_ready
    EI
    LOAD_ADDR input_str_53
    STORE    $tmp_address$
    LOADI    5
    STORE    $tmp$
input_loop_54:
    LOAD     $tmp$
    CMPI     0
    BEQ      input_loop_54_end
in_nbr_wait_55:
    LOAD     system_in_ready
    CMPI     0
    BEQ      in_nbr_wait_55
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
    JUMP     input_loop_54
input_loop_54_end:
    LOAD_ADDR input_str_53
    STORE    name
    LOADI    72
    PUSH
wait_56:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_56_end
    JUMP     wait_56
wait_56_end:
    DI
    POP
    STORE    system_out_buffer
    LOADI    1
    STORE    system_out_ready
    EI
    LOADI    101
    PUSH
wait_57:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_57_end
    JUMP     wait_57
wait_57_end:
    DI
    POP
    STORE    system_out_buffer
    LOADI    1
    STORE    system_out_ready
    EI
    LOADI    108
    PUSH
wait_58:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_58_end
    JUMP     wait_58
wait_58_end:
    DI
    POP
    STORE    system_out_buffer
    LOADI    1
    STORE    system_out_ready
    EI
    LOADI    108
    PUSH
wait_59:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_59_end
    JUMP     wait_59
wait_59_end:
    DI
    POP
    STORE    system_out_buffer
    LOADI    1
    STORE    system_out_ready
    EI
    LOADI    111
    PUSH
wait_60:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_60_end
    JUMP     wait_60
wait_60_end:
    DI
    POP
    STORE    system_out_buffer
    LOADI    1
    STORE    system_out_ready
    EI
    LOADI    44
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
    LOADI    32
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
    LOAD     name
    STORE    print_str_ptr_63
print_str_loop_64:
    LOAD     system_out_ready
    CMPI     0
    BEQ      print_str_check_65
    JUMP     print_str_loop_64
print_str_check_65:
    LOAD_IND print_str_ptr_63
    CMPI     0
    BEQ      print_str_end_66
    DI
    LOAD_IND print_str_ptr_63
    STORE    system_out_buffer
    LOADI    1
    STORE    system_out_ready
    EI
    LOAD     print_str_ptr_63
    ADDI     4
    STORE    print_str_ptr_63
    JUMP     print_str_loop_64
print_str_end_66:
    LOADI    10
    PUSH
wait_67:
    LOAD     system_out_ready
    CMPI     0
    BEQ      wait_67_end
    JUMP     wait_67
wait_67_end:
    DI
    POP
    STORE    system_out_buffer
    LOADI    1
    STORE    system_out_ready
    EI
    HALT
