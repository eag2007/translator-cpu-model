system_out_buffer        .word 0
width                    .word 0
system_in_buffer         .word 0
j                        .word 0
c                        .word 0
fmt                      .word 0
system_out_ready         .word 0
left                     .word 0
spaces                   .word 0
i                        .word 0
$tmp_address$            .word 0
$tmp$                    .word 0
system_in_ready          .word 0
number                   .word 0
length                   .word 0
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
    LOAD     #0
    STORE    system_in_buffer
    LOAD     #0
    STORE    system_in_ready
    LOAD     #0
    STORE    system_out_buffer
    LOAD     #0
    STORE    system_out_ready
    JUMP     end_0
$func_irq_input:
    LOAD     $tmp$
    PUSH
    LOAD     $tmp_address$
    PUSH
    LOAD     #0
    LOAD     #0
    PUSH
    LOAD     #0
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    $tmp$
    LOAD     @$tmp$
    STORE    system_in_buffer
    LOAD     #1
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
    LOAD     #0
    LOAD     #1
    PUSH
    LOAD     #0
    STORE    $tmp$
    POP
    ADD      $tmp$
    PUSH
    LOAD     system_out_buffer
    STORE    $tmp$
    POP
    STORE    $tmp_address$
    LOAD     $tmp$
    STORE    @$tmp_address$
    LOAD     #0
    STORE    system_out_ready
    POP
    STORE    $tmp_address$
    POP
    STORE    $tmp$
    IRET
end_1:
    JUMP     end_2
$func_is_digit:
    LOAD     #0
    PUSH
    LOAD     #0
    STORE    [1]
    LOAD     [3]
    PUSH
    LOAD     #48
    STORE    $tmp$
    POP
    CMP      $tmp$
    BGE      lefteq_true_5
    LOAD     #0
    JUMP     end_6
lefteq_true_5:
    LOAD     #1
end_6:
    CMP      #0
    BEQ      if_false_3
    LOAD     [3]
    PUSH
    LOAD     #57
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      lefteq_true_9
    BGE      lefteq_false_10
lefteq_true_9:
    LOAD     #1
    JUMP     end_11
lefteq_false_10:
    LOAD     #0
end_11:
    CMP      #0
    BEQ      if_false_7
    LOAD     #1
    STORE    [1]
    JUMP     end_8
if_false_7:
end_8:
    JUMP     end_4
if_false_3:
end_4:
    LOAD     [1]
    STORE    $tmp$
    POP
    LOAD     $tmp$
    RET
end_2:
    JUMP     end_12
$func_number_length:
    LOAD     #0
    LOAD     #1
    STORE    length
    LOAD     [2]
    PUSH
    LOAD     #0
    STORE    $tmp$
    POP
    CMP      $tmp$
    BGE      right_false_15
    LOAD     #1
    JUMP     end_16
right_false_15:
    LOAD     #0
end_16:
    CMP      #0
    BEQ      if_false_13
    LOAD     #2
    STORE    length
    JUMP     end_14
if_false_13:
end_14:
loop_17:
    LOAD     [2]
    PUSH
    LOAD     #10
    STORE    $tmp$
    POP
    CMP      $tmp$
    BGE      lefteq_true_19
    LOAD     #0
    JUMP     end_20
lefteq_true_19:
    LOAD     #1
end_20:
    CMP      #0
    BEQ      end_18
    LOAD     [2]
    PUSH
    LOAD     #10
    STORE    $tmp$
    POP
    DIV      $tmp$
    STORE    [2]
    LOAD     length
    PUSH
    LOAD     #1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    length
    JUMP     loop_17
end_18:
loop_21:
    LOAD     [2]
    PUSH
    LOAD     #-10
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      lefteq_true_23
    BGE      lefteq_false_24
lefteq_true_23:
    LOAD     #1
    JUMP     end_25
lefteq_false_24:
    LOAD     #0
end_25:
    CMP      #0
    BEQ      end_22
    LOAD     [2]
    PUSH
    LOAD     #10
    STORE    $tmp$
    POP
    DIV      $tmp$
    STORE    [2]
    LOAD     length
    PUSH
    LOAD     #1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    length
    JUMP     loop_21
end_22:
    LOAD     length
    RET
end_12:
    LOAD     ?input_str_26
    STORE    $tmp_address$
    LOAD     #32
    STORE    $tmp$
input_loop_27:
    LOAD     $tmp$
    CMP      #0
    BEQ      input_loop_27_end
