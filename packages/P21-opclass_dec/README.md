# P21 - Opcode class decoder

**Group:** C. Decode and control · **Syllabus focus:** Unit 1 (Digital logic circuits), Unit 4 (Basic computer organisation)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

One output per instruction class from the 7-bit opcode, plus exact matches for ECALL (0x00000073) and MRET (0x30200073).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P21.dig` | your circuit in Digital |
| `p21_opclass_dec.v` | the same block in Verilog |
| `p21.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P21.dig`)

Full size: AND gates with inverted inputs for each opcode; a Comparator with a Const is allowed for ECALL/MRET.

| Direction | Name | Bits |
|---|---|---|
| input | `instr` | 32 |
| output | `is_lui` | 1 |
| output | `is_auipc` | 1 |
| output | `is_jal` | 1 |
| output | `is_jalr` | 1 |
| output | `is_branch` | 1 |
| output | `is_load` | 1 |
| output | `is_store` | 1 |
| output | `is_opimm` | 1 |
| output | `is_op` | 1 |
| output | `is_system` | 1 |
| output | `is_ecall` | 1 |
| output | `is_mret` | 1 |

Allowed parts: all of the above + Add, Sub, Comparator, Neg. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p21_opclass_dec.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `instr` | 32 |
| output | `is_lui` | 1 |
| output | `is_auipc` | 1 |
| output | `is_jal` | 1 |
| output | `is_jalr` | 1 |
| output | `is_branch` | 1 |
| output | `is_load` | 1 |
| output | `is_store` | 1 |
| output | `is_opimm` | 1 |
| output | `is_op` | 1 |
| output | `is_system` | 1 |
| output | `is_ecall` | 1 |
| output | `is_mret` | 1 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p21_opclass_dec.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p21.s`)

# P21 program: Palindrome  (●●○)

Read one word (at most 40 characters). Find out whether it reads the same backwards (compare from both ends; upper and lower case are different).
Output: `<word> is a palindrome` or `<word> is not a palindrome`.

Example input:
```
level
```
Output:
```
level is a palindrome
```

You may use the library routines: rcv_read_line, rcv_puts.

Your program is a subroutine: it starts at `p21_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **ANDI**;
your review partners (E2) are P20 (Immediate selector) and P22 (Hardwired control unit).
