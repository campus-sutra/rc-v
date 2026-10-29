# P48 - DMA controller

**Group:** F. Input/output devices · **Syllabus focus:** Unit 6 (Memory and I/O)
**Work:** hardware ●●● + program ●○○ = the same total as every other package

Slot 5: SRC, DST, LEN (words), CTRL (bit0 start, bit1 interrupt enable), STATUS (bit0 busy, bit1 done). Copies LEN words, each in a READ cycle and a WRITE cycle stolen from the processor. It is I/O device slot 5 (registers at 0x00020140; register 15 must read 48, the package number).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P48.dig` | your circuit in Digital |
| `p48_dma.v` | the same block in Verilog |
| `p48.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P48.dig`)

The control FSM: idle/read/write states and a 4-bit length counter.

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `rst` | 1 |
| input | `start` | 1 |
| input | `len` | 4 |
| output | `busy` | 1 |
| output | `phase` | 1 |
| output | `done` | 1 |

Allowed parts: gates + multiplexer/decoder parts + flip-flops. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p48_dma.v`)

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
| output | `req` | 1 |
| output | `m_addr` | 32 |
| output | `m_we` | 1 |
| output | `m_wdata` | 32 |
| input | `m_rdata` | 32 |
| output | `irq` | 1 |

Clocked: everything changes on the rising edge of `clk`.
The test bench is `tests/tb_p48_dma.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p48.s`)

# P48 program: Copy a line with DMA

Read a line (at most 60 characters) into a word-aligned buffer. Copy `length / 4 + 1` words to a second buffer
with the DMA controller: write DMA_SRC, DMA_DST, DMA_LEN, then DMA_CTRL = 1; wait until DMA_STATUS bit 1 (done)
is 1, then write DMA_STATUS to clear it. Print `copy: <text of the second buffer>`.

Write `p48_main` as a subroutine ending with `ret`; every label starts with `p48_`; keep sp and s0-s11.

Example input:
```
DMA moves data without the CPU
```
Output:
```
copy: DMA moves data without the CPU
```
Library: rcv_read_line, rcv_puts, rcv_newline.

Your block: your DMA controller does the whole copy in READ/WRITE bus cycles.

Your program is a subroutine: it starts at `p48_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **BLT**;
your review partners (E2) are P47 (Interrupt controller) and P41 (Terminal output (UART)).
