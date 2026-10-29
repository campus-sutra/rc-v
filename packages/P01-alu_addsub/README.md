# P01 - ALU adder/subtractor

**Group:** A. Arithmetic and logic · **Syllabus focus:** Unit 1 (Digital logic circuits), Unit 2 (Digital components), Unit 3 (Data representation)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

Adds a+b, or a-b when sub=1 (a + ~b + 1). c = carry out, v = signed overflow.

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P01.dig` | your circuit in Digital |
| `p01_alu_addsub.v` | the same block in Verilog |
| `p01.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P01.dig`)

8-bit version. Build a full adder from gates first, then chain eight of them; XOR gates on b make the subtractor.

| Direction | Name | Bits |
|---|---|---|
| input | `a` | 8 |
| input | `b` | 8 |
| input | `sub` | 1 |
| output | `y` | 8 |
| output | `c` | 1 |
| output | `v` | 1 |

Allowed parts: And, Or, Not, NAnd, NOr, XOr, XNOr + wiring parts. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p01_alu_addsub.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `a` | 32 |
| input | `b` | 32 |
| input | `sub` | 1 |
| output | `y` | 32 |
| output | `c` | 1 |
| output | `v` | 1 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p01_alu_addsub.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p01.s`)

# P01 program: Sum, difference and overflow  (●●○)

Read two signed decimal numbers A and B (one per line). Print A+B and A-B, and for each one say whether it overflowed 32 bits.
Detect overflow with the sign rule (adding two numbers of the same sign gives a result of the other sign; for A-B the signs of A and B differ and the result's sign differs from A's). Do not use a wider register or a library routine for this.
Output: two lines `A+B = <sum> (overflow)` or `A+B = <sum> (no overflow)`, then the same with `A-B = `.

Example input:
```
2147483647
1
```
Output:
```
A+B = -2147483648 (overflow)
A-B = 2147483646 (no overflow)
```

You may use the library routines: rcv_read_dec, rcv_print_dec, rcv_puts.
This exercises your block: your adder's `v` output computes exactly this overflow rule.

Your program is a subroutine: it starts at `p01_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **LUI**;
your review partners (E2) are P10 (ALU control) and P02 (Branch-target adder (carry look-ahead)).
