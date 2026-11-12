# P30 program - boot ROM string table lookup
        .text
p30_main:
        addi    sp, sp, -16
        sw      ra, 12(sp)
        sw      s0, 8(sp)
        sw      s1, 4(sp)
        sw      s2, 0(sp)

p30_loop:
        call    rcv_read_dec        # a0 = number typed
        li      t0, 9
        beq     a0, t0, p30_done    # 9 = stop
        mv      s0, a0              # s0 = index
        li      t0, 4
        bgtu    s0, t0, p30_none    # index above 4 (or negative)
        la      t1, p30_table
        slli    t2, s0, 2
        add     t1, t1, t2
        lw      s1, 0(t1)           # s1 = address of the string
        la      t3, p30_str0
        sub     s2, s1, t3          # s2 = offset from first string
        la      a0, p30_m1
        call    rcv_puts            # "string "
        mv      a0, s0
        call    rcv_print_udec      # the index
        la      a0, p30_m2
        call    rcv_puts            # ": "
        mv      a0, s1
        call    rcv_puts            # the text
        la      a0, p30_m3
        call    rcv_puts            # " (offset "
        mv      a0, s2
        call    rcv_print_hex       # 8 hex digits
        la      a0, p30_m4
        call    rcv_puts            # ")\n"
        j       p30_loop

p30_none:
        la      a0, p30_no
        call    rcv_puts
        j       p30_loop

p30_done:
        lw      ra, 12(sp)
        lw      s0, 8(sp)
        lw      s1, 4(sp)
        lw      s2, 0(sp)
        addi    sp, sp, 16
        ret

        .rodata
        .align  2
p30_table:
        .word   p30_str0, p30_str1, p30_str2, p30_str3, p30_str4
p30_str0: .asciz "ROM"
p30_str1: .asciz "RAM"
p30_str2: .asciz "UART"
p30_str3: .asciz "KEYBOARD"
p30_str4: .asciz "TIMER"
p30_m1:   .asciz "string "
p30_m2:   .asciz ": "
p30_m3:   .asciz " (offset "
p30_m4:   .asciz ")\n"
p30_no:   .asciz "no such string\n"
        .align  2
