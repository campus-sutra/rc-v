# P04 - ALU logic unit

**Group:** A. Arithmetic and logic · **Syllabus focus:** Unit 1 (Digital logic circuits), Unit 2 (Digital components)
**Work:** hardware ●○○ + program ●●● = the same total as every other package

op 0 = AND, 1 = OR, 2 = XOR, 3 = 0.

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P04.dig` | your circuit in Digital |
| `p04_alu_logic.v` | the same block in Verilog |
| `p04.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P04.dig`)

4-bit version: one bit-slice of AND/OR/XOR gates and a 4-to-1 multiplexer, copied 4 times.

| Direction | Name | Bits |
|---|---|---|
| input | `a` | 4 |
| input | `b` | 4 |
| input | `op` | 2 |
| output | `y` | 4 |

Allowed parts: gates + Multiplexer, Demultiplexer, Decoder, PriorityEncoder. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p04_alu_logic.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `a` | 32 |
| input | `b` | 32 |
| input | `op` | 2 |
| output | `y` | 32 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p04_alu_logic.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p04.s`)

# P04 program: Bitwise calculator  (●●●)

Read two hex numbers A and B (one per line, with or without `0x`). Print A AND B, A OR B, A XOR B, NOT A, A NAND B and A NOR B as 8 hex digits.
Output: six lines, exactly these labels: `A AND B  = `, `A OR B   = `, `A XOR B  = `, `NOT A    = `, `A NAND B = `, `A NOR B  = ` (note the spaces), each followed by the value.

Example input:
```
F0F0F0F0
0FF00FF0
```
Output:
```
A AND B  = 00F000F0
A OR B   = FFF0FFF0
A XOR B  = FF00FF00
NOT A    = 0F0F0F0F
A NAND B = FF0FFF0F
A NOR B  = 000F000F
```

You may use the library routines: rcv_read_hex, rcv_print_hex, rcv_puts, rcv_newline.
This exercises your block: AND, OR and XOR are the operations of your ALU logic unit.

Your program is a subroutine: it starts at `p04_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **JALR**;
your review partners (E2) are P03 (PC incrementer) and P05 (Left barrel shifter).
