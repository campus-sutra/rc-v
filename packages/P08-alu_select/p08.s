        sub     a0, zero, a0
p08_pret:
        ret

        .rodata
p08_bad:
        .asciz  "bad operator\n"
        .align  2
