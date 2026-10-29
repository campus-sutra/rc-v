# P55 - Stack guard

**Group:** G. Measurement and support devices · **Syllabus focus:** Unit 5 (Processors)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

Slot 13: LIMIT, STATUS bit0 (sp went below LIMIT), MINSP (lowest sp seen). Watches every write to register x2 (sp). irq = STATUS bit0. It is I/O device slot 13 (registers at 0x00020340; register 15 must read 55, the package number).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P55.dig` | your circuit in Digital |
| `p55_sp_guard.v` | the same block in Verilog |
| `p55.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P55.dig`)

8-bit: a minimum register and two comparators.

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `rst` | 1 |
| input | `sp_we` | 1 |
| input | `sp` | 8 |
| input | `limit` | 8 |
| input | `clear` | 1 |
| output | `minsp` | 8 |
| output | `flag` | 1 |

Allowed parts: all of the above + Add, Sub, Comparator, Neg. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p55_sp_guard.v`)

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
| input | `rf_we` | 1 |
| input | `rd` | 5 |
| input | `rf_wd` | 32 |
| output | `irq` | 1 |

Clocked: everything changes on the rising edge of `clk`.
The test bench is `tests/tb_p55_sp_guard.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p55.s`)

# P55 program: Stack depth of a recursion

Read N (0..100). Write SPGUARD_STATUS (this clears it and resets MINSP), remember sp, and call the recursive
`p55_sum(n) = n + p55_sum(n - 1)`, `p55_sum(0) = 0`. Every call of p55_sum starts with `addi sp, sp, -8` (save ra
and n), also for n = 0. Read SPGUARD_MINSP right after the call returns. Print `sum = <s>` and
`stack bytes = <remembered sp - MINSP>`.

Write `p55_main` as a subroutine ending with `ret`; every label starts with `p55_`; keep sp and s0-s11.

Example input:
```
10
```
Output:
```
sum = 55
stack bytes = 88
```
Library: rcv_read_dec, rcv_puts, rcv_print_dec, rcv_newline.

Your block: MINSP is the lowest value your guard saw written to sp.

Your program is a subroutine: it starts at `p55_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **SB**;
your review partners (E2) are P54 (Random numbers (LFSR)) and P56 (Instruction-mix counters).
