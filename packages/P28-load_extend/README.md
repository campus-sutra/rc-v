# P28 - Load extender

**Group:** D. Memory and bus · **Syllabus focus:** Unit 2 (Digital components), Unit 3 (Data representation), Unit 6 (Memory and I/O)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

LW (2): the word. LB (0): byte lane addr_lo, sign-extended. LBU (4): the same byte, zero-extended.

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P28.dig` | your circuit in Digital |
| `p28_load_extend.v` | the same block in Verilog |
| `p28.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P28.dig`)

Full size: a byte multiplexer and sign-extension logic.

| Direction | Name | Bits |
|---|---|---|
| input | `raw` | 32 |
| input | `addr_lo` | 2 |
| input | `funct3` | 3 |
| output | `val` | 32 |

Allowed parts: gates + Multiplexer, Demultiplexer, Decoder, PriorityEncoder. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p28_load_extend.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `raw` | 32 |
| input | `addr_lo` | 2 |
| input | `funct3` | 3 |
| output | `val` | 32 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p28_load_extend.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p28.s`)

# P28 program: lb versus lbu  (●●○)

Read lines with a signed decimal number from -128 to 127, until a line `end`. Read each line with rcv_read_line and convert it yourself (optional `-`, then digits). Store the number as a byte with `sb`, load it back with `lb` and with `lbu`, and print both.
Output per number: `lb = <n>, lbu = <n>`.

Example input:
```
-1
5
end
```
Output:
```
lb = -1, lbu = 255
lb = 5, lbu = 5
```

You may use the library routines: rcv_read_line, rcv_print_dec, rcv_puts, rcv_newline.
This exercises your block: `lb` sign-extends and `lbu` zero-extends in your load extender.

Your program is a subroutine: it starts at `p28_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **SLT**;
your review partners (E2) are P27 (Store aligner) and P29 (Data memory).
