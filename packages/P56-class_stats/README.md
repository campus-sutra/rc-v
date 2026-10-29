# P56 - Instruction-mix counters

**Group:** G. Measurement and support devices · **Syllabus focus:** Unit 4 (Basic computer organisation), Unit 5 (Processors)
**Work:** hardware ●○○ + program ●●● = the same total as every other package

Slot 14: LOADS, STORES, BRANCHES, TAKEN, JUMPS, CLEAR - counts of committed instructions by kind. It is I/O device slot 14 (registers at 0x00020380; register 15 must read 56, the package number).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P56.dig` | your circuit in Digital |
| `p56_class_stats.v` | the same block in Verilog |
| `p56.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P56.dig`)

Two 8-bit counters with enable and clear.

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `rst` | 1 |
| input | `commit` | 1 |
| input | `is_load` | 1 |
| input | `is_branch` | 1 |
| input | `clear` | 1 |
| output | `loads` | 8 |
| output | `branches` | 8 |

Allowed parts: gates + multiplexer/decoder parts + flip-flops. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p56_class_stats.v`)

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
| input | `is_load` | 1 |
| input | `is_store` | 1 |
| input | `is_branch` | 1 |
| input | `taken` | 1 |
| input | `is_jump` | 1 |

Clocked: everything changes on the rising edge of `clk`.
The test bench is `tests/tb_p56_class_stats.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p56.s`)

# P56 program: Instruction mix of a bubble sort

Read 10 signed numbers into a word array. Write STATS_CLEAR, `call p56_sort`, then read STATS_LOADS (first),
STORES, BRANCHES, TAKEN, JUMPS. p56_sort is a bubble sort (ascending) with these rules: pass i (i = 0..8) compares
a[j] and a[j+1] for j = 0..8-i, loading both each time; one branch skips the swap when a[j] <= a[j+1]; the swap is
two `sw`; both loops are do-while loops (one branch at the bottom); no stack, no other jumps or calls; `ret`.
Print `sorted:` followed by the numbers (one space before each), then the lines `loads: `, `stores: `,
`branches: `, `taken: `, `jumps: ` with the counts.

Write `p56_main` as a subroutine ending with `ret`; every label starts with `p56_`; keep sp and s0-s11.

Example input:
```
5 3 8 1 9 2 7 4 6 0
```
Output:
```
sorted: 0 1 2 3 4 5 6 7 8 9
loads: 90
stores: 52
branches: 99
taken: 63
jumps: 2
```
Library: rcv_read_dec, rcv_puts, rcv_putc, rcv_print_dec, rcv_newline.

Your block: your counters classify each committed instruction: always 90 loads, 99 branches and 2 jumps (call, ret) here.

Your program is a subroutine: it starts at `p56_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **SW**;
your review partners (E2) are P55 (Stack guard) and P57 (Halt controller).
