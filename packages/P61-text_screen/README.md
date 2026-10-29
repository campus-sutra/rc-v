# P61 - Text screen

**Group:** G. Measurement and support devices · **Syllabus focus:** Unit 2 (Digital components), Unit 6 (Memory and I/O)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

Slot 19: a 4 x 16 character screen. CHAR (write at cursor and advance, newline goes to the next row), CURSOR, CLEAR, READ. dbg_addr/dbg_char let the test bench read the screen. It is I/O device slot 19 (registers at 0x000204C0; register 15 must read 61, the package number).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P61.dig` | your circuit in Digital |
| `p61_text_screen.v` | the same block in Verilog |
| `p61.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P61.dig`)

The cursor logic: a 6-bit register, +1, next-row and wrap-around.

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `rst` | 1 |
| input | `put` | 1 |
| input | `newline` | 1 |
| input | `clear` | 1 |
| output | `cursor` | 6 |

Allowed parts: all of the above + Add, Sub, Comparator, Neg. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p61_text_screen.v`)

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
| input | `dbg_addr` | 6 |
| output | `dbg_char` | 8 |

Clocked: everything changes on the rising edge of `clk`.
The test bench is `tests/tb_p61_text_screen.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p61.s`)

# P61 program: Word wrap on the text screen

Write SCREEN_CLEAR. Read up to 4 lines (at most 80 characters; words of at most 16 characters separated by
spaces); an empty line ends the input early. The text always fits on the 4 x 16 screen. Each input line starts at
the start of a row (write a newline character to SCREEN_CHAR if the cursor column, SCREEN_CURSOR mod 16, is not 0).
Before each word that is not at the start of a row write one space, or a newline if column + 1 + length > 16.
Print `words: <number of words>` on the terminal. (The checker prints the screen after your output.)

Write `p61_main` as a subroutine ending with `ret`; every label starts with `p61_`; keep sp and s0-s11.

Example input:
```
The quick brown fox jumps over
the lazy dog
```
Output:
```
words: 9
[screen]
|The quick brown |
|fox jumps over  |
|the lazy dog    |
|                |
```
Library: rcv_read_line, rcv_puts, rcv_print_dec, rcv_newline.

Your block: you drive your screen through CHAR (with newline) and read CURSOR back.

Your program is a subroutine: it starts at `p61_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **ORI**;
your review partners (E2) are P60 (Parity generator) and P62 (Interrupt latency meter).
