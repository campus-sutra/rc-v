# RC-V instructions and the assembler

RC-V runs a subset of **RV32I**, the base RISC-V instruction set: 32 registers of 32
bits, every instruction 32 bits long.

## Registers and the calling convention

| Register | Name | Use | Kept across a call? |
|---|---|---|---|
| x0 | zero | always 0 | - |
| x1 | ra | return address | no |
| x2 | sp | stack pointer (starts at 0x0001_4000, grows down) | **yes** |
| x5-x7, x28-x31 | t0-t6 | temporaries | no |
| x8-x9, x18-x27 | s0-s11 | saved registers | **yes** |
| x10-x17 | a0-a7 | arguments and results | no |

A subroutine that uses s registers, or calls another subroutine, saves them (and ra) on
the stack first:

```asm
p17_main:
        addi    sp, sp, -8          # make room for two words
        sw      ra, 4(sp)
        sw      s0, 0(sp)
        ...                          # your code; call rcv_puts etc.
        lw      s0, 0(sp)
        lw      ra, 4(sp)
        addi    sp, sp, 8
        ret
```

## The instructions

| Kind | Instructions | Example |
|---|---|---|
| Arithmetic / logic, registers | add sub and or xor sll srl sra slt sltu | `add a0, a1, a2` |
| Arithmetic / logic, immediate (12-bit signed) | addi andi ori xori slti sltiu slli srli srai | `addi sp, sp, -16` |
| Upper immediate | lui auipc | `lui a0, 0x12345` |
| Loads | lw lb lbu | `lw a0, 8(sp)` |
| Stores | sw sb | `sb a1, 0(t0)` |
| Branches | beq bne blt bge bltu bgeu | `blt a0, a1, p17_less` |
| Jumps | jal jalr | `jal ra, p17_sub` |
| System | csrrw csrrs csrrc ecall mret | `csrrw t0, mtvec, t1` |

Not in RC-V: halfword loads/stores (lh, lhu, sh), multiply/divide (there is a multiplier
device and the library has rcv_umul / rcv_udiv), fence, ebreak, and the CSR immediate
forms (csrrwi, csrrsi, csrrci). Using one of them gives an illegal-instruction trap.

## Pseudo-instructions the assembler understands

| Write | Means |
|---|---|
| `li rd, value` | load any 32-bit constant (always 2 instructions) |
| `la rd, label` | load the address of a label (lui + addi) |
| `mv rd, rs` | addi rd, rs, 0 |
| `not rd, rs` / `neg rd, rs` | xori rd, rs, -1 / sub rd, x0, rs |
| `seqz rd, rs` / `snez rd, rs` | rd = (rs == 0) / rd = (rs != 0) |
| `j label` / `jr rs` / `ret` | jump / jump to register / return (jalr x0, 0(ra)) |
| `call label` | jal ra, label |
| `nop` | addi x0, x0, 0 |
| `beqz bnez bltz bgez blez bgtz rs, label` | compare with zero |
| `bgt ble bgtu bleu rs, rt, label` | swapped-operand branches |
| `csrr rd, csr` / `csrw csr, rs` / `csrs csr, rs` / `csrc csr, rs` | CSR access (register operands only: `li t0, 8` then `csrs mstatus, t0`) |

## Directives

| Directive | Meaning |
|---|---|
| `.text` | code (in ROM). Every file starts in `.text`. |
| `.rodata` | constants (also in ROM); finish with `.align 2` before more code |
| `.data` | variables in RAM, given initial values (copied from ROM at start-up) |
| `.word 1, 2, label` | 32-bit values (must be word aligned) |
| `.byte 65, 'B'` | bytes |
| `.ascii "text"` / `.asciz "text"` (= `.string`) | characters, `.asciz` adds a 0 byte; `\n \t \0 \\ \"` work |
| `.space 40` | 40 zero bytes |
| `.align 2` | move to the next multiple of 4 bytes |
| `.equ p17_SIZE, 20` | a named constant (name must start with your prefix) |

Numbers: `42`, `-7`, `0x2A`, `0b101010`, `'A'`. Comments start with `#`.
Device registers have names: `TIMER_COUNT`, `UART_TXDATA`, `KBD_RXSTATUS`, `MUL_RESULT`, ...
(see docs/ARCHITECTURE.md), and the CSRs are `mstatus mtvec mscratch mepc mcause`.

## The library (`sw/lib/rcv_lib.s`)

| Routine | Does |
|---|---|
| `rcv_putc(a0)` | print one character |
| `rcv_puts(a0 = address)` | print a 0-terminated string |
| `rcv_newline()` | print `\n` |
| `rcv_getc() → a0` | wait for a key and return it |
| `rcv_print_dec(a0)` / `rcv_print_udec(a0)` | print a signed / unsigned decimal number |
| `rcv_print_hex(a0)` | print 8 hex digits |
| `rcv_read_line(a0 = buffer, a1 = size) → a0 = length` | read a line (without the newline) |
| `rcv_read_dec() → a0` / `rcv_read_hex() → a0` | read a number (skips spaces and newlines first) |
| `rcv_udiv(a0, a1) → a0 quotient, a1 remainder` | unsigned division |
| `rcv_umul(a0, a1) → a0` | multiplication (low 32 bits) |

## How a program is run

`crt0.s` copies the initial data into RAM, sets `sp`, installs a default trap handler
(which prints `[trap mcause=... mepc=...]`), and calls `main`. For your package, `main`
calls `pNN_main`, checks that sp and the s registers came back unchanged, and halts.
In the class ROM, a menu calls every student's `pNN_main` in turn.
