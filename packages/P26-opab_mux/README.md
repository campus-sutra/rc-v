# P26 - ALU operand selector

**Group:** C. Decode and control · **Syllabus focus:** Unit 4 (Basic computer organisation), Unit 5 (Processors)
**Work:** hardware ●○○ + program ●●● = the same total as every other package

a = 0 (LUI) or pc (AUIPC) or rs1; b = immediate or rs2. This is where addressing modes (register, immediate, PC-relative) are chosen.

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P26.dig` | your circuit in Digital |
| `p26_opab_mux.v` | the same block in Verilog |
| `p26.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P26.dig`)

4-bit version.

| Direction | Name | Bits |
|---|---|---|
| input | `a_zero` | 1 |
| input | `asel_pc` | 1 |
| input | `bsel_imm` | 1 |
| input | `rs1` | 4 |
| input | `pc` | 4 |
| input | `rs2` | 4 |
| input | `imm` | 4 |
| output | `a` | 4 |
| output | `b` | 4 |

Allowed parts: gates + Multiplexer, Demultiplexer, Decoder, PriorityEncoder. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p26_opab_mux.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `a_zero` | 1 |
| input | `asel_pc` | 1 |
| input | `bsel_imm` | 1 |
| input | `rs1` | 32 |
| input | `pc` | 32 |
| input | `rs2` | 32 |
| input | `imm` | 32 |
| output | `a` | 32 |
| output | `b` | 32 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p26_opab_mux.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p26.s`)

# P26 program: lui + addi constant builder  (●●●)

Read a 32-bit value in hex. Find the immediates that `lui` and `addi` need to build it: the addi immediate is the low 12 bits sign-extended (-2048..2047); the lui immediate is (value - addi immediate) >> 12, which is one more than the top 20 bits when bit 11 is 1. Then rebuild the value as (lui << 12) + addi and compare.
Output: `bit 11   = <0|1>`, `lui  imm = <8 hex digits>`, `addi imm = <signed decimal>`, `rebuilt  = <8 hex digits>`, `check: OK` (or `check: FAIL`).

Example input:
```
DEADBEEF
```
Output:
```
bit 11   = 1
lui  imm = 000DEADC
addi imm = -273
rebuilt  = DEADBEEF
check: OK
```

You may use the library routines: rcv_read_hex, rcv_print_hex, rcv_print_dec, rcv_print_udec, rcv_puts, rcv_newline.
This exercises your block: for `lui` your operand selector feeds 0 into the ALU instead of rs1.

Your program is a subroutine: it starts at `p26_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **SUB**;
your review partners (E2) are P25 (Write-back selector) and P15 (Next-PC selector).
