# P51 - Four-lane vector unit (mini GPU)

**Group:** G. Measurement and support devices · **Syllabus focus:** Unit 3 (Data representation), Unit 5 (Processors)
**Work:** hardware ●○○ + program ●●● = the same total as every other package

Slot 9: A, B, SUM, MAX, SUB treat each word as four 8-bit lanes and work on all lanes at once, the idea behind GPUs. It is I/O device slot 9 (registers at 0x00020240; register 15 must read 51, the package number).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P51.dig` | your circuit in Digital |
| `p51_simd_unit.v` | the same block in Verilog |
| `p51.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P51.dig`)

2 lanes of 4 bits: per-lane adders and comparators (Add/Comparator parts allowed).

| Direction | Name | Bits |
|---|---|---|
| input | `a` | 8 |
| input | `b` | 8 |
| output | `sum` | 8 |
| output | `max` | 8 |

Allowed parts: all of the above + Add, Sub, Comparator, Neg. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p51_simd_unit.v`)

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
The test bench is `tests/tb_p51_simd_unit.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p51.s`)

# P51 program: Brighten pixels with SIMD

Read 8 pixel values (0..255), then a brightness b and a threshold t (0..255). Pack the pixels 4 per word
(pixel 0 in bits 7..0), and b and t into all four lanes (like b * 0x01010101). For each of the two words:
SIMD_A = pixels, SIMD_B = b, read SIMD_SUM; then SIMD_A = that sum, SIMD_B = t, read SIMD_MAX. Unpack and print
`sum:` and `max:`, each followed by the 8 values (one space before each). Lanes wrap around (250 + 10 = 4),
exactly like the hardware.

Write `p51_main` as a subroutine ending with `ret`; every label starts with `p51_`; keep sp and s0-s11.

Example input:
```
10 20 30 40 200 250 0 128
10
50
```
Output:
```
sum: 20 30 40 50 210 4 10 138
max: 50 50 50 50 210 50 50 138
```
Library: rcv_read_dec, rcv_puts, rcv_putc, rcv_print_dec, rcv_newline.

Your block: one SUM or MAX read does four lane operations of your SIMD unit at once.

Your program is a subroutine: it starts at `p51_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **BGEU**;
your review partners (E2) are P50 (Multiplier (shift and add)) and P52 (Binary-to-BCD converter).
