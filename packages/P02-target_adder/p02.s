# P02 program - sum 1 to N
        .text
p02_main:
        addi    sp, sp, -16
        sw      ra, 12(sp)
        sw      s0, 8(sp)
        sw      s1, 4(sp)
        sw      s2, 0(sp)

        jal     ra, rcv_read_dec
        mv      s0, a0
        li      s1, 0
        li      s2, 1

p02_loop:
        bgt     s2, s0, p02_done
        add     s1, s1, s2
        addi    s2, s2, 1
        j       p02_loop

p02_done:
        la      a0, p02_msg
        jal     ra, rcv_puts
        mv      a0, s1
        jal     ra, rcv_print_dec
        jal     ra, rcv_newline

        lw      s2, 0(sp)
        lw      s1, 4(sp)
        lw      s0, 8(sp)
        lw      ra, 12(sp)
        addi    sp, sp, 16
        ret

        .rodata
p02_msg:
        .asciz  "sum = "
        .align  2
