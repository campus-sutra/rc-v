# P18 - Immediate generator I/S

**Group:** C. Decode and control · **Syllabus focus:** Unit 3 (Data representation), Unit 4 (Basic computer organisation)
**Work:** hardware ●○○ + program ●●● = the same total as every other package

Sign-extended 12-bit immediates of I-type (loads, ADDI, JALR) and S-type (stores).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P18.dig` | your circuit in Digital |
| `p18_imm_is.v` | the same block in Verilog |
| `p18.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P18.dig`)

Full size, Splitters only: sign extension is just copying bit 31 into the upper bits.

| Direction | Name | Bits |
|---|---|---|
| input | `instr` | 32 |
| output | `imm_i` | 32 |
| output | `imm_s` | 32 |

Allowed parts: Splitter, Tunnel, Const, Ground, VDD, Text, In, Out, Clock. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p18_imm_is.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `instr` | 32 |
| output | `imm_i` | 32 |
| output | `imm_s` | 32 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p18_imm_is.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p18.s`)

# P18 program: Sign-extension explorer  (●●●)

Read a 12-bit value in hex (000 to FFF). Print it sign-extended to 32 bits and zero-extended to 32 bits (use `slli` then `srai` / `srli`).
Then read a decimal byte value 0-255, store it in RAM with `sb`, load it back with `lb` and with `lbu`, and print both.
Output: `sign-extended: <8 hex digits> (<signed decimal>)`, `zero-extended: <8 hex digits> (<signed decimal>)`, `lb:  <n>`, `lbu: <n>`.

Example input:
```
800
255
```
Output:
```
sign-extended: FFFFF800 (-2048)
zero-extended: 00000800 (2048)
lb:  -1
lbu: 255
```

You may use the library routines: rcv_read_hex, rcv_read_dec, rcv_print_hex, rcv_print_dec, rcv_puts, rcv_newline.
This exercises your block: your I/S immediate generator does the same sign extension of bit 11.

Your program is a subroutine: it starts at `p18_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **SLTIU**;
your review partners (E2) are P17 (Instruction field splitter) and P19 (Immediate generator B/J/U).
