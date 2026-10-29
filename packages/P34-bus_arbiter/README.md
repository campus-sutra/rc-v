# P34 - Bus arbiter (CPU vs DMA)

**Group:** D. Memory and bus · **Syllabus focus:** Unit 6 (Memory and I/O)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

When the DMA controller requests the bus it gets it (cycle stealing): the processor stalls and the memory sees the DMA address/data; otherwise the processor's.

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P34.dig` | your circuit in Digital |
| `p34_bus_arbiter.v` | the same block in Verilog |
| `p34.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P34.dig`)

4-bit version.

| Direction | Name | Bits |
|---|---|---|
| input | `dma_req` | 1 |
| input | `cpu_addr` | 4 |
| input | `cpu_wdata` | 4 |
| input | `cpu_we` | 1 |
| input | `cpu_be` | 4 |
| input | `dma_addr` | 4 |
| input | `dma_wdata` | 4 |
| input | `dma_we` | 1 |
| output | `grant` | 1 |
| output | `stall` | 1 |
| output | `addr` | 4 |
| output | `wdata` | 4 |
| output | `we` | 1 |
| output | `be` | 4 |

Allowed parts: gates + Multiplexer, Demultiplexer, Decoder, PriorityEncoder. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p34_bus_arbiter.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `dma_req` | 1 |
| input | `cpu_addr` | 32 |
| input | `cpu_wdata` | 32 |
| input | `cpu_we` | 1 |
| input | `cpu_be` | 4 |
| input | `dma_addr` | 32 |
| input | `dma_wdata` | 32 |
| input | `dma_we` | 1 |
| output | `grant` | 1 |
| output | `stall` | 1 |
| output | `addr` | 32 |
| output | `wdata` | 32 |
| output | `we` | 1 |
| output | `be` | 4 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p34_bus_arbiter.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p34.s`)

# P34 program: Copy a string word by word

Read one line (at most 60 characters) into a word-aligned RAM buffer with `rcv_read_line`. Copy it to a second
buffer **a whole word at a time** with `lw`/`sw` (no `lbu`/`sb`), including the word that holds the terminating
0 byte: the number of words is `length / 4 + 1`. Then print the copy (from the second buffer) and the number of
words. Output: `copy: <text>` and `words: <n>`, each on its own line.

Write `p34_main` as a subroutine ending with `ret`; every label starts with `p34_`; keep sp and s0-s11.

Example input:
```
Hello, RC-V world!
```
Output:
```
copy: Hello, RC-V world!
words: 5
```
Library: rcv_read_line, rcv_puts, rcv_print_dec, rcv_newline.

Your block: every `lw`/`sw` of the copy passes through your bus arbiter while the DMA is idle (the CPU gets the bus).

Your program is a subroutine: it starts at `p34_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **AND**;
your review partners (E2) are P33 (I/O read bus) and P35 (Cache tag store).
