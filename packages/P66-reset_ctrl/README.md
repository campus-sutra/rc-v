# P66 - Reset controller

**Group:** G. Measurement and support devices · **Syllabus focus:** Unit 1 (Digital logic circuits), Unit 4 (Basic computer organisation)
**Work:** hardware ●○○ + program ●●● = the same total as every other package

Holds rst high for 4 clock cycles after power-on or after the reset button.

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P66.dig` | your circuit in Digital |
| `p66_reset_ctrl.v` | the same block in Verilog |
| `p66.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P66.dig`)

A 3-bit counter that stops at 4.

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `btn` | 1 |
| output | `rst` | 1 |

Allowed parts: gates + D_FF, JK_FF, T_FF, RS_FF. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p66_reset_ctrl.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `btn` | 1 |
| output | `rst` | 1 |

Clocked: everything changes on the rising edge of `clk`.
The test bench is `tests/tb_p66_reset_ctrl.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p66.s`)

# P66 program: Power-on self test

Read n (1..16) and an LED pattern in hex. Print `POST`. RAM test with 0x55555555, then 0xAAAAAAAA: write the
pattern to all 32 words of a RAM buffer, read all back, print `RAM <pattern, 8 hex>: OK` (or `: FAIL`). Put the 16
words k * 0x01010101 (k = 1..16) in a `.rodata` table and print `ROM checksum: <sum of the first n words, 8 hex>`.
Write the pattern to GPIO_LEDS and read it back: `LEDS <pattern, 8 hex>: OK` if equal, else `: FAIL`. Poll
UART_TXSTATUS up to 100 times: `UART: OK` if bit 0 became 1, else `UART: FAIL`. Finally print `POST passed` or
`POST failed (<k> errors)`.

Write `p66_main` as a subroutine ending with `ret`; every label starts with `p66_`; keep sp and s0-s11.

Example input:
```
4
12345
```
Output:
```
POST
RAM 55555555: OK
RAM AAAAAAAA: OK
ROM checksum: 0A0A0A0A
LEDS 00012345: FAIL
UART: OK
POST failed (1 errors)
```
Library: rcv_read_dec, rcv_read_hex, rcv_puts, rcv_print_hex, rcv_print_dec, rcv_newline.

Your block: a self test is what the processor runs right after your reset controller releases rst.

Your program is a subroutine: it starts at `p66_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **ADD**;
your review partners (E2) are P65 (Complement unit (r and r-1 complements)) and P49 (Performance counters).
