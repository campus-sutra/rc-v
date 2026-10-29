# P62 - Interrupt latency meter

**Group:** G. Measurement and support devices · **Syllabus focus:** Unit 4 (Basic computer organisation), Unit 6 (Memory and I/O)
**Work:** hardware ●○○ + program ●●● = the same total as every other package

Slot 20: LAST, MAX, CLEAR, COUNT - how many cycles an enabled interrupt waits before it is taken. It is I/O device slot 20 (registers at 0x00020500; register 15 must read 62, the package number).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P62.dig` | your circuit in Digital |
| `p62_irq_latency.v` | the same block in Verilog |
| `p62.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P62.dig`)

A counter, a LAST register and a MAX register with a comparator.

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `rst` | 1 |
| input | `irq_line` | 1 |
| input | `trap_irq` | 1 |
| input | `clear` | 1 |
| output | `last` | 8 |
| output | `max` | 8 |

Allowed parts: all of the above + Add, Sub, Comparator, Neg. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p62_irq_latency.v`)

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
| input | `irq_line` | 1 |
| input | `trap_irq` | 1 |

Clocked: everything changes on the rising edge of `clk`.
The test bench is `tests/tb_p62_irq_latency.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p62.s`)

# P62 program: Interrupt latency during DMA

Read L (1..100, DMA words) and C. Install a timer interrupt handler (save/restore `mtvec`) that writes
TIMER_CTRL = 0, writes TIMER_STATUS and counts in memory (`mret`). Set IRQ_MASK bit 0, write IRQLAT_CLEAR, set
MIE. Round k = 1..5: TIMER_COUNT = 0, TIMER_CMP = k * C, DMA_SRC/DST/LEN (L words between two RAM buffers), then
two stores **right after each other**: TIMER_CTRL = 3 and DMA_CTRL = 1. Wait for the interrupt, clear DMA_STATUS
and print `round k: cmp=<k*C> latency=<IRQLAT_LAST>`. Finally disable MIE, clear IRQ_MASK, restore `mtvec` and
print `max latency: <IRQLAT_MAX>`. (The CPU cannot take an interrupt while the DMA owns the bus.)

Write `p62_main` as a subroutine ending with `ret`; every label starts with `p62_`; keep sp and s0-s11.

Example input:
```
50 20
```
Output:
```
round 1: cmp=20 latency=80
round 2: cmp=40 latency=60
round 3: cmp=60 latency=40
round 4: cmp=80 latency=20
round 5: cmp=100 latency=0
max latency: 80
```
Library: rcv_read_dec, rcv_puts, rcv_print_dec, rcv_newline (only in main).

Your block: your meter counts the cycles the interrupt line is high before the trap is taken: max(0, 2L - CMP).

Your program is a subroutine: it starts at `p62_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **ANDI**;
your review partners (E2) are P61 (Text screen) and P63 (Hardware stack).
