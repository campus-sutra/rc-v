# P27 - Store aligner

**Group:** D. Memory and bus · **Syllabus focus:** Unit 2 (Digital components), Unit 6 (Memory and I/O)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

SW: wdata = rs2, be = 1111. SB: the low byte copied into all four lanes and be = one-hot byte lane from addr_lo (little-endian).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P27.dig` | your circuit in Digital |
| `p27_store_align.v` | the same block in Verilog |
| `p27.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P27.dig`)

Full size: a Decoder for the byte lane, multiplexers for the data.

| Direction | Name | Bits |
|---|---|---|
| input | `funct3` | 3 |
| input | `addr_lo` | 2 |
| input | `rs2` | 32 |
| output | `wdata` | 32 |
| output | `be` | 4 |

Allowed parts: gates + Multiplexer, Demultiplexer, Decoder, PriorityEncoder. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p27_store_align.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `funct3` | 3 |
| input | `addr_lo` | 2 |
| input | `rs2` | 32 |
| output | `wdata` | 32 |
| output | `be` | 4 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p27_store_align.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p27.s`)

# P27 program: Little-endian bytes  (●●○)

Clear an 8-byte word-aligned RAM buffer with two `sw zero`. Read a word with rcv_getc until the newline, storing character k at byte k with `sb` (keep at most 8 characters, ignore the rest). Then load the buffer as two words with `lw` and print them in hex.
Output: `word 0 = <8 hex digits>` and `word 1 = <8 hex digits>`.

Example input:
```
Hello
```
Output:
```
word 0 = 6C6C6548
word 1 = 0000006F
```

You may use the library routines: rcv_getc, rcv_print_hex, rcv_puts, rcv_newline.
This exercises your block: `sb` puts the byte into the right lane, exactly what your store aligner does.

Your program is a subroutine: it starts at `p27_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **SLL**;
your review partners (E2) are P36 (Cache statistics counters) and P28 (Load extender).
