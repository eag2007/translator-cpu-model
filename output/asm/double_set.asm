system_in_buffer         .word 0
system_in_ready          .word 0
system_out_buffer        .word 0
system_out_ready         .word 0
x                        .word 0
y                        .word 0
sum                      .word 0
a                        .word 0
b                        .word 0
maximum                  .word 0
nested                   .word 0
$tmp$                    .word 0
$tmp_address$            .word 0
print_str_ptr_58:
.word                    0
string_62:
.word                    120
.word                    44
.word                    32
.word                    121
.word                    58
.word                    32
.word                    0
print_str_ptr_63:
.word                    0
string_67:
.word                    97
.word                    44
.word                    32
.word                    98
.word                    44
.word                    32
.word                    115
.word                    117
.word                    109
.word                    58
.word                    32
.word                    0
print_str_ptr_68:
.word                    0
string_72:
.word                    109
.word                    97
.word                    120
.word                    105
.word                    109
.word                    117
.word                    109
.word                    58
.word                    32
.word                    0
print_str_ptr_73:
.word                    0
string_77:
.word                    110
.word                    101
.word                    115
.word                    116
.word                    101
.word                    100
.word                    58
.word                    32
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
    LOADI    13
    STORE    y
    STORE    x
    LOAD     x
    PUSH
    CALL     $func_print_smart
    STORE    $tmp$
    POP
    LOAD     $tmp$
    LOADI    13
    STORE    y
    STORE    x
    LOADI    7
    STORE    a
    PUSH
    LOADI    2
    PUSH
    LOADI    3
    STORE    b
    STORE    $tmp$
    POP
    MUL      $tmp$
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    sum
    LOAD     x
    PUSH
    LOAD     a
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      left_false_50
    BGE      left_true_49
left_false_50:
    LOADI    0
    JUMP     end_51
left_true_49:
    LOADI    1
end_51:
    CMPI     0
    BEQ      if_false_47
    LOAD     x
    JUMP     end_48
if_false_47:
    LOAD     a
end_48:
    STORE    maximum
    JUMP     end_52
$func_twice_plus_one:
    LOADI    0
    PUSH
    LOAD_SP  8
    PUSH
    LOADI    2
    STORE    $tmp$
    POP
    MUL      $tmp$
    STORE_SP 0
    LOAD_SP  0
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    $tmp$
    POP
    LOAD     $tmp$
    RET
end_52:
    LOAD     a
    PUSH
    CALL     $func_twice_plus_one
    STORE    $tmp$
    POP
    LOAD     $tmp$
    PUSH
    LOAD     x
    PUSH
    LOAD     y
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
    LOADI    100
    JUMP     end_54
if_false_53:
    LOADI    0
end_54:
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    nested
    LOAD_ADDR string_62
    STORE    print_str_ptr_58
print_str_loop_59:
    LOAD     system_out_ready
    CMPI     0
    BEQ      print_str_check_60
    JUMP     print_str_loop_59
print_str_check_60:
    LOAD_IND print_str_ptr_58
    CMPI     0
    BEQ      print_str_end_61
    DI
    LOAD_IND print_str_ptr_58
    STORE    system_out_buffer
    LOADI    1
    STORE    system_out_ready
    EI
    LOAD     print_str_ptr_58
    ADDI     4
    STORE    print_str_ptr_58
    JUMP     print_str_loop_59
print_str_end_61:
    LOAD     x
    PUSH
    CALL     $func_print_smart
    STORE    $tmp$
    POP
    LOAD     $tmp$
    LOAD     y
    PUSH
    CALL     $func_print_smart
    STORE    $tmp$
    POP
    LOAD     $tmp$
    LOAD_ADDR string_67
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
    LOAD     a
    PUSH
    CALL     $func_print_smart
    STORE    $tmp$
    POP
    LOAD     $tmp$
    LOAD     b
    PUSH
    CALL     $func_print_smart
    STORE    $tmp$
    POP
    LOAD     $tmp$
    LOAD     sum
    PUSH
    CALL     $func_print_smart
    STORE    $tmp$
    POP
    LOAD     $tmp$
    LOAD_ADDR string_72
    STORE    print_str_ptr_68
print_str_loop_69:
    LOAD     system_out_ready
    CMPI     0
    BEQ      print_str_check_70
    JUMP     print_str_loop_69
print_str_check_70:
    LOAD_IND print_str_ptr_68
    CMPI     0
    BEQ      print_str_end_71
    DI
    LOAD_IND print_str_ptr_68
    STORE    system_out_buffer
    LOADI    1
    STORE    system_out_ready
    EI
    LOAD     print_str_ptr_68
    ADDI     4
    STORE    print_str_ptr_68
    JUMP     print_str_loop_69
print_str_end_71:
    LOAD     maximum
    PUSH
    CALL     $func_print_smart
    STORE    $tmp$
    POP
    LOAD     $tmp$
    LOAD_ADDR string_77
    STORE    print_str_ptr_73
print_str_loop_74:
    LOAD     system_out_ready
    CMPI     0
    BEQ      print_str_check_75
    JUMP     print_str_loop_74
print_str_check_75:
    LOAD_IND print_str_ptr_73
    CMPI     0
    BEQ      print_str_end_76
    DI
    LOAD_IND print_str_ptr_73
    STORE    system_out_buffer
    LOADI    1
    STORE    system_out_ready
    EI
    LOAD     print_str_ptr_73
    ADDI     4
    STORE    print_str_ptr_73
    JUMP     print_str_loop_74
print_str_end_76:
    LOAD     nested
    PUSH
    CALL     $func_print_smart
    STORE    $tmp$
    POP
    LOAD     $tmp$
    HALT
