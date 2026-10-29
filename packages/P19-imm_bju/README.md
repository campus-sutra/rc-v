# P19 - Immediate generator B/J/U

**Group:** C. Decode and control · **Syllabus focus:** Unit 3 (Data representation), Unit 4 (Basic computer organisation)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

Branch (13-bit, even), jump (21-bit, even) and upper (20 bits << 12) immediates; the scrambled bit order of B and J must be put back together.

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P19.dig` | your circuit in Digital |
| `p19_imm_bju.v` | the same block in Verilog |
| `p19.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P19.dig`)

Full size, Splitters only.

| Direction | Name | Bits |
|---|---|---|
| input | `instr` | 32 |
| output | `imm_b` | 32 |
| output | `imm_j` | 32 |
| output | `imm_u` | 32 |

Allowed parts: Splitter, Tunnel, Const, Ground, VDD, Text, In, Out, Clock. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p19_imm_bju.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `instr` | 32 |
| output | `imm_b` | 32 |
| output | `imm_j` | 32 |
| output | `imm_u` | 32 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p19_imm_bju.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p19.s`)

# P19 program: Multiples of 7  (●●○)

Read N. Print every multiple of 7 from 7 up to N (find the next one by adding 7; no multiplication) and how many there were.
Output: `multiples:` followed by each number with one space in front, then a line `count: <n>`.

Example input:
```
30
```
Output:
```
multiples: 7 14 21 28
count: 4
```

You may use the library routines: rcv_read_dec, rcv_print_dec, rcv_putc, rcv_puts, rcv_newline.

Your program is a subroutine: it starts at `p19_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **XORI**;
your review partners (E2) are P18 (Immediate generator I/S) and P20 (Immediate selector).
