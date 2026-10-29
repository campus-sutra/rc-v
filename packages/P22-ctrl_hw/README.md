# P22 - Hardwired control unit

**Group:** C. Decode and control · **Syllabus focus:** Unit 1 (Digital logic circuits), Unit 4 (Basic computer organisation)
**Work:** hardware ●●● + program ●○○ = the same total as every other package

Produces the 16-bit control word (regwrite asel_pc bsel_imm a_zero memread memwrite wbsel[2] immsel[3] is_branch is_jal is_jalr is_csr) from the class signals, with logic gates.

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P22.dig` | your circuit in Digital |
| `p22_ctrl_hw.v` | the same block in Verilog |
| `p22.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P22.dig`)

Full size, gates only: one OR-of-classes equation per control bit.

| Direction | Name | Bits |
|---|---|---|
| input | `is_lui` | 1 |
| input | `is_auipc` | 1 |
| input | `is_jal` | 1 |
| input | `is_jalr` | 1 |
| input | `is_branch` | 1 |
| input | `is_load` | 1 |
| input | `is_store` | 1 |
| input | `is_opimm` | 1 |
| input | `is_op` | 1 |
| input | `is_system` | 1 |
| output | `ctrl` | 16 |

Allowed parts: And, Or, Not, NAnd, NOr, XOr, XNOr + wiring parts. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p22_ctrl_hw.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `is_lui` | 1 |
| input | `is_auipc` | 1 |
| input | `is_jal` | 1 |
| input | `is_jalr` | 1 |
| input | `is_branch` | 1 |
| input | `is_load` | 1 |
| input | `is_store` | 1 |
| input | `is_opimm` | 1 |
| input | `is_op` | 1 |
| input | `is_system` | 1 |
| output | `ctrl` | 16 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p22_ctrl_hw.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p22.s`)

# P22 program: Multiplication table  (●○○)

Read a signed decimal N. Print N x 1 up to N x 10. Get each product by adding N to the previous one (no rcv_umul, no shifts).
Output: 10 lines `<N> x <i> = <product>`.

Example input:
```
7
```
Output (shortened):
```
7 x 1 = 7
7 x 2 = 14
7 x 3 = 21
7 x 4 = 28
...
7 x 10 = 70
```

You may use the library routines: rcv_read_dec, rcv_print_dec, rcv_puts, rcv_newline.

Your program is a subroutine: it starts at `p22_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **SLLI**;
your review partners (E2) are P21 (Opcode class decoder) and P23 (Microprogrammed control (control ROM)).
