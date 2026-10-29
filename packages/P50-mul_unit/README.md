# P50 - Multiplier (shift and add)

**Group:** G. Measurement and support devices · **Syllabus focus:** Unit 3 (Data representation), Unit 5 (Processors)
**Work:** hardware ●●● + program ●○○ = the same total as every other package

Slot 8: A, B, CTRL (write bit0 = start), STATUS bit0 busy, RESULT. Multiplies in 32 cycles, one bit of B per cycle. It is I/O device slot 8 (registers at 0x00020200; register 15 must read 50, the package number).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P50.dig` | your circuit in Digital |
| `p50_mul_unit.v` | the same block in Verilog |
| `p50.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P50.dig`)

4 x 4 bits in 4 cycles: accumulator, shift registers and an adder.

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `rst` | 1 |
| input | `start` | 1 |
| input | `a` | 4 |
| input | `b` | 4 |
| output | `result` | 8 |
| output | `busy` | 1 |

Allowed parts: all of the above + Add, Sub, Comparator, Neg. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p50_mul_unit.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `rst` | 1 |
| input | `sel` | 1 |
| input | `we` | 1 |
| input | `re` | 1 |
| input | `ridx` | 4 |
| input | `wdata` | 32 |
| output | `rdata` | 32 |

Clocked: everything changes on the rising edge of `clk`.
The test bench is `tests/tb_p50_mul_unit.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p50.s`)

# P50 program: Multiply with the MUL unit

Read A and B (signed). Write them to MUL_A and MUL_B, write 1 to MUL_CTRL, wait while MUL_STATUS bit 0 (busy)
is 1, read MUL_RESULT and print `product = <result as signed decimal>`.

Write `p50_main` as a subroutine ending with `ret`; every label starts with `p50_`; keep sp and s0-s11.

Example input:
```
1234 -56
```
Output:
```
product = -69104
```
Library: rcv_read_dec, rcv_puts, rcv_print_dec, rcv_newline.

Your block: your multiplier does the work in 32 cycles while the program polls it.

Your program is a subroutine: it starts at `p50_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **BLTU**;
your review partners (E2) are P49 (Performance counters) and P51 (Four-lane vector unit (mini GPU)).
