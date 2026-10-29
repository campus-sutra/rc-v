# P52 - Binary-to-BCD converter

**Group:** G. Measurement and support devices · **Syllabus focus:** Unit 3 (Data representation)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

Slot 10: BIN (16 bits), BCD (five packed decimal digits of BIN), using the double-dabble (shift and add 3) method. It is I/O device slot 10 (registers at 0x00020280; register 15 must read 52, the package number).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P52.dig` | your circuit in Digital |
| `p52_bcd_unit.v` | the same block in Verilog |
| `p52.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P52.dig`)

8-bit version: shift-and-add-3 cells (if a digit >= 5 add 3).

| Direction | Name | Bits |
|---|---|---|
| input | `bin` | 8 |
| output | `bcd` | 12 |

Allowed parts: all of the above + Add, Sub, Comparator, Neg. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p52_bcd_unit.v`)

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
The test bench is `tests/tb_p52_bcd_unit.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p52.s`)

# P52 program: Count with the BCD unit

Read A and B (0 <= A <= B <= 65535, B - A <= 100). Print every number from A to B on its own line **without
division**: write it to BCD_BIN, read BCD_BCD (5 packed digits) and print the digits, most significant first,
without leading zeros (0 prints as `0`).

Write `p52_main` as a subroutine ending with `ret`; every label starts with `p52_`; keep sp and s0-s11.

Example input:
```
0 12
```
Output:
```
0
1
2
3
4
5
6
7
8
9
10
11
12
```
Library: rcv_read_dec, rcv_putc, rcv_newline (not rcv_print_dec).

Your block: the binary-to-BCD conversion is done by your double-dabble circuit.

Your program is a subroutine: it starts at `p52_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **LB**;
your review partners (E2) are P51 (Four-lane vector unit (mini GPU)) and P53 (Watchdog timer).
