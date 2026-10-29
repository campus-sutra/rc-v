# P11 - Register-file write decoder

**Group:** B. Registers and program counter · **Syllabus focus:** Unit 2 (Digital components)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

One-hot write enables: wen[rd] = we, except register x0 which is never written.

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P11.dig` | your circuit in Digital |
| `p11_rf_decoder.v` | the same block in Verilog |
| `p11.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P11.dig`)

Full size: build the 5-to-32 decoder from one 2-to-4 and four 3-to-8 Decoder parts plus AND gates.

| Direction | Name | Bits |
|---|---|---|
| input | `we` | 1 |
| input | `rd` | 5 |
| output | `wen` | 32 |

Allowed parts: gates + Multiplexer, Demultiplexer, Decoder, PriorityEncoder. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p11_rf_decoder.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `we` | 1 |
| input | `rd` | 5 |
| output | `wen` | 32 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p11_rf_decoder.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p11.s`)

# P11 program: Binary and one bits  (●●○)

Read a signed decimal number N. Print all 32 bits of N (bit 31 first) and the number of bits that are 1.
Output: `binary: ` followed by 32 characters `0`/`1`, then a line `ones: <count>`.

Example input:
```
10
```
Output:
```
binary: 00000000000000000000000000001010
ones: 2
```

You may use the library routines: rcv_read_dec, rcv_print_udec, rcv_putc, rcv_puts, rcv_newline.

Your program is a subroutine: it starts at `p11_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **LB**;
your review partners (E2) are P14 (Program counter register) and P12 (Register-file storage).
