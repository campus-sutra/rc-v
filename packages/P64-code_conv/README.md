# P64 - Code converter (Gray, excess-3)

**Group:** G. Measurement and support devices · **Syllabus focus:** Unit 3 (Data representation)
**Work:** hardware ●○○ + program ●●● = the same total as every other package

Slot 22: VAL, GRAY, FROMGRAY, XS3 (excess-3 of the four decimal digits). It is I/O device slot 22 (registers at 0x00020580; register 15 must read 64, the package number).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P64.dig` | your circuit in Digital |
| `p64_code_conv.v` | the same block in Verilog |
| `p64.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P64.dig`)

XOR gates for Gray code; an excess-3 digit from gates (K-maps).

| Direction | Name | Bits |
|---|---|---|
| input | `v` | 8 |
| input | `digit` | 4 |
| output | `gray` | 8 |
| output | `fromgray` | 8 |
| output | `xs3` | 4 |

Allowed parts: And, Or, Not, NAnd, NOr, XOr, XNOr + wiring parts. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p64_code_conv.v`)

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
The test bench is `tests/tb_p64_code_conv.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p64.s`)

# P64 program: Binary, Gray and excess-3 table

Print the header ` n bin  gray xs3`, then for n = 0..15 one line: n right-aligned in 2 characters, a space,
n as 4 binary digits, a space, CODECONV_GRAY as 4 binary digits, a space, CODECONV_XS3 as 8 binary digits (write
n to CODECONV_VAL first). Then read a number v (0..65535), write it to CODECONV_VAL and print
`gray: <GRAY, 8 hex digits>`, `xs3: <XS3, 8 hex digits>` and `back: <decimal>` (write the Gray code to VAL and
read FROMGRAY).

Write `p64_main` as a subroutine ending with `ret`; every label starts with `p64_`; keep sp and s0-s11.

Example input:
```
0
```
Output:
```
 n bin  gray xs3
 0 0000 0000 00110011
 1 0001 0001 00110100
 2 0010 0011 00110101
...
14 1110 1001 01000111
15 1111 1000 01001000
gray: 00000000
xs3: 00003333
back: 0
```
Library: rcv_read_dec, rcv_putc, rcv_puts, rcv_print_dec, rcv_print_hex, rcv_newline.

Your block: every column comes from your code converter.

Your program is a subroutine: it starts at `p64_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **SRLI**;
your review partners (E2) are P63 (Hardware stack) and P65 (Complement unit (r and r-1 complements)).
