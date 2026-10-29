# P20 - Immediate selector

**Group:** C. Decode and control · **Syllabus focus:** Unit 4 (Basic computer organisation)
**Work:** hardware ●○○ + program ●●● = the same total as every other package

immsel 0 = I, 1 = S, 2 = B, 3 = U, 4 = J; others give 0.

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P20.dig` | your circuit in Digital |
| `p20_imm_select.v` | the same block in Verilog |
| `p20.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P20.dig`)

4-bit version with a multiplexer.

| Direction | Name | Bits |
|---|---|---|
| input | `immsel` | 3 |
| input | `imm_i` | 4 |
| input | `imm_s` | 4 |
| input | `imm_b` | 4 |
| input | `imm_u` | 4 |
| input | `imm_j` | 4 |
| output | `imm` | 4 |

Allowed parts: gates + Multiplexer, Demultiplexer, Decoder, PriorityEncoder. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p20_imm_select.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `immsel` | 3 |
| input | `imm_i` | 32 |
| input | `imm_s` | 32 |
| input | `imm_b` | 32 |
| input | `imm_u` | 32 |
| input | `imm_j` | 32 |
| output | `imm` | 32 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p20_imm_select.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p20.s`)

# P20 program: Statistics of a list  (●●●)

Read up to 20 positive decimal numbers, one per line, ending with 0. Store them in a RAM array first, then go through the array to find count, sum, integer mean (sum / count with rcv_udiv) and maximum.
Output: four lines `count: <n>`, `sum: <n>`, `mean: <n>`, `max: <n>`. If there are no numbers print only `count: 0`.

Example input:
```
4
8
15
16
23
42
0
```
Output:
```
count: 6
sum: 108
mean: 18
max: 42
```

You may use the library routines: rcv_read_dec, rcv_print_udec, rcv_udiv, rcv_puts, rcv_newline.

Your program is a subroutine: it starts at `p20_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **ORI**;
your review partners (E2) are P19 (Immediate generator B/J/U) and P21 (Opcode class decoder).
