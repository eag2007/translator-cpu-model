system_out_buffer        .word ?
system_in_ready          .word ?
$tmp$                    .word ?
system_in_buffer         .word ?
text                     .word ?
$tmp_address$            .word ?
number                   .word ?
input_str_3:
.byte                    0
.byte                    0
.byte                    0
.byte                    0
_start:
    LOAD     #0
    STORE    system_in_buffer
    LOAD     #0
    STORE    system_in_ready
    LOAD     #0
    STORE    system_out_buffer
    JUMP     end_0
$func_irq_input:
    LOAD     #0
    LOAD     #0
    PUSH
    LOAD     #0
    MUL      #4
    STORE    $tmp$
    POP
    ADD      $tmp$
    STORE    $tmp$
    LOAD     @$tmp$
    STORE    system_in_buffer
    LOAD     #1
    STORE    system_in_ready
    IRET
end_0:
    JUMP     end_1
$func_irq_output:
    LOAD     #0
    LOAD     #4
    PUSH
    LOAD     #0
    MUL      #4
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
    IRET
end_1:
in_nbr_wait_2:
    LOAD     system_in_ready
    CMP      #0
    BEQ      in_nbr_wait_2
    LOAD     system_in_buffer
    PUSH
    LOAD     #0
    STORE    system_in_ready
    POP
    STORE    number
    LOAD     ?input_str_3
    STORE    $tmp_address$
    LOAD     #3
    STORE    $tmp$
input_loop_4:
    LOAD     $tmp$
    CMP      #0
    BEQ      input_loop_4_end
in_nbr_wait_5:
    LOAD     system_in_ready
    CMP      #0
    BEQ      in_nbr_wait_5
    LOAD     system_in_buffer
    PUSH
    LOAD     #0
    STORE    system_in_ready
    POP
    STORE.b  @$tmp_address$
    LOAD     $tmp_address$
    ADD      #1
    STORE    $tmp_address$
    LOAD     $tmp$
    SUB      #1
    STORE    $tmp$
    JUMP     input_loop_4
input_loop_4_end:
    LOAD     ?input_str_3
    STORE    text
    HALT
