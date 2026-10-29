# P44 - Seven-segment decoder

**Group:** F. Input/output devices · **Syllabus focus:** Unit 1 (Digital logic circuits), Unit 2 (Digital components)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

Hex digit to segments gfedcba (active high), e.g. 0 -> 0x3F, A -> 0x77.

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P44.dig` | your circuit in Digital |
| `p44_seg7_decoder.v` | the same block in Verilog |
| `p44.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P44.dig`)

Full size, gates only: seven 4-variable K-maps, one per segment.

| Direction | Name | Bits |
|---|---|---|
| input | `hex` | 4 |
| output | `seg` | 7 |

Allowed parts: And, Or, Not, NAnd, NOr, XOr, XNOr + wiring parts. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p44_seg7_decoder.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `hex` | 4 |
| output | `seg` | 7 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p44_seg7_decoder.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p44.s`)

# P44 program: Seven-segment codes from a table

Put a 16-entry table of segment codes (gfedcba, active high: 0 -> 3F, 1 -> 06, ..., A -> 77, F -> 71) in
`.rodata` as bytes. Read a line of hex digits (0-9, A-F, a-f, at most 32). For each digit print one line: the
character as typed, ` -> `, and its segment code as **two** hex digits (write a small routine for that).

Write `p44_main` as a subroutine ending with `ret`; every label starts with `p44_`; keep sp and s0-s11.

Example input:
```
09aF
```
Output:
```
0 -> 3F
9 -> 6F
a -> 77
F -> 71
```
Library: rcv_read_line, rcv_putc, rcv_puts, rcv_newline.

Your block: the table is exactly the truth table of your seven-segment decoder.

Your program is a subroutine: it starts at `p44_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **JAL**;
your review partners (E2) are P43 (LEDs, display register and buttons) and P45 (Hex display scanner).
