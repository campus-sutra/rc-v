# P41 - Terminal output (UART)

**Group:** F. Input/output devices · **Syllabus focus:** Unit 6 (Memory and I/O)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

Slot 0: TXDATA (write a character), TXSTATUS bit0 = ready. After accepting a character the terminal is busy for 4 cycles; writes while busy are lost. tx_valid/tx_char show the character accepted at the last clock edge. It is I/O device slot 0 (registers at 0x00020000; register 15 must read 41, the package number).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P41.dig` | your circuit in Digital |
| `p41_uart_tx.v` | the same block in Verilog |
| `p41.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P41.dig`)

The busy logic: a 3-bit down counter loaded with 4 when a write is accepted.

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `rst` | 1 |
| input | `write` | 1 |
| output | `ready` | 1 |
| output | `accept` | 1 |

Allowed parts: gates + multiplexer/decoder parts + flip-flops. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p41_uart_tx.v`)

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
| output | `tx_valid` | 1 |
| output | `tx_char` | 8 |

Clocked: everything changes on the rising edge of `clk`.
The test bench is `tests/tb_p41_uart_tx.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p41.s`)

# P41 program: Framed banner with your own putc

Read one line (0..40 characters) and print it inside a frame: a border line `+`, (length + 2) times `-`, `+`;
then `| <text> |`; then the border again. Write your own `p41_putc` that waits until bit 0 of UART_TXSTATUS is 1
and then writes the character to UART_TXDATA, and use it for **all** output (not rcv_putc or rcv_puts).

Write `p41_main` as a subroutine ending with `ret`; every label starts with `p41_`; keep sp and s0-s11.

Example input:
```
Hello RC-V
```
Output:
```
+------------+
| Hello RC-V |
+------------+
```
Library: rcv_read_line only.

Your block: your putc does what your UART expects: poll ready, then write (a write while busy would be lost).

Your program is a subroutine: it starts at `p41_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **a DMA-stolen cycle**;
your review partners (E2) are P48 (DMA controller) and P42 (Keyboard input).
