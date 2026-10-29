# crt0.s - start-up code (owned by shared/, do not edit)
# Copies the initial data from ROM to RAM, sets up the stack and a default
# trap handler, calls main, then halts.
        .text
_start:
        la      t0, _data_load          # source in ROM
        la      t1, _data_start         # destination in RAM
        la      t2, _data_end
rcv_copy:
        bgeu    t1, t2, rcv_copied
        lw      t3, 0(t0)
        sw      t3, 0(t1)
        addi    t0, t0, 4
        addi    t1, t1, 4
        j       rcv_copy
rcv_copied:
        li      sp, STACK_TOP
        la      t0, rcv_default_trap
        csrw    mtvec, t0
        call    main
        li      t0, HALT_HALT
        sw      zero, 0(t0)
rcv_stop:
        j       rcv_stop

# An unexpected trap prints "[trap mcause=XXXXXXXX mepc=XXXXXXXX]" and halts.
rcv_default_trap:
        la      a0, rcv_trap_msg1
        call    rcv_puts
        csrr    a0, mcause
        call    rcv_print_hex
        la      a0, rcv_trap_msg2
        call    rcv_puts
        csrr    a0, mepc
        call    rcv_print_hex
        li      a0, ']'
        call    rcv_putc
        call    rcv_newline
        li      t0, HALT_HALT
        sw      zero, 0(t0)
        j       rcv_stop

rcv_trap_msg1:  .asciz "[trap mcause="
rcv_trap_msg2:  .asciz " mepc="
        .align 2
