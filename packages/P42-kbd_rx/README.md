# P42 - Keyboard input

**Group:** F. Input/output devices · **Syllabus focus:** Unit 6 (Memory and I/O)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

Slot 1: RXDATA (read: the character, which leaves the buffer), RXSTATUS bit0 = character waiting, PEEK (read without removing). A new key (ext_valid/ext_char) is taken (ext_take=1) when the buffer is empty and RXDATA is not being read. irq = character waiting. It is I/O device slot 1 (registers at 0x00020040; register 15 must read 42, the package number).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P42.dig` | your circuit in Digital |
| `p42_kbd_rx.v` | the same block in Verilog |
| `p42.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P42.dig`)

The one-character buffer and its full flag.

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `rst` | 1 |
| input | `ext_valid` | 1 |
| input | `ext_char` | 8 |
| input | `pop` | 1 |
| output | `data` | 8 |
| output | `full` | 1 |
| output | `take` | 1 |

Allowed parts: gates + multiplexer/decoder parts + flip-flops. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p42_kbd_rx.v`)

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
| input | `ext_valid` | 1 |
| input | `ext_char` | 8 |
| output | `ext_take` | 1 |
| output | `irq` | 1 |

Clocked: everything changes on the rising edge of `clk`.
The test bench is `tests/tb_p42_kbd_rx.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p42.s`)

# P42 program: Upper-case echo with your own getc

Write your own `p42_getc` that waits until bit 0 of KBD_RXSTATUS is 1 and then reads KBD_RXDATA. Read characters
with it and echo each one, with `a`..`z` changed to `A`..`Z` (everything else, newlines too, unchanged), until a
`.` arrives. Do not echo the `.`: print a newline instead and return.

Write `p42_main` as a subroutine ending with `ret`; every label starts with `p42_`; keep sp and s0-s11.

Example input:
```
Hello, World 42!
abc.xyz
```
Output:
```
HELLO, WORLD 42!
ABC
```
Library: rcv_putc, rcv_newline (not rcv_getc).

Your block: reading RXDATA empties your keyboard buffer so that the next key can come in.

Your program is a subroutine: it starts at `p42_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **LUI**;
your review partners (E2) are P41 (Terminal output (UART)) and P43 (LEDs, display register and buttons).
