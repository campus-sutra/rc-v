# P35 program - see README.md for the task.
# Rules: start at the label p35_main and finish with ret; every label you
# create starts with p35_ ; save ra (and any s registers you use) on the stack.
# You may call the library routines in sw/lib/rcv_lib.s (rcv_puts, rcv_getc, ...).

        .text
p35_main:
        addi    sp, sp, -4
        sw      ra, 0(sp)

        # TODO: your program
         
.data
p35_array: .space 128

p35_msg1: .asciz "sum 1: "
p35_msg2: .asciz "sum 2: "

.text
.globl p35_main

p35_main:
    # Save return address and used saved registers
    addi sp, sp, -32
    sw ra, 28(sp)
    sw s0, 24(sp)
    sw s1, 20(sp)
    sw s2, 16(sp)
    sw s3, 12(sp)

    # Read k
    jal ra, rcv_read_dec
    mv s0, a0

    # s1 = array base address
    la s1, p35_array

    # Fill array: a[i] = k + i
    li s2, 0

p35_fill_loop:
    li t0, 32
    bge s2, t0, p35_first_start

    add t1, s0, s2
    slli t2, s2, 2
    add t2, s1, t2
    sw t1, 0(t2)

    addi s2, s2, 1
    j p35_fill_loop

    # First pass: sum the array
p35_first_start:
    li s2, 0
    li s3, 0

p35_first_loop:
    li t0, 32
    bge s2, t0, p35_print_first

    slli t1, s2, 2
    add t1, s1, t1
    lw t2, 0(t1)

    add s3, s3, t2
    addi s2, s2, 1
    j p35_first_loop

    # Print first sum
p35_print_first:
    la a0, p35_msg1
    jal ra, rcv_puts

    mv a0, s3
    jal ra, rcv_print_dec
    jal ra, rcv_newline

    # Second pass: read the same array again
    li s2, 0
    li s3, 0

p35_second_loop:
    li t0, 32
    bge s2, t0, p35_print_second

    slli t1, s2, 2
    add t1, s1, t1
    lw t2, 0(t1)

    add s3, s3, t2
    addi s2, s2, 1
    j p35_second_loop

    # Print second sum
p35_print_second:
    la a0, p35_msg2
    jal ra, rcv_puts

    mv a0, s3
    jal ra, rcv_print_dec
    jal ra, rcv_newline

    # Restore registers and return
    lw s3, 12(sp)
    lw s2, 16(sp)
    lw s1, 20(sp)
    lw s0, 24(sp)
    lw ra, 28(sp)
    addi sp, sp, 32

    ret

        lw      ra, 0(sp)
        addi    sp, sp, 4
        ret

        .rodata
p35_msg:
        .asciz  "TODO\n"
        .align  2
