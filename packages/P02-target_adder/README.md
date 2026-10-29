# P02 - Branch-target adder (carry look-ahead)

**Group:** A. Arithmetic and logic · **Syllabus focus:** Unit 2 (Digital components), Unit 3 (Data representation)
**Work:** hardware ●●● + program ●○○ = the same total as every other package

Computes pc + immediate for branches and jal, using carry look-ahead instead of a ripple chain.

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P02.dig` | your circuit in Digital |
| `p02_target_adder.v` | the same block in Verilog |
| `p02.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P02.dig`)

8-bit version from two 4-bit carry look-ahead blocks (generate/propagate logic, C1..C4 equations). No ripple chain inside a block.

| Direction | Name | Bits |
|---|---|---|
| input | `a` | 8 |
| input | `b` | 8 |
| output | `y` | 8 |

Allowed parts: And, Or, Not, NAnd, NOr, XOr, XNOr + wiring parts. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p02_target_adder.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `a` | 32 |
| input | `b` | 32 |
| output | `y` | 32 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p02_target_adder.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p02.s`)

# P02 program: Sum 1 to N  (●○○)

Read a number N (1 or more) and print 1 + 2 + ... + N. Use a counting loop (do not use the formula N(N+1)/2).
Output: one line `sum = <value>`.

Example input:
```
10
```
Output:
```
sum = 55
```

You may use the library routines: rcv_read_dec, rcv_print_dec, rcv_puts, rcv_newline.

Your program is a subroutine: it starts at `p02_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **AUIPC**;
your review partners (E2) are P01 (ALU adder/subtractor) and P03 (PC incrementer).
