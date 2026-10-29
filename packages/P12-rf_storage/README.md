# P12 - Register-file storage

**Group:** B. Registers and program counter · **Syllabus focus:** Unit 1 (Digital logic circuits), Unit 2 (Digital components)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

32 registers of 32 bits. On the clock edge every register whose wen bit is 1 loads wd; rst=1 clears all. Register 0 always stays 0. q_flat holds all registers side by side (register k in bits 32k+31..32k).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P12.dig` | your circuit in Digital |
| `p12_rf_storage.v` | the same block in Verilog |
| `p12.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P12.dig`)

4 registers x 4 bits from D flip-flops; register 0 is wired to 0.

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `rst` | 1 |
| input | `wen` | 4 |
| input | `wd` | 4 |
| output | `q_flat` | 16 |

Allowed parts: gates + multiplexer/decoder parts + flip-flops. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p12_rf_storage.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `rst` | 1 |
| input | `wen` | 32 |
| input | `wd` | 32 |
| output | `q_flat` | 1024 |

Clocked: everything changes on the rising edge of `clk`.
The test bench is `tests/tb_p12_rf_storage.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p12.s`)

# P12 program: Reverse a line  (●●○)

Read one line of text (at most 80 characters) and print it backwards, then its length.
Output: the reversed line, then a line `length: <n>`.

Example input:
```
Hello, RC-V
```
Output:
```
V-CR ,olleH
length: 11
```

You may use the library routines: rcv_read_line, rcv_putc, rcv_print_udec, rcv_puts, rcv_newline.

Your program is a subroutine: it starts at `p12_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **LBU**;
your review partners (E2) are P11 (Register-file write decoder) and P13 (Register-file read port).
