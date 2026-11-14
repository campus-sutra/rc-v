# P30 program - String table in ROM
# See README.md for the task.

    .section .text
    .globl p30_main
p30_main:
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    sw s1, 4(sp)
    sw s2, 0(sp)

p30_loop:
    jal ra, rcv_read_dec
    mv s1, a0
    li t0, 9
    beq s1, t0, p30_done

    li t0, 4
    bgtu s1, t0, p30_invalid

    # Valid 0-4: load string pointer from table
    la t0, p30_table
    slli t1, s1, 2
    add t0, t0, t1
    lw s0, 0(t0)
    mv s2, s0

    # print "string "
    la a0, p30_prefix
    jal ra, rcv_puts

    # print index in decimal
    mv a0, s1
    jal ra, rcv_print_udec

    # print ": "
    la a0, p30_mid
    jal ra, rcv_puts

    # print string text
    mv a0, s2
    jal ra, rcv_puts

    # print " (offset "
    la a0, p30_off_pre
    jal ra, rcv_puts

    # offset = string_ptr - first_string_ptr
    la t0, p30_str0
    sub a0, s2, t0
    jal ra, rcv_print_hex

    # print ")\n"
    la a0, p30_off_post
    jal ra, rcv_puts
    j p30_loop

p30_invalid:
    la a0, p30_nosuch
    jal ra, rcv_puts
    j p30_loop

p30_done:
    lw s2, 0(sp)
    lw s1, 4(sp)
    lw s0, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
    ret

    .section .rodata
    .align 2
p30_prefix:
    .asciz "string "
p30_mid:
    .asciz ": "
p30_off_pre:
    .asciz " (offset "
p30_off_post:
    .asciz ")\n"
p30_nosuch:
    .asciz "no such string\n"

    .align 2
p30_table:
    .word p30_str0
    .word p30_str1
    .word p30_str2
    .word p30_str3
    .word p30_str4
p30_str0:
    .asciz "ROM"
p30_str1:
    .asciz "RAM"
p30_str2:
    .asciz "UART"
p30_str3:
    .asciz "KEYBOARD"
p30_str4:
    .asciz "TIMER"
    .align 2
