# P45 - Hex display scanner

**Group:** F. Input/output devices · **Syllabus focus:** Unit 2 (Digital components), Unit 6 (Memory and I/O)
**Work:** hardware ●○○ + program ●●● = the same total as every other package

Shows one digit at a time: each clock moves to the next of 8 digits; digit = that nibble of value, anode = one-hot digit position.

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P45.dig` | your circuit in Digital |
| `p45_hex_display.v` | the same block in Verilog |
| `p45.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P45.dig`)

4 digits: a 2-bit counter, a 2-to-4 decoder for the anodes and a multiplexer for the nibble.

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `rst` | 1 |
| input | `value` | 16 |
| output | `digit` | 4 |
| output | `anode` | 4 |

Allowed parts: gates + multiplexer/decoder parts + flip-flops. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p45_hex_display.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `rst` | 1 |
| input | `value` | 32 |
| output | `digit` | 4 |
| output | `anode` | 8 |

Clocked: everything changes on the rising edge of `clk`.
The test bench is `tests/tb_p45_hex_display.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p45.s`)

# P45 program: Hex display: decimal to BCD

Read a number 0..99999999. Convert it to packed BCD (one decimal digit per 4 bits, ones digit in bits 3..0) by
repeated division by 10 with `rcv_udiv`. Write it to GPIO_SEG, read GPIO_SEG back and print
`SEG = <8 hex digits>`. Then show what the display scanner does: for k = 0..7 print
`k: anode=<1 << k as 8 binary digits> digit=<nibble k>`.

Write `p45_main` as a subroutine ending with `ret`; every label starts with `p45_`; keep sp and s0-s11.

Example input:
```
12345
```
Output:
```
SEG = 00012345
0: anode=00000001 digit=5
1: anode=00000010 digit=4
2: anode=00000100 digit=3
3: anode=00001000 digit=2
4: anode=00010000 digit=1
5: anode=00100000 digit=0
6: anode=01000000 digit=0
7: anode=10000000 digit=0
```
Library: rcv_read_dec, rcv_udiv, rcv_puts, rcv_putc, rcv_print_hex, rcv_newline.

Your block: each printed scan line is one clock step of your hex display (one-hot anode, one nibble).

Your program is a subroutine: it starts at `p45_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **JALR**;
your review partners (E2) are P44 (Seven-segment decoder) and P46 (Timer).
