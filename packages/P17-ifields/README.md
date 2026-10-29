# P17 - Instruction field splitter

**Group:** C. Decode and control · **Syllabus focus:** Unit 4 (Basic computer organisation)
**Work:** hardware ●○○ + program ●●● = the same total as every other package

Splits an instruction word into its fields (R/I/S/B/U/J formats share these positions).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P17.dig` | your circuit in Digital |
| `p17_ifields.v` | the same block in Verilog |
| `p17.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P17.dig`)

Full size, Splitters only. Label every field.

| Direction | Name | Bits |
|---|---|---|
| input | `instr` | 32 |
| output | `opcode` | 7 |
| output | `rd` | 5 |
| output | `funct3` | 3 |
| output | `rs1` | 5 |
| output | `rs2` | 5 |
| output | `funct7` | 7 |
| output | `csr` | 12 |

Allowed parts: Splitter, Tunnel, Const, Ground, VDD, Text, In, Out, Clock. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p17_ifields.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `instr` | 32 |
| output | `opcode` | 7 |
| output | `rd` | 5 |
| output | `funct3` | 3 |
| output | `rs1` | 5 |
| output | `rs2` | 5 |
| output | `funct7` | 7 |
| output | `csr` | 12 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p17_ifields.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p17.s`)

# P17 program: Mini disassembler  (●●●)

Read instruction words in hex, one per line, until 0. For an R-type word (opcode 0x33) print it in assembly, e.g. `add x10, x11, x12` (rd, rs1, rs2), for funct7 = 0: add sll slt sltu xor srl or and (by funct3); funct7 = 0x20: sub (funct3 0), sra (funct3 5).
Otherwise print the format: `I-type` (opcodes 0x13 0x03 0x67 0x73), `S-type` (0x23), `B-type` (0x63), `U-type` (0x37 0x17), `J-type` (0x6F). Anything else, including R-type words with another funct7, prints `unknown`.
Use a table of string pointers for the names.

Example input:
```
00C58533
407302B3
00510093
02C58533
0
```
Output:
```
add x10, x11, x12
sub x5, x6, x7
I-type
unknown
```

You may use the library routines: rcv_read_hex, rcv_puts, rcv_putc, rcv_print_udec, rcv_newline.
This exercises your block: you split the word into fields exactly like your field splitter.

Your program is a subroutine: it starts at `p17_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **SLTI**;
your review partners (E2) are P16 (Next-PC decision logic) and P18 (Immediate generator I/S).
