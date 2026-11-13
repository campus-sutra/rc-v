# P07 program - see README.md for the task.
# Rules: start at the label p07_main and finish with ret; every label you
# create starts with p07_ ; save ra (and any s registers you use) on the stack.
# You may call the library routines in sw/lib/rcv_lib.s (rcv_puts, rcv_getc, ...).

        # P07 program - see README.md for the task.
# Rules: start at the label p07_main and finish with ret; every label you
# create starts with p07_ ; save ra (and any s registers you use) on the stack.
# You may call the library routines in sw/lib/rcv_lib.s (rcv_puts, rcv_getc, ...).

        .text
p07_main:
        addi    sp, sp, -12
        sw      ra, 8(sp)
        sw      s0, 4(sp)
        sw      s1, 0(sp)

        call    rcv_read_dec
        mv      s0, a0
        call    rcv_read_dec
        mv      s1, a0

        slt     t0, s0, s1
        beq     t0, zero, p07_s_no
        la      a0, p07_str_s_yes
        call    rcv_puts
        j       p07_check_u

p07_s_no:
        la      a0, p07_str_s_no
        call    rcv_puts

p07_check_u:
        sltu    t0, s0, s1
        beq     t0, zero, p07_u_no
        la      a0, p07_str_u_yes
        call    rcv_puts
        j       p07_done

p07_u_no:
        la      a0, p07_str_u_no
        call    rcv_puts

p07_done:
        lw      s1, 0(sp)
        lw      s0, 4(sp)
        lw      ra, 8(sp)
        addi    sp, sp, 12
        ret

        .rodata
p07_str_s_yes:
        .asciz  "signed   A < B: yes\n"
p07_str_s_no:
        .asciz  "signed   A < B: no\n"
p07_str_u_yes:
        .asciz  "unsigned A < B: yes\n"
p07_str_u_no:
        .asciz  "unsigned A < B: no\n"
        .align  2

