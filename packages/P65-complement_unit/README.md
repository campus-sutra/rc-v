# P65 - Complement unit (r and r-1 complements)

**Group:** G. Measurement and support devices · **Syllabus focus:** Unit 3 (Data representation)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

Slot 23: VAL, ONES, TWOS, SIGNMAG, NINES, TENS - binary and decimal complements of a value. It is I/O device slot 23 (registers at 0x000205C0; register 15 must read 65, the package number).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P65.dig` | your circuit in Digital |
| `p65_complement_unit.v` | the same block in Verilog |
| `p65.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P65.dig`)

8-bit 1's and 2's complement from gates (incrementer), and a 9's-complement digit.

| Direction | Name | Bits |
|---|---|---|
| input | `v` | 8 |
| input | `d` | 4 |
| output | `ones` | 8 |
| output | `twos` | 8 |
| output | `nines` | 4 |

Allowed parts: And, Or, Not, NAnd, NOr, XOr, XNOr + wiring parts. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p65_complement_unit.v`)

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
The test bench is `tests/tb_p65_complement_unit.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p65.s`)

# P65 program: Complements

Read a signed number, write it to COMPL_VAL and print `1's complement: `, `2's complement: `,
`sign-magnitude: `, each followed by COMPL_ONES / TWOS / SIGNMAG as 8 hex digits. Then read a number 0..9999,
write it to COMPL_VAL and print `9's complement: ` and `10's complement: ` followed by NINES / TENS (packed BCD)
as 8 hex digits.

Write `p65_main` as a subroutine ending with `ret`; every label starts with `p65_`; keep sp and s0-s11.

Example input:
```
-8
1234
```
Output:
```
1's complement: 00000007
2's complement: 00000008
sign-magnitude: 80000008
9's complement: 00008765
10's complement: 00008766
```
Library: rcv_read_dec, rcv_puts, rcv_print_hex, rcv_newline.

Your block: each line is one output of your complement unit.

Your program is a subroutine: it starts at `p65_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **SRAI**;
your review partners (E2) are P64 (Code converter (Gray, excess-3)) and P66 (Reset controller).
