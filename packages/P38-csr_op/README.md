# P38 - CSR read-modify-write

**Group:** E. Traps and interrupts · **Syllabus focus:** Unit 4 (Basic computer organisation)
**Work:** hardware ●○○ + program ●●● = the same total as every other package

CSRRW(1): new_val = rs1. CSRRS(2): new_val = old | rs1. CSRRC(3): new_val = old & ~rs1. RS/RC with rs1 = x0 do not write.

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P38.dig` | your circuit in Digital |
| `p38_csr_op.v` | the same block in Verilog |
| `p38.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P38.dig`)

4-bit data version.

| Direction | Name | Bits |
|---|---|---|
| input | `funct3` | 3 |
| input | `rs1_val` | 4 |
| input | `rs1_idx` | 5 |
| input | `old` | 4 |
| output | `new_val` | 4 |
| output | `write` | 1 |

Allowed parts: gates + Multiplexer, Demultiplexer, Decoder, PriorityEncoder. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p38_csr_op.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `funct3` | 3 |
| input | `rs1_val` | 32 |
| input | `rs1_idx` | 5 |
| input | `old` | 32 |
| output | `new_val` | 32 |
| output | `write` | 1 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p38_csr_op.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p38.s`)

# P38 program: System calls with ecall

Install your own trap handler (save the old `mtvec`, write yours, restore it at the end). The handler implements
three services selected by a7: **1** print the signed number in a0, **2** print the string at address a0,
**3** read a signed number into a0. It gives back every register unchanged (except a0 for service 3), adds 4 to
`mepc` and returns with `mret`. Your main program uses **only ecall** for input and output: it reads two numbers
(service 3 twice) and prints `sum = <a+b>` and a newline (services 2, 1, 2).

Write `p38_main` as a subroutine ending with `ret`; every label starts with `p38_`; keep sp and s0-s11.

Example input:
```
12
30
```
Output:
```
sum = 42
```
Library: rcv_print_dec, rcv_puts, rcv_read_dec (only inside the handler).

Your block: every ecall uses your CSR operations: csrr/csrw on mtvec and mepc.

Your program is a subroutine: it starts at `p38_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **timer interrupt**;
your review partners (E2) are P37 (Control and status registers) and P39 (Trap controller).
