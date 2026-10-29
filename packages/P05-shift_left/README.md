# P05 - Left barrel shifter

**Group:** A. Arithmetic and logic · **Syllabus focus:** Unit 2 (Digital components)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

y = a << sh, built as a barrel shifter (stages that shift by 1, 2, 4, 8, 16).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P05.dig` | your circuit in Digital |
| `p05_shift_left.v` | the same block in Verilog |
| `p05.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P05.dig`)

8-bit version: three stages of 2-to-1 multiplexers (shift by 1, 2, 4).

| Direction | Name | Bits |
|---|---|---|
| input | `a` | 8 |
| input | `sh` | 3 |
| output | `y` | 8 |

Allowed parts: gates + Multiplexer, Demultiplexer, Decoder, PriorityEncoder. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p05_shift_left.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `a` | 32 |
| input | `sh` | 5 |
| output | `y` | 32 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p05_shift_left.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p05.s`)

# P05 program: Multiply with shifts  (●●○)

Read a signed decimal number N. Print N*2, N*4, N*8 and N*10 using only shift and add instructions (no rcv_umul, no loops of additions). Hint: N*10 = N*8 + N*2.
Output: four lines `N*2  = `, `N*4  = `, `N*8  = `, `N*10 = ` (note the spaces), each followed by the value in decimal.

Example input:
```
7
```
Output:
```
N*2  = 14
N*4  = 28
N*8  = 56
N*10 = 70
```

You may use the library routines: rcv_read_dec, rcv_print_dec, rcv_puts, rcv_newline.
This exercises your block: `slli` is done by your left barrel shifter.

Your program is a subroutine: it starts at `p05_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **BEQ (taken)**;
your review partners (E2) are P04 (ALU logic unit) and P06 (Right barrel shifter).
