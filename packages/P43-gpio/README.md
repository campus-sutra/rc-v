# P43 - LEDs, display register and buttons

**Group:** F. Input/output devices · **Syllabus focus:** Unit 2 (Digital components), Unit 6 (Memory and I/O)
**Work:** hardware ●○○ + program ●●● = the same total as every other package

Slot 2: LEDS (16 bits, read/write), SEG (32 bits, read/write, shown on the hex display), BUTTONS (read the 8 button inputs). It is I/O device slot 2 (registers at 0x00020080; register 15 must read 43, the package number).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P43.dig` | your circuit in Digital |
| `p43_gpio.v` | the same block in Verilog |
| `p43.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P43.dig`)

8-bit LED register plus the read multiplexer.

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `rst` | 1 |
| input | `we` | 1 |
| input | `ridx` | 2 |
| input | `wdata` | 8 |
| input | `buttons` | 8 |
| output | `rdata` | 8 |
| output | `leds` | 8 |

Allowed parts: gates + multiplexer/decoder parts + flip-flops. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p43_gpio.v`)

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
| input | `buttons` | 8 |
| output | `leds` | 16 |
| output | `seg` | 32 |

Clocked: everything changes on the rising edge of `clk`.
The test bench is `tests/tb_p43_gpio.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p43.s`)

# P43 program: Knight Rider LEDs

Read N (1..40). Show a running light on GPIO_LEDS for N steps: one LED lit, starting at bit 0 and moving up by
one each step to bit 15, then back down to bit 0, and so on. In each step write the pattern to GPIO_LEDS, read
GPIO_LEDS back and print the value read as 16 binary digits (bit 15 first). After the last step print
`buttons: <GPIO_BUTTONS, 8 hex digits>`.

Write `p43_main` as a subroutine ending with `ret`; every label starts with `p43_`; keep sp and s0-s11.

Example input:
```
3
```
Output:
```
0000000000000001
0000000000000010
0000000000000100
buttons: 000000A5
```
Library: rcv_read_dec, rcv_putc, rcv_puts, rcv_print_hex, rcv_newline.

Your block: you write and read back your LEDS register and read your BUTTONS inputs.

Your program is a subroutine: it starts at `p43_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **AUIPC**;
your review partners (E2) are P42 (Keyboard input) and P44 (Seven-segment decoder).
