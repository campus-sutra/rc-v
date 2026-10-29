# P13 - Register-file read port

**Group:** B. Registers and program counter · **Syllabus focus:** Unit 2 (Digital components)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

Selects register ra out of q_flat. The processor uses two copies (rs1 and rs2).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P13.dig` | your circuit in Digital |
| `p13_rf_readmux.v` | the same block in Verilog |
| `p13.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P13.dig`)

4 registers x 4 bits: build the 4-to-1 multiplexer from AND/OR gates (no Multiplexer part).

| Direction | Name | Bits |
|---|---|---|
| input | `q_flat` | 16 |
| input | `ra` | 2 |
| output | `rd` | 4 |

Allowed parts: And, Or, Not, NAnd, NOr, XOr, XNOr + wiring parts. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p13_rf_readmux.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `q_flat` | 1024 |
| input | `ra` | 5 |
| output | `rd` | 32 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p13_rf_readmux.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p13.s`)

# P13 program: Count character kinds  (●●○)

Read one line of text (at most 80 characters). Count the vowels (a e i o u, upper or lower case), consonants (all other letters), digits and spaces. Other characters are not counted.
Output: four lines `vowels: <n>`, `consonants: <n>`, `digits: <n>`, `spaces: <n>`.

Example input:
```
Hello World 2025
```
Output:
```
vowels: 3
consonants: 7
digits: 4
spaces: 2
```

You may use the library routines: rcv_read_line, rcv_print_udec, rcv_puts, rcv_newline.

Your program is a subroutine: it starts at `p13_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **LW**;
your review partners (E2) are P12 (Register-file storage) and P14 (Program counter register).
