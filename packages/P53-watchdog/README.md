# P53 - Watchdog timer

**Group:** G. Measurement and support devices · **Syllabus focus:** Unit 6 (Memory and I/O)
**Work:** hardware ●○○ + program ●●● = the same total as every other package

Slot 11: LOAD, CTRL bit0 enable, STATUS bit0 = bite, COUNT, KICK. Counts down; reaching 0 bites and reloads. A program must keep kicking it. It is I/O device slot 11 (registers at 0x000202C0; register 15 must read 53, the package number).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P53.dig` | your circuit in Digital |
| `p53_watchdog.v` | the same block in Verilog |
| `p53.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P53.dig`)

8-bit down counter with reload and the sticky bite flag.

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `rst` | 1 |
| input | `en` | 1 |
| input | `kick` | 1 |
| input | `load` | 8 |
| output | `count` | 8 |
| output | `bite` | 1 |

Allowed parts: all of the above + Add, Sub, Comparator, Neg. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p53_watchdog.v`)

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

Clocked: everything changes on the rising edge of `clk`.
The test bench is `tests/tb_p53_watchdog.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p53.s`)

# P53 program: Watchdog

Read K (1..9) and W (work size). Set WDT_LOAD = 1000, write WDT_STATUS (clear), then WDT_CTRL = 1. For chunk
k = 1..K: do W iterations of an empty counting loop, read WDT_STATUS bit 0 (bite), clear it, kick (write WDT_KICK)
and print `chunk k: ok` (no bite) or `chunk k: bitten`. Then stop kicking: wait until WDT_STATUS bit 0 is 1, write
WDT_CTRL = 0, clear WDT_STATUS and print `watchdog bit`. (W <= 50 never bites, W >= 600 always bites.)

Write `p53_main` as a subroutine ending with `ret`; every label starts with `p53_`; keep sp and s0-s11.

Example input:
```
5 20
```
Output:
```
chunk 1: ok
chunk 2: ok
chunk 3: ok
chunk 4: ok
chunk 5: ok
watchdog bit
```
Library: rcv_read_dec, rcv_puts, rcv_putc, rcv_newline.

Your block: your watchdog counts down from LOAD, sets the sticky bite bit at 0 and reloads on KICK.

Your program is a subroutine: it starts at `p53_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **LBU**;
your review partners (E2) are P52 (Binary-to-BCD converter) and P54 (Random numbers (LFSR)).
