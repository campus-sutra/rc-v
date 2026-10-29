# P54 - Random numbers (LFSR)

**Group:** G. Measurement and support devices · **Syllabus focus:** Unit 2 (Digital components)
**Work:** hardware ●○○ + program ●●● = the same total as every other package

Slot 12: SEED, VALUE (read steps the generator), PEEK. A 16-bit Galois LFSR with taps 0xB400. It is I/O device slot 12 (registers at 0x00020300; register 15 must read 54, the package number).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P54.dig` | your circuit in Digital |
| `p54_rng_lfsr.v` | the same block in Verilog |
| `p54.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P54.dig`)

16 D flip-flops and XOR gates.

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `rst` | 1 |
| input | `seed_we` | 1 |
| input | `seed` | 16 |
| input | `step` | 1 |
| output | `value` | 16 |

Allowed parts: gates + multiplexer/decoder parts + flip-flops. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p54_rng_lfsr.v`)

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
The test bench is `tests/tb_p54_rng_lfsr.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p54.s`)

# P54 program: Dice with the random number generator

Read a seed and write it to RNG_SEED. Roll two dice 10 times; a die is `RNG_VALUE mod 6 + 1` (read RNG_VALUE
once per die, first die first; use `rcv_udiv` for the remainder). Print `roll k: d1 d2`, followed by ` double`
when d1 = d2. At the end print `doubles: <count>`.

Write `p54_main` as a subroutine ending with `ret`; every label starts with `p54_`; keep sp and s0-s11.

Example input:
```
2026
```
Output:
```
roll 1: 5 6
roll 2: 3 2
roll 3: 1 4
roll 4: 2 4
roll 5: 6 6 double
roll 6: 2 1
roll 7: 4 3
roll 8: 5 6
roll 9: 1 4
roll 10: 1 1 double
doubles: 2
```
Library: rcv_read_dec, rcv_udiv, rcv_puts, rcv_putc, rcv_print_dec, rcv_newline.

Your block: every read of VALUE steps your LFSR once.

Your program is a subroutine: it starts at `p54_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **LW**;
your review partners (E2) are P53 (Watchdog timer) and P55 (Stack guard).
