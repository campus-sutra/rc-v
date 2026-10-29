# P09 - Branch comparator

**Group:** A. Arithmetic and logic · **Syllabus focus:** Unit 1 (Digital logic circuits), Unit 3 (Data representation), Unit 4 (Basic computer organisation)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

take = 1 when the branch condition holds: BEQ(0) BNE(1) BLT(4) BGE(5) BLTU(6) BGEU(7).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P09.dig` | your circuit in Digital |
| `p09_branch_cmp.v` | the same block in Verilog |
| `p09.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P09.dig`)

4-bit version: equality from XNOR gates, signed/unsigned less-than, then select by funct3.

| Direction | Name | Bits |
|---|---|---|
| input | `a` | 4 |
| input | `b` | 4 |
| input | `funct3` | 3 |
| output | `take` | 1 |

Allowed parts: gates + Multiplexer, Demultiplexer, Decoder, PriorityEncoder. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p09_branch_cmp.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `a` | 32 |
| input | `b` | 32 |
| input | `funct3` | 3 |
| output | `take` | 1 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p09_branch_cmp.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p09.s`)

# P09 program: Maximum and minimum  (●●○)

Read signed decimal numbers, one per line, until 0 (0 is not part of the data). Print the largest and the smallest.
Output: `max = <value>` and `min = <value>` on two lines. If the first number is already 0, print only `no numbers`.

Example input:
```
5
-3
9
2
0
```
Output:
```
max = 9
min = -3
```

You may use the library routines: rcv_read_dec, rcv_print_dec, rcv_puts, rcv_newline.
This exercises your block: every comparison is a `blt`/`bge` decided by your branch comparator.

Your program is a subroutine: it starts at `p09_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **BLTU**;
your review partners (E2) are P08 (ALU result selector) and P10 (ALU control).
