# P07 - Less-than unit (signed and unsigned)

**Group:** A. Arithmetic and logic · **Syllabus focus:** Unit 1 (Digital logic circuits), Unit 3 (Data representation)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

lt = a < b as signed (2's complement) numbers, ltu = a < b as unsigned numbers.

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P07.dig` | your circuit in Digital |
| `p07_slt_unit.v` | the same block in Verilog |
| `p07.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P07.dig`)

4-bit version from gates: design a 1-bit comparator cell with a K-map, cascade it, then fix the sign bit for the signed result.

| Direction | Name | Bits |
|---|---|---|
| input | `a` | 4 |
| input | `b` | 4 |
| output | `lt` | 1 |
| output | `ltu` | 1 |

Allowed parts: And, Or, Not, NAnd, NOr, XOr, XNOr + wiring parts. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p07_slt_unit.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `a` | 32 |
| input | `b` | 32 |
| output | `lt` | 1 |
| output | `ltu` | 1 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p07_slt_unit.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p07.s`)

# P07 program: Signed and unsigned compare  (●●○)

Read two signed decimal numbers A and B (one per line). Use `slt` and `sltu` to find out whether A < B as signed numbers and as unsigned numbers.
Output: two lines `signed   A < B: yes` (or `no`) and `unsigned A < B: yes` (or `no`).

Example input:
```
-1
1
```
Output:
```
signed   A < B: yes
unsigned A < B: no
```

You may use the library routines: rcv_read_dec, rcv_puts.
This exercises your block: these are the `lt` and `ltu` outputs of your less-than unit.

Your program is a subroutine: it starts at `p07_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **BLT**;
your review partners (E2) are P06 (Right barrel shifter) and P08 (ALU result selector).
