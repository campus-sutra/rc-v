# P59 - Pipeline hazard meter

**Group:** G. Measurement and support devices · **Syllabus focus:** Unit 4 (Basic computer organisation)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

Slot 17: LOADUSE, RAW1, CLEAR. Counts instructions that read the register written by the instruction just before them (a pipeline would need forwarding or a stall). It is I/O device slot 17 (registers at 0x00020440; register 15 must read 59, the package number).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P59.dig` | your circuit in Digital |
| `p59_hazard_meter.v` | the same block in Verilog |
| `p59.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P59.dig`)

A previous-rd register, comparators and two counters.

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `rst` | 1 |
| input | `commit` | 1 |
| input | `rd` | 5 |
| input | `rf_we` | 1 |
| input | `is_load` | 1 |
| input | `rs1` | 5 |
| input | `uses_rs1` | 1 |
| input | `rs2` | 5 |
| input | `uses_rs2` | 1 |
| output | `raw` | 8 |
| output | `loaduse` | 8 |

Allowed parts: all of the above + Add, Sub, Comparator, Neg. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p59_hazard_meter.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `rst` | 1 |
| input | `sel` | 1 |
| input | `we` | 1 |
| input | `re` | 1 |
| input | `ridx` | 4 |
| input | `wdata` | 32 |
| output | `rdata` | 32 |
| input | `commit` | 1 |
| input | `instr` | 32 |
| input | `rf_we` | 1 |
| input | `rd` | 5 |
| input | `is_load` | 1 |

Clocked: everything changes on the rising edge of `clk`.
The test bench is `tests/tb_p59_hazard_meter.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p59.s`)

# P59 program: Load-use hazards

Read N (1..16) and N numbers into a word array. Version A: with a5 = HAZARD_BASE, t0 = array, t2 = N, a0 = 0
prepared, run `sw zero, 8(a5)` (CLEAR), the loop `lw t1, 0(t0)` / `add a0, a0, t1` / `addi t0, t0, 4` /
`addi t2, t2, -1` / `bnez t2`, then `lw a1, 0(a5)` (LOADUSE) and `lw a2, 4(a5)` (RAW1). Version B: the same, but
with the loop `lw t1, 0(t0)` / `addi t0, t0, 4` / `add a0, a0, t1` / `addi t2, t2, -1` / `bnez t2`. Print
`version A: sum=<a0> loaduse=<a1> raw1=<a2>` and the same line for version B.

Write `p59_main` as a subroutine ending with `ret`; every label starts with `p59_`; keep sp and s0-s11.

Example input:
```
5
1 2 3 4 5
```
Output:
```
version A: sum=15 loaduse=5 raw1=10
version B: sum=15 loaduse=0 raw1=5
```
Library: rcv_read_dec, rcv_puts, rcv_print_dec, rcv_newline.

Your block: your meter compares the sources of each instruction with the destination of the one before.

Your program is a subroutine: it starts at `p59_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **SLTIU**;
your review partners (E2) are P58 (Branch predictor (2-bit counters)) and P60 (Parity generator).
