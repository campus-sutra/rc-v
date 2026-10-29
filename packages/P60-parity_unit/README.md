# P60 - Parity generator

**Group:** G. Measurement and support devices · **Syllabus focus:** Unit 2 (Digital components), Unit 3 (Data representation)
**Work:** hardware ●○○ + program ●●● = the same total as every other package

Slot 18: DATA, PARITY (bit k = parity of byte k, bit 4 = parity of the word), ODD (bytes with odd parity). It is I/O device slot 18 (registers at 0x00020480; register 15 must read 60, the package number).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P60.dig` | your circuit in Digital |
| `p60_parity_unit.v` | the same block in Verilog |
| `p60.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P60.dig`)

XOR trees for each byte, then the totals.

| Direction | Name | Bits |
|---|---|---|
| input | `data` | 32 |
| output | `parity` | 5 |
| output | `odd` | 3 |

Allowed parts: all of the above + Add, Sub, Comparator, Neg. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p60_parity_unit.v`)

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
The test bench is `tests/tb_p60_parity_unit.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p60.s`)

# P60 program: Parity of every character

Read a line (at most 40 characters). For each character write it to PARITY_DATA and read bit 0 of
PARITY_PARITY. Print one line per character: the character, a space, its code as two hex digits, a space, the
parity bit. Finally print `line parity: <XOR of all the parity bits>` (the parity of all bits of the line).

Write `p60_main` as a subroutine ending with `ret`; every label starts with `p60_`; keep sp and s0-s11.

Example input:
```
RC-V 1
```
Output:
```
R 52 1
C 43 1
- 2D 0
V 56 0
  20 1
1 31 1
line parity: 0
```
Library: rcv_read_line, rcv_putc, rcv_puts, rcv_newline.

Your block: bit 0 of PARITY is the XOR of the 8 bits of byte 0, computed by your parity tree.

Your program is a subroutine: it starts at `p60_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **XORI**;
your review partners (E2) are P59 (Pipeline hazard meter) and P61 (Text screen).
