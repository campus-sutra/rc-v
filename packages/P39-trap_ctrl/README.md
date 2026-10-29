# P39 - Trap controller

**Group:** E. Traps and interrupts · **Syllabus focus:** Unit 4 (Basic computer organisation)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

Decides whether this cycle traps: an enabled interrupt (cause 0x80000010 + irq_cause), else an illegal instruction (2), else ECALL (11). Never while stalled.

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P39.dig` | your circuit in Digital |
| `p39_trap_ctrl.v` | the same block in Verilog |
| `p39.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P39.dig`)

Full size: gates plus an adder for 0x80000010 + irq_cause (or wiring).

| Direction | Name | Bits |
|---|---|---|
| input | `stall` | 1 |
| input | `irq` | 1 |
| input | `irq_cause` | 5 |
| input | `mie` | 1 |
| input | `illegal` | 1 |
| input | `is_ecall` | 1 |
| output | `trap` | 1 |
| output | `cause` | 32 |

Allowed parts: all of the above + Add, Sub, Comparator, Neg. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p39_trap_ctrl.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `stall` | 1 |
| input | `irq` | 1 |
| input | `irq_cause` | 5 |
| input | `mie` | 1 |
| input | `illegal` | 1 |
| input | `is_ecall` | 1 |
| output | `trap` | 1 |
| output | `cause` | 32 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p39_trap_ctrl.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p39.s`)

# P39 program: Software interrupt

Read N (0..9). Install an interrupt handler (save/restore `mtvec`), set IRQ_MASK bit 4 (software interrupt) and
then mstatus.MIE (`li t0, 8` / `csrs mstatus, t0`). Raise the interrupt N times by writing 1 to IRQ_SWI.
The handler saves every register it uses, writes 0 to IRQ_SWI, counts and prints `tick <count>`, and returns with
`mret`. Afterwards disable interrupts (`csrc mstatus, t0`), clear IRQ_MASK, restore `mtvec` and print `done`.

Write `p39_main` as a subroutine ending with `ret`; every label starts with `p39_`; keep sp and s0-s11.

Example input:
```
3
```
Output:
```
tick 1
tick 2
tick 3
done
```
Library: rcv_read_dec, rcv_puts, rcv_print_dec, rcv_newline.

Your block: your trap controller turns the pending interrupt into a trap (mcause 0x80000014) before the next instruction.

Your program is a subroutine: it starts at `p39_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **LW from an I/O device**;
your review partners (E2) are P38 (CSR read-modify-write) and P40 (Illegal-instruction detector).
