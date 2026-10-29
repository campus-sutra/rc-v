# P35 - Cache tag store

**Group:** D. Memory and bus · **Syllabus focus:** Unit 6 (Memory and I/O)
**Work:** hardware ●●● + program ●○○ = the same total as every other package

Direct-mapped cache directory: 16 lines of 16 bytes (index = addr[7:4], tag = addr[31:8]). hit = the line is valid and its tag matches (only while access=1). Every access fills the line.

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P35.dig` | your circuit in Digital |
| `p35_cache_tags.v` | the same block in Verilog |
| `p35.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P35.dig`)

Scaled: 4 lines (index = addr[3:2]), tag = addr[7:4]; valid bits and tags in D flip-flops, a Comparator per line or one after a multiplexer.

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `rst` | 1 |
| input | `access` | 1 |
| input | `addr` | 8 |
| output | `hit` | 1 |

Allowed parts: all of the above + Add, Sub, Comparator, Neg. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p35_cache_tags.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `rst` | 1 |
| input | `access` | 1 |
| input | `addr` | 32 |
| output | `hit` | 1 |

Clocked: everything changes on the rising edge of `clk`.
The test bench is `tests/tb_p35_cache_tags.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p35.s`)

# P35 program: Sum an array twice

Read a number k. Fill a 32-word array in `.data` with a[i] = k + i (i = 0..31). Then sum the array **twice**
(two passes of a loop with `lw`) and print each sum on its own line as `sum 1: <s>` and `sum 2: <s>`.

Write `p35_main` as a subroutine ending with `ret`; every label starts with `p35_`; keep sp and s0-s11.

Example input:
```
5
```
Output:
```
sum 1: 656
sum 2: 656
```
Library: rcv_read_dec, rcv_puts, rcv_print_dec, rcv_newline.

Your block: the second pass reads the same addresses again: their tags are already in your cache directory (hits).

Your program is a subroutine: it starts at `p35_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **CSRRW**;
your review partners (E2) are P34 (Bus arbiter (CPU vs DMA)) and P36 (Cache statistics counters).
