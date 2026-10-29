# P08 - ALU result selector

**Group:** A. Arithmetic and logic · **Syllabus focus:** Unit 2 (Digital components)
**Work:** hardware ●○○ + program ●●● = the same total as every other package

Chooses the ALU result for the operation (ADD/SUB from the adder, AND/OR/XOR from the logic unit, shifts, SLT/SLTU as 0 or 1). zero = (y == 0).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P08.dig` | your circuit in Digital |
| `p08_alu_select.v` | the same block in Verilog |
| `p08.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P08.dig`)

4-bit version: decode aluop into a select code, then multiplexers; zero is a NOR of all bits.

| Direction | Name | Bits |
|---|---|---|
| input | `aluop` | 4 |
| input | `add_y` | 4 |
| input | `logic_y` | 4 |
| input | `shl_y` | 4 |
| input | `shr_y` | 4 |
| input | `lt` | 1 |
| input | `ltu` | 1 |
| output | `y` | 4 |
| output | `zero` | 1 |

Allowed parts: gates + Multiplexer, Demultiplexer, Decoder, PriorityEncoder. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p08_alu_select.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `aluop` | 4 |
| input | `add_y` | 32 |
| input | `logic_y` | 32 |
| input | `shl_y` | 32 |
| input | `shr_y` | 32 |
| input | `lt` | 1 |
| input | `ltu` | 1 |
| output | `y` | 32 |
| output | `zero` | 1 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p08_alu_select.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p08.s`)

# P08 program: Line calculator  (●●●)

Read lines of the form `a op b` (signed decimal numbers, spaces around op allowed) and print the result of each, until a line `q`. op is one of `+ - & | ^ <`; `<` gives 1 if a < b (signed), else 0.
Read each line with rcv_read_line and take it apart yourself (write your own small decimal parser that accepts a leading `-`).
Output: one line per calculation with the result in decimal; for any other operator print `bad operator`.

Example input:
```
12 + 30
-5 - 7
12 & 10
4 * 2
q
```
Output:
```
42
-12
8
bad operator
```

You may use the library routines: rcv_read_line, rcv_print_dec, rcv_puts, rcv_newline.
This exercises your block: choosing the operation is what your ALU result selector does.

Your program is a subroutine: it starts at `p08_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **BGE**;
your review partners (E2) are P07 (Less-than unit (signed and unsigned)) and P09 (Branch comparator).
