# P33 - I/O read bus

**Group:** D. Memory and bus · **Syllabus focus:** Unit 2 (Digital components), Unit 6 (Memory and I/O)
**Work:** hardware ●○○ + program ●●● = the same total as every other package

Selects the read data of device slot dev out of all 32 devices' data (slot k in bits 32k+31..32k).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P33.dig` | your circuit in Digital |
| `p33_io_bus_mux.v` | the same block in Verilog |
| `p33.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P33.dig`)

4 devices x 4 bits.

| Direction | Name | Bits |
|---|---|---|
| input | `dev_flat` | 16 |
| input | `dev` | 2 |
| output | `rdata` | 4 |

Allowed parts: gates + Multiplexer, Demultiplexer, Decoder, PriorityEncoder. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p33_io_bus_mux.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `dev_flat` | 1024 |
| input | `dev` | 5 |
| output | `rdata` | 32 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p33_io_bus_mux.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p33.s`)

# P33 program: Device census  (●●●)

Read two slot numbers FIRST and LAST (0-31, on one line). For every slot from FIRST to LAST, load register 15 (the device ID) at IO_BASE + slot*64 + 60. An empty slot reads 0.
Output: a line `slot <n>: <ID in decimal>` for every slot with a non-zero ID, then `devices found: <count>`.

Example input:
```
8 10
```
Output:
```
slot 8: 50
slot 9: 51
slot 10: 52
devices found: 3
```

You may use the library routines: rcv_read_dec, rcv_print_udec, rcv_puts, rcv_newline.
This exercises your block: every ID you read travels through your I/O read bus.

Your program is a subroutine: it starts at `p33_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **OR**;
your review partners (E2) are P32 (Memory read selector) and P34 (Bus arbiter (CPU vs DMA)).
