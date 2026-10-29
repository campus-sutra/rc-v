# P59 program - see README.md for the task.
# Rules: start at the label p59_main and finish with ret; every label you
# create starts with p59_ ; save ra (and any s registers you use) on the stack.
# You may call the library routines in sw/lib/rcv_lib.s (rcv_puts, rcv_getc, ...).

        .text
p59_main:
        addi    sp, sp, -4
        sw      ra, 0(sp)

        # TODO: your program

        lw      ra, 0(sp)
        addi    sp, sp, 4
        ret

        .rodata
p59_msg:
        .asciz  "TODO\n"
        .align  2
