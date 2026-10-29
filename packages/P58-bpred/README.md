# P58 - Branch predictor (2-bit counters)

**Group:** G. Measurement and support devices · **Syllabus focus:** Unit 4 (Basic computer organisation)
**Work:** hardware ●●● + program ●○○ = the same total as every other package

Slot 16: BRANCHES, CORRECT, CLEAR. 16 two-bit saturating counters indexed by pc[5:2] predict each branch; the counts show how well a pipeline could guess. It is I/O device slot 16 (registers at 0x00020400; register 15 must read 58, the package number).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P58.dig` | your circuit in Digital |
| `p58_bpred.v` | the same block in Verilog |
| `p58.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P58.dig`)

4 counters of 2 bits, the prediction multiplexer and a correct-count.

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `rst` | 1 |
| input | `commit` | 1 |
| input | `is_branch` | 1 |
| input | `taken` | 1 |
| input | `idx` | 2 |
| output | `predict` | 1 |
| output | `correct` | 8 |

Allowed parts: all of the above + Add, Sub, Comparator, Neg. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p58_bpred.v`)

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
| input | `is_branch` | 1 |
| input | `taken` | 1 |
| input | `pc` | 32 |

Clocked: everything changes on the rising edge of `clk`.
The test bench is `tests/tb_p58_bpred.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p58.s`)

# P58 program: Branch prediction of a loop

Read N (4..1000). Run the same loop code twice (for example in an outer loop that repeats 2 times). Each run:
write BPRED_CLEAR, then a counting loop of N iterations whose **only** branch is one `bnez` at the bottom, then
read BPRED_BRANCHES and BPRED_CORRECT. Print the counters of the second run (the table has learned the loop):
`branches: <b>` and `correct: <c>`.

Write `p58_main` as a subroutine ending with `ret`; every label starts with `p58_`; keep sp and s0-s11.

Example input:
```
100
```
Output:
```
branches: 100
correct: 99
```
Library: rcv_read_dec, rcv_puts, rcv_print_dec, rcv_newline.

Your block: the 2-bit counter of that branch predicts taken until the loop exits.

Your program is a subroutine: it starts at `p58_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **SLTI**;
your review partners (E2) are P57 (Halt controller) and P59 (Pipeline hazard meter).
