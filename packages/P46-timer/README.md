# P46 - Timer

**Group:** F. Input/output devices · **Syllabus focus:** Unit 6 (Memory and I/O)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

Slot 3: COUNT, CMP, CTRL (bit0 enable, bit1 interrupt enable), STATUS bit0 = match (set when COUNT == CMP while enabled, cleared by writing STATUS). irq = match AND CTRL bit1. It is I/O device slot 3 (registers at 0x000200C0; register 15 must read 46, the package number).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P46.dig` | your circuit in Digital |
| `p46_timer.v` | the same block in Verilog |
| `p46.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P46.dig`)

8-bit counter with load, an 8-bit comparator and the sticky match flag.

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `rst` | 1 |
| input | `en` | 1 |
| input | `load` | 1 |
| input | `d` | 8 |
| input | `cmp` | 8 |
| input | `clr` | 1 |
| output | `count` | 8 |
| output | `match` | 1 |

Allowed parts: all of the above + Add, Sub, Comparator, Neg. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p46_timer.v`)

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
| output | `irq` | 1 |

Clocked: everything changes on the rising edge of `clk`.
The test bench is `tests/tb_p46_timer.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p46.s`)

# P46 program: Measure a loop with the timer

Read N (1..10000). Stop the timer (TIMER_CTRL = 0) and set TIMER_COUNT = 0. Prepare t0 = TIMER_CTRL, t1 = 1,
t2 = N, a0 = 0. The measured part must be exactly: `sw t1, 0(t0)` (start), the loop `add a0, a0, t2` /
`addi t2, t2, -1` / `bnez t2, <loop>`, and `sw zero, 0(t0)` (stop). Then read TIMER_COUNT and print three lines:
`sum = <a0>`, `cycles = <count>`, `per iteration = <count / N>`.

Write `p46_main` as a subroutine ending with `ret`; every label starts with `p46_`; keep sp and s0-s11.

Example input:
```
100
```
Output:
```
sum = 5050
cycles = 301
per iteration = 3
```
Library: rcv_read_dec, rcv_puts, rcv_print_dec, rcv_udiv, rcv_newline.

Your block: COUNT goes up every cycle while CTRL bit 0 is 1: here 3N + 1 cycles.

Your program is a subroutine: it starts at `p46_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **BEQ (taken)**;
your review partners (E2) are P45 (Hex display scanner) and P47 (Interrupt controller).
