# P47 - Interrupt controller

**Group:** F. Input/output devices · **Syllabus focus:** Unit 2 (Digital components), Unit 4 (Basic computer organisation), Unit 6 (Memory and I/O)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

Slot 4: PENDING (sources: 0 timer, 1 keyboard, 2 DMA, 3 stack guard, 4 software), MASK, CAUSE (highest-priority = lowest-numbered pending and unmasked source, 31 if none), SWI. It is I/O device slot 4 (registers at 0x00020100; register 15 must read 47, the package number).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P47.dig` | your circuit in Digital |
| `p47_irq_ctrl.v` | the same block in Verilog |
| `p47.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P47.dig`)

The priority encoder: masking AND gates and a 5-input priority encoder from gates.

| Direction | Name | Bits |
|---|---|---|
| input | `lines` | 5 |
| input | `mask` | 5 |
| output | `irq` | 1 |
| output | `cause` | 5 |

Allowed parts: And, Or, Not, NAnd, NOr, XOr, XNOr + wiring parts. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p47_irq_ctrl.v`)

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
| input | `lines` | 4 |
| output | `irq` | 1 |
| output | `cause` | 5 |

Clocked: everything changes on the rising edge of `clk`.
The test bench is `tests/tb_p47_irq_ctrl.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p47.s`)

# P47 program: Timer interrupt ticks

Read N (1..20). Install an interrupt handler (save/restore `mtvec`). Set TIMER_COUNT = 0, TIMER_CMP = 300,
IRQ_MASK bit 0, TIMER_CTRL = 3 (enable + interrupt enable), then mstatus.MIE. The handler (saving every register it
uses) writes TIMER_COUNT = 0, writes TIMER_STATUS (clears the match), adds 1 to a tick counter in memory and returns
with `mret`. Main waits until the counter changes and prints `tick <k>` (k = 1, 2, ...) until N ticks are printed.
Then disable MIE, stop the timer, clear IRQ_MASK, restore `mtvec` and print `done`.

Write `p47_main` as a subroutine ending with `ret`; every label starts with `p47_`; keep sp and s0-s11.

Example input:
```
5
```
Output:
```
tick 1
tick 2
tick 3
tick 4
tick 5
done
```
Library: rcv_read_dec, rcv_puts, rcv_print_dec, rcv_newline (only in main).

Your block: the interrupt comes from your timer and passes through the interrupt controller (cause 0).

Your program is a subroutine: it starts at `p47_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **BNE (not taken)**;
your review partners (E2) are P46 (Timer) and P48 (DMA controller).
