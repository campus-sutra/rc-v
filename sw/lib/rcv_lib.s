# rcv_lib.s - the shared RC-V runtime library (owned by shared/, do not edit)
#
# Every routine follows the standard RISC-V calling convention:
#   arguments and results in a0-a7, ra = return address,
#   t0-t6 and a0-a7 may be changed, s0-s11 and sp are preserved.
#
#   rcv_putc(a0 = character)            wait until the terminal is ready, print
#   rcv_puts(a0 = address of string)    print a 0-terminated string
#   rcv_newline()                       print "\n"
#   rcv_getc() -> a0                    wait for a key, return it
#   rcv_print_dec(a0)                   print a signed decimal number
#   rcv_print_udec(a0)                  print an unsigned decimal number
#   rcv_print_hex(a0)                   print 8 hex digits (uppercase, no 0x)
#   rcv_read_line(a0 = buffer, a1 = size) -> a0 = length (newline not stored)
#   rcv_read_dec() -> a0                read a signed decimal number
#   rcv_read_hex() -> a0                read a hex number (with or without 0x)
#   rcv_udiv(a0, a1) -> a0 = a0 / a1, a1 = a0 % a1   (unsigned)
#   rcv_umul(a0, a1) -> a0 = low 32 bits of a0 * a1

        .text
rcv_putc:
        li      t0, UART_TXSTATUS
rcv_putc_wait:
        lw      t1, 0(t0)
        andi    t1, t1, 1
        beqz    t1, rcv_putc_wait
        li      t0, UART_TXDATA
        sw      a0, 0(t0)
        ret

rcv_newline:
        li      a0, 10
        j       rcv_putc

rcv_puts:
        addi    sp, sp, -8
        sw      ra, 4(sp)
        sw      s0, 0(sp)
        mv      s0, a0
rcv_puts_loop:
        lbu     a0, 0(s0)
        beqz    a0, rcv_puts_done
        call    rcv_putc
        addi    s0, s0, 1
        j       rcv_puts_loop
rcv_puts_done:
        lw      s0, 0(sp)
        lw      ra, 4(sp)
        addi    sp, sp, 8
        ret

rcv_getc:
        li      t0, KBD_RXSTATUS
rcv_getc_wait:
        lw      t1, 0(t0)
        andi    t1, t1, 1
        beqz    t1, rcv_getc_wait
        li      t0, KBD_RXDATA
        lw      a0, 0(t0)
        ret

# unsigned divide by shift-and-subtract (restoring division)
rcv_udiv:
        mv      t0, a0              # dividend -> quotient bits shift in here
        li      t1, 0               # remainder
        li      t2, 32
        beqz    a1, rcv_udiv_zero
rcv_udiv_loop:
        srli    t3, t0, 31
        slli    t1, t1, 1
        or      t1, t1, t3
        slli    t0, t0, 1
        bltu    t1, a1, rcv_udiv_next
        sub     t1, t1, a1
        ori     t0, t0, 1
rcv_udiv_next:
        addi    t2, t2, -1
        bnez    t2, rcv_udiv_loop
        mv      a0, t0
        mv      a1, t1
        ret
rcv_udiv_zero:
        li      a0, -1              # like RISC-V DIVU: x / 0 = all ones, remainder x
        mv      a1, t0
        ret

rcv_umul:
        li      t0, 0
rcv_umul_loop:
        andi    t1, a1, 1
        beqz    t1, rcv_umul_skip
        add     t0, t0, a0
rcv_umul_skip:
        slli    a0, a0, 1
        srli    a1, a1, 1
        bnez    a1, rcv_umul_loop
        mv      a0, t0
        ret

rcv_print_dec:
        bgez    a0, rcv_print_udec
        addi    sp, sp, -8
        sw      ra, 4(sp)
        sw      a0, 0(sp)
        li      a0, '-'
        call    rcv_putc
        lw      a0, 0(sp)
        lw      ra, 4(sp)
        addi    sp, sp, 8
        neg     a0, a0
rcv_print_udec:
        addi    sp, sp, -24
        sw      ra, 20(sp)
        sw      s0, 16(sp)
        mv      s0, sp              # digits are stored at 0..11(sp)
rcv_pud_loop:
        li      a1, 10
        call    rcv_udiv
        addi    a1, a1, '0'
        sb      a1, 0(s0)
        addi    s0, s0, 1
        bnez    a0, rcv_pud_loop
rcv_pud_out:
        addi    s0, s0, -1
        lbu     a0, 0(s0)
        call    rcv_putc
        bne     s0, sp, rcv_pud_out
        lw      s0, 16(sp)
        lw      ra, 20(sp)
        addi    sp, sp, 24
        ret