in_nbr_wait_28:
    LOAD     system_in_ready
    CMP      #0
    BEQ      in_nbr_wait_28
    LOAD     system_in_buffer
    PUSH
    LOAD     #0
    STORE    system_in_ready
    POP
    STORE    @$tmp_address$
    LOAD     $tmp_address$
    ADD      #1
    STORE    $tmp_address$
    LOAD     $tmp$
    SUB      #1
    STORE    $tmp$
    JUMP     input_loop_27
input_loop_27_end:
    LOAD     ?input_str_26
    STORE    fmt
    LOAD     #0
    STORE    i
loop_29:
    LOAD     fmt
    PUSH
    LOAD     i
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    $tmp$
    LOAD     @$tmp$
    PUSH
    LOAD     #0
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      not_equal_false_32
    JUMP     not_equal_true_31
not_equal_false_32:
    LOAD     #0
    JUMP     end_33
not_equal_true_31:
    LOAD     #1
end_33:
    CMP      #0
    BEQ      end_30
    LOAD     fmt
    PUSH
    LOAD     i
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    $tmp$
    LOAD     @$tmp$
    STORE    c
    LOAD     c
    PUSH
    LOAD     #37
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
    LOAD     @$tmp$
    PUSH
    LOAD     #45
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
    BEQ      if_false_39
    LOAD     #1
    STORE    left
    LOAD     j
    PUSH
    LOAD     #1
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
    LOAD     @$tmp$
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
    BEQ      end_45
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
    LOAD     @$tmp$
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
    JUMP     loop_44
end_45:
    LOAD     fmt
    PUSH
    LOAD     j
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    $tmp$
    LOAD     @$tmp$
    PUSH
    LOAD     #100
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
in_nbr_wait_54:
    LOAD     system_in_ready
    CMP      #0
    BEQ      in_nbr_wait_54
    LOAD     system_in_buffer
    PUSH
    LOAD     #0
    STORE    system_in_ready
    POP
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
    BEQ      equal_true_57
    JUMP     equal_false_58
equal_true_57:
    LOAD     #1
    JUMP     end_59
equal_false_58:
    LOAD     #0
    JUMP     end_59
end_59:
    CMP      #0
    BEQ      if_false_55
    LOAD     spaces
repeat_check_60:
    CMP      #0
    BEQ      end_62
    BGE      repeat_loop_61
    JUMP     end_62
repeat_loop_61:
    PUSH
wait_63:
    LOAD     system_out_ready
    CMP      #0
    BEQ      wait_63_end
    JUMP     wait_63
wait_63_end:
    LOAD     #32
    STORE    system_out_buffer
    LOAD     #1
    STORE    system_out_ready
    POP
    SUB      #1
    JUMP     repeat_check_60
end_62:
    JUMP     end_56
if_false_55:
end_56:
wait_64:
    LOAD     system_out_ready
    CMP      #0
    BEQ      wait_64_end
    JUMP     wait_64
wait_64_end:
    LOAD     number
    STORE    system_out_buffer
    LOAD     #1
    STORE    system_out_ready
    LOAD     left
    PUSH
    LOAD     #1
    STORE    $tmp$
    POP
    CMP      $tmp$
    BEQ      equal_true_67
    JUMP     equal_false_68
equal_true_67:
    LOAD     #1
    JUMP     end_69
equal_false_68:
    LOAD     #0
    JUMP     end_69
end_69:
    CMP      #0
    BEQ      if_false_65
    LOAD     spaces
repeat_check_70:
    CMP      #0
    BEQ      end_72
    BGE      repeat_loop_71
    JUMP     end_72
repeat_loop_71:
    PUSH
wait_73:
    LOAD     system_out_ready
    CMP      #0
    BEQ      wait_73_end
    JUMP     wait_73
wait_73_end:
    LOAD     #32
    STORE    system_out_buffer
    LOAD     #1
    STORE    system_out_ready
    POP
    SUB      #1
    JUMP     repeat_check_70
end_72:
    JUMP     end_66
if_false_65:
end_66:
    LOAD     j
    PUSH
    LOAD     #1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    i
    JUMP     end_50
if_false_49:
wait_74:
    LOAD     system_out_ready
    CMP      #0
    BEQ      wait_74_end
    JUMP     wait_74
wait_74_end:
    LOAD     c
    STORE    system_out_buffer
    LOAD     #1
    STORE    system_out_ready
    LOAD     i
    PUSH
    LOAD     #1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    i
end_50:
    JUMP     end_35
if_false_34:
wait_75:
    LOAD     system_out_ready
    CMP      #0
    BEQ      wait_75_end
    JUMP     wait_75
wait_75_end:
    LOAD     c
    STORE    system_out_buffer
    LOAD     #1
    STORE    system_out_ready
    LOAD     i
    PUSH
    LOAD     #1
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    i
end_35:
    JUMP     loop_29
end_30:
    HALT
