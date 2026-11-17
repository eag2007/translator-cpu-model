system_out_ready         .word 0
$tmp_address$            .word 0
system_in_ready          .word 0
x                        .word 0
system_out_buffer        .word 0
system_in_buffer         .word 0
$tmp$                    .word 0
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
    LOADI    3
    STORE    x
    HALT
