# P03 - PC incrementer

**Group:** A. Arithmetic and logic · **Syllabus focus:** Unit 2 (Digital components)
**Work:** hardware ●○○ + program ●●● = the same total as every other package

pc + 4, the address of the next instruction.

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P03.dig` | your circuit in Digital |
| `p03_pc_inc.v` | the same block in Verilog |
| `p03.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P03.dig`)

8-bit version from half adders. Notice bits 0 and 1 never change: why?

| Direction | Name | Bits |
|---|---|---|
| input | `pc` | 8 |
| output | `pc4` | 8 |

Allowed parts: And, Or, Not, NAnd, NOr, XOr, XNOr + wiring parts. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p03_pc_inc.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `pc` | 32 |
| output | `pc4` | 32 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p03_pc_inc.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p03.s`)

# P03 program: Bubble sort  (●●●)

Read signed decimal numbers, one per line, until the number 0 (0 is not part of the data; at most 20 numbers come before it). Store them in an array in RAM (`.data` + `.space`), sort the array ascending with bubble sort, then print it.
Output: one line `sorted:` followed by each number with one space in front of it, e.g. `sorted: -4 3 12`.

Example input:
```
5
3
9
1
0
```
Output:
```
sorted: 1 3 5 9
```

You may use the library routines: rcv_read_dec, rcv_print_dec, rcv_puts, rcv_putc, rcv_newline.
This exercises your block: walking through the array adds 4 to an address again and again, just like the PC incrementer.

Your program is a subroutine: it starts at `p03_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **JAL**;
your review partners (E2) are P02 (Branch-target adder (carry look-ahead)) and P04 (ALU logic unit).