rcv_print_hex:
        addi    sp, sp, -12
        sw      ra, 8(sp)
        sw      s0, 4(sp)
        sw      s1, 0(sp)
        mv      s0, a0
        li      s1, 8
rcv_ph_loop:
        srli    a0, s0, 28
        slli    s0, s0, 4
        li      t0, 10
        blt     a0, t0, rcv_ph_digit
        addi    a0, a0, 7           # 'A' - '0' - 10
rcv_ph_digit:
        addi    a0, a0, '0'
        call    rcv_putc
        addi    s1, s1, -1
        bnez    s1, rcv_ph_loop
        lw      s1, 0(sp)
        lw      s0, 4(sp)
        lw      ra, 8(sp)
        addi    sp, sp, 12
        ret

rcv_read_line:
        addi    sp, sp, -16
        sw      ra, 12(sp)
        sw      s0, 8(sp)
        sw      s1, 4(sp)
        sw      s2, 0(sp)
        mv      s0, a0              # buffer
        addi    s1, a1, -1          # room for characters
        li      s2, 0               # length
rcv_rl_loop:
        call    rcv_getc
        li      t0, 10
        beq     a0, t0, rcv_rl_done
        li      t0, 13
        beq     a0, t0, rcv_rl_loop
        bge     s2, s1, rcv_rl_loop # buffer full: drop the character
        add     t0, s0, s2
        sb      a0, 0(t0)
        addi    s2, s2, 1
        j       rcv_rl_loop
rcv_rl_done:
        add     t0, s0, s2
        sb      zero, 0(t0)
        mv      a0, s2
        lw      s2, 0(sp)
        lw      s1, 4(sp)
        lw      s0, 8(sp)
        lw      ra, 12(sp)
        addi    sp, sp, 16
        ret

# reads optional spaces/newlines, an optional '-', then digits; the character
# after the number is consumed.
rcv_read_dec:
        addi    sp, sp, -16
        sw      ra, 12(sp)
        sw      s0, 8(sp)
        sw      s1, 4(sp)
rcv_rd_skip:
        call    rcv_getc
        li      t0, ' '
        beq     a0, t0, rcv_rd_skip
        li      t0, 10
        beq     a0, t0, rcv_rd_skip
        li      t0, 13
        beq     a0, t0, rcv_rd_skip
        li      s1, 0               # 1 if negative
        li      t0, '-'
        bne     a0, t0, rcv_rd_first
        li      s1, 1
        call    rcv_getc
rcv_rd_first:
        li      s0, 0
rcv_rd_loop:
        addi    t0, a0, -48
        li      t1, 10
        bgeu    t0, t1, rcv_rd_end
        slli    t1, s0, 3           # s0 * 10 = s0*8 + s0*2
        slli    t2, s0, 1
        add     s0, t1, t2
        add     s0, s0, t0
        call    rcv_getc
        j       rcv_rd_loop
rcv_rd_end:
        mv      a0, s0
        beqz    s1, rcv_rd_ret
        neg     a0, a0
rcv_rd_ret:
        lw      s1, 4(sp)
        lw      s0, 8(sp)
        lw      ra, 12(sp)
        addi    sp, sp, 16
        ret

rcv_read_hex:
        addi    sp, sp, -8
        sw      ra, 4(sp)
        sw      s0, 0(sp)
rcv_rh_skip:
        call    rcv_getc
        li      t0, ' '
        beq     a0, t0, rcv_rh_skip
        li      t0, 10
        beq     a0, t0, rcv_rh_skip
        li      t0, 13
        beq     a0, t0, rcv_rh_skip
        li      s0, 0
        li      t0, '0'
        bne     a0, t0, rcv_rh_loop
        call    rcv_getc            # a leading 0: maybe "0x"
        ori     t0, a0, 0x20
        li      t1, 'x'
        bne     t0, t1, rcv_rh_loop
        call    rcv_getc
rcv_rh_loop:
        addi    t0, a0, -48
        li      t1, 10
        bltu    t0, t1, rcv_rh_add
        ori     t0, a0, 0x20        # lower case
        addi    t0, t0, -97
        li      t1, 6
        bgeu    t0, t1, rcv_rh_end
        addi    t0, t0, 10
rcv_rh_add:
        slli    s0, s0, 4
        or      s0, s0, t0
        call    rcv_getc
        j       rcv_rh_loop
rcv_rh_end:
        mv      a0, s0
        lw      s0, 0(sp)
        lw      ra, 4(sp)
        addi    sp, sp, 8
        ret
