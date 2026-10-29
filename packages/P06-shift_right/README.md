# P06 - Right barrel shifter

**Group:** A. Arithmetic and logic · **Syllabus focus:** Unit 2 (Digital components), Unit 3 (Data representation)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

y = a >> sh. arith=1 copies the sign bit in from the left (SRA), arith=0 shifts in zeros (SRL).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P06.dig` | your circuit in Digital |
| `p06_shift_right.v` | the same block in Verilog |
| `p06.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P06.dig`)

8-bit version: three multiplexer stages; the bit shifted in is a7 AND arith.

| Direction | Name | Bits |
|---|---|---|
| input | `a` | 8 |
| input | `sh` | 3 |
| input | `arith` | 1 |
| output | `y` | 8 |

Allowed parts: gates + Multiplexer, Demultiplexer, Decoder, PriorityEncoder. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p06_shift_right.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `a` | 32 |
| input | `sh` | 5 |
| input | `arith` | 1 |
| output | `y` | 32 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p06_shift_right.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p06.s`)

# P06 program: Arithmetic and logical right shift  (●●○)

Read a signed decimal number N. Print N, N shifted right by 1 with `srai` (arithmetic) and with `srli` (logical), each in decimal and in hex. Try a negative N to see the difference.
Output: three lines `N       = `, `N sra 1 = `, `N srl 1 = ` (note the spaces), each followed by `<signed decimal> (<8 hex digits>)`.

Example input:
```
-20
```
Output:
```
N       = -20 (FFFFFFEC)
N sra 1 = -10 (FFFFFFF6)
N srl 1 = 2147483638 (7FFFFFF6)
```

You may use the library routines: rcv_read_dec, rcv_print_dec, rcv_print_hex, rcv_puts.
This exercises your block: your right shifter's `arith` input chooses between these two results.

Your program is a subroutine: it starts at `p06_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **BNE (not taken)**;
your review partners (E2) are P05 (Left barrel shifter) and P07 (Less-than unit (signed and unsigned)).
