system_in_buffer         .word 0
system_in_ready          .word 0
system_out_buffer        .word 0
system_out_ready         .word 0
numbers                  .word 0
count                    .word 0
number                   .word 0
i                        .word 0
j                        .word 0
left                     .word 0
right                    .word 0
$tmp$                    .word 0
$tmp_address$            .word 0
array_47:
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
    LOAD_ADDR array_47
    STORE    numbers
    LOADI    0
    STORE    count
in_nbr_wait_48:
    LOAD     system_in_ready
    CMPI     0
    BEQ      in_nbr_wait_48
    DI
    LOAD     system_in_buffer
    PUSH
    LOADI    0
    STORE    system_in_ready
    POP
    EI
    STORE    number
loop_49:
    LOAD     number
    PUSH
    LOADI    0
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      not_equal_false_52
    JUMP     not_equal_true_51
not_equal_false_52:
    LOADI    0
    JUMP     end_53
not_equal_true_51:
    LOADI    1
end_53:
    CMPI     0
    BEQ      end_50
    LOAD     count
    PUSH
    LOADI    64
    STORE    $tmp$
    POP
    CMP      $tmp$
    BGE      right_false_56
    LOADI    1
    JUMP     end_57
right_false_56:
    LOADI    0
end_57:
    CMPI     0
    BEQ      if_false_54
    LOAD     numbers
    PUSH
    LOAD     count
    MULI     4
    STORE    $tmp$
    POP
    ADD      $tmp$
    PUSH
    LOAD     number
    STORE    $tmp$
    POP
    STORE    $tmp_address$
    LOAD     $tmp$
    STORE_IND $tmp_address$
    LOAD     count
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    count
    JUMP     end_55
if_false_54:
end_55:
in_nbr_wait_58:
    LOAD     system_in_ready
    CMPI     0
    BEQ      in_nbr_wait_58
    DI
    LOAD     system_in_buffer
    PUSH
    LOADI    0
    STORE    system_in_ready
    POP
    EI
    STORE    number
    JUMP     loop_49
end_50:
    LOADI    0
    STORE    i
loop_59:
    LOAD     i
    PUSH
    LOAD     count
    STORE    $tmp$
    POP
    CMP      $tmp$
    BGE      right_false_61
    LOADI    1
    JUMP     end_62
right_false_61:
    LOADI    0
end_62:
    CMPI     0
    BEQ      end_60
    LOADI    0
    STORE    j
loop_63:
    LOAD     j
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    PUSH
    LOAD     count
    PUSH
    LOAD     i
    STORE    $tmp$
    POP
    SUB      $tmp$
    STORE    $tmp$
    POP
    CMP      $tmp$
    BGE      right_false_65
    LOADI    1
    JUMP     end_66
right_false_65:
    LOADI    0
end_66:
    CMPI     0
    BEQ      end_64
    LOAD     numbers
    PUSH
    LOAD     j
    MULI     4
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    $tmp$
    LOAD_IND $tmp$
    STORE    left
    LOAD     numbers
    PUSH
    LOAD     j
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    MULI     4
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    $tmp$
    LOAD_IND $tmp$
    STORE    right
    LOAD     left
    PUSH
    LOAD     right
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      left_false_70
    BGE      left_true_69
left_false_70:
    LOADI    0
    JUMP     end_71
left_true_69:
    LOADI    1
end_71:
    CMPI     0
    BEQ      if_false_67
    LOAD     numbers
    PUSH
    LOAD     j
    MULI     4
    STORE    $tmp$
    POP
    ADD      $tmp$
    PUSH
    LOAD     right
    STORE    $tmp$
    POP
    STORE    $tmp_address$
    LOAD     $tmp$
    STORE_IND $tmp_address$
    LOAD     numbers
    PUSH
    LOAD     j
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    MULI     4
    STORE    $tmp$
    POP
    ADD      $tmp$
    PUSH
    LOAD     left
    STORE    $tmp$
    POP
    STORE    $tmp_address$
    LOAD     $tmp$
    STORE_IND $tmp_address$
    JUMP     end_68
if_false_67:
end_68:
    LOAD     j
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    j
    JUMP     loop_63
end_64:
    LOAD     i
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    i
    JUMP     loop_59
end_60:
    LOADI    0
    STORE    i
loop_72:
    LOAD     i
    PUSH
    LOAD     count
    STORE    $tmp$
    POP
    CMP      $tmp$
    BGE      right_false_74
    LOADI    1
    JUMP     end_75
right_false_74:
    LOADI    0
end_75:
    CMPI     0
    BEQ      end_73
    LOAD     numbers
    PUSH
    LOAD     i
    MULI     4
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    $tmp$
    LOAD_IND $tmp$
    PUSH
    CALL     $func_print_smart
    STORE    $tmp$
    POP
    LOAD     $tmp$
    LOAD     i
    PUSH
    LOADI    1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    i
    JUMP     loop_72
end_73:
    HALT
