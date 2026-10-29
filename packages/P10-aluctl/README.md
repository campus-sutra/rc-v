# P10 - ALU control

**Group:** A. Arithmetic and logic · **Syllabus focus:** Unit 1 (Digital logic circuits), Unit 4 (Basic computer organisation)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

Turns funct3/funct7 into the ALU operation code (ADD=0 SUB=1 AND=2 OR=3 XOR=4 SLL=5 SRL=6 SRA=7 SLT=8 SLTU=9). Non-ALU instructions use ADD. ADDI never subtracts.

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P10.dig` | your circuit in Digital |
| `p10_aluctl.v` | the same block in Verilog |
| `p10.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P10.dig`)

Full size, gates only: write the truth table, simplify each output bit with a K-map.

| Direction | Name | Bits |
|---|---|---|
| input | `is_op` | 1 |
| input | `is_opimm` | 1 |
| input | `funct3` | 3 |
| input | `funct7b5` | 1 |
| output | `aluop` | 4 |

Allowed parts: And, Or, Not, NAnd, NOr, XOr, XNOr + wiring parts. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p10_aluctl.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `is_op` | 1 |
| input | `is_opimm` | 1 |
| input | `funct3` | 3 |
| input | `funct7b5` | 1 |
| output | `aluop` | 4 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p10_aluctl.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p10.s`)

# P10 program: Instruction fields  (●●○)

Read one instruction word in hex. Print its opcode (bits 6..0), funct3 (bits 14..12) and funct7 (bits 31..25) in decimal, using shifts and `andi`.
Output: three lines `opcode = <n>`, `funct3 = <n>`, `funct7 = <n>`.

Example input:
```
0x407302B3
```
Output:
```
opcode = 51
funct3 = 0
funct7 = 32
```

You may use the library routines: rcv_read_hex, rcv_print_udec, rcv_puts, rcv_newline.
This exercises your block: funct3 and funct7 are exactly the inputs of your ALU control.

Your program is a subroutine: it starts at `p10_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **BGEU**;
your review partners (E2) are P09 (Branch comparator) and P01 (ALU adder/subtractor).
