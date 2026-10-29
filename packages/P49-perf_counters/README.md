# P49 - Performance counters

**Group:** G. Measurement and support devices · **Syllabus focus:** Unit 4 (Basic computer organisation), Unit 5 (Processors)
**Work:** hardware ●○○ + program ●●● = the same total as every other package

Slot 6: CYCLE (every clock), INSTRET (every committed instruction), CLEAR. CPI = CYCLE / INSTRET. It is I/O device slot 6 (registers at 0x00020180; register 15 must read 49, the package number).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P49.dig` | your circuit in Digital |
| `p49_perf_counters.v` | the same block in Verilog |
| `p49.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P49.dig`)

Two 8-bit counters from flip-flops.

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `rst` | 1 |
| input | `commit` | 1 |
| input | `clear` | 1 |
| output | `cycle` | 8 |
| output | `instret` | 8 |

Allowed parts: gates + multiplexer/decoder parts + flip-flops. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p49_perf_counters.v`)

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

Clocked: everything changes on the rising edge of `clk`.
The test bench is `tests/tb_p49_perf_counters.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p49.s`)

# P49 program: Benchmark with the performance counters

Read N (1..1000) and L (1..64). Part 1: with a5 = PERF_BASE, t2 = N, a0 = 0 prepared, run exactly
`sw zero, 8(a5)` (CLEAR), the loop `add a0, a0, t2` / `addi t2, t2, -1` / `bnez t2, <loop>`, then `lw` INSTRET
and **then** `lw` CYCLE. Part 2: with a4 = DMA_BASE, the addresses of two 64-word RAM buffers, L and 1 already in
registers, run exactly: CLEAR, `sw` SRC, `sw` DST, `sw` LEN, `sw` CTRL (= 1), the poll loop `lw` STATUS /
`andi` with 2 / `beqz`, then `lw` INSTRET, `lw` CYCLE (clear STATUS afterwards). Print
`loop: sum=<a0> cycles=<C> instructions=<I> extra=<C-I>`, `dma: cycles=<C> instructions=<I> extra=<C-I>` and
`stolen by DMA: <extra of dma - extra of loop>`.

Write `p49_main` as a subroutine ending with `ret`; every label starts with `p49_`; keep sp and s0-s11.

Example input:
```
100 16
```
Output:
```
loop: sum=5050 cycles=301 instructions=300 extra=1
dma: cycles=40 instructions=7 extra=33
stolen by DMA: 32
```
Library: rcv_read_dec, rcv_puts, rcv_print_dec, rcv_newline.

Your block: CYCLE counts every clock, INSTRET only committed instructions: the difference shows the stalled cycles.

Your program is a subroutine: it starts at `p49_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **BGE**;
your review partners (E2) are P66 (Reset controller) and P50 (Multiplier (shift and add)).
