# P29 - Data memory

**Group:** D. Memory and bus · **Syllabus focus:** Unit 2 (Digital components), Unit 6 (Memory and I/O)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

4096 words. Reading is immediate (rdata = mem[addr]); on the clock edge, if we=1, the bytes whose be bit is 1 are written.

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P29.dig` | your circuit in Digital |
| `p29_data_ram.v` | the same block in Verilog |
| `p29.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P29.dig`)

4 words x 8 bits from D flip-flops: address decoder for writing, multiplexer for reading.

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `we` | 1 |
| input | `addr` | 2 |
| input | `wdata` | 8 |
| output | `rdata` | 8 |

Allowed parts: gates + multiplexer/decoder parts + flip-flops. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p29_data_ram.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `we` | 1 |
| input | `addr` | 12 |
| input | `be` | 4 |
| input | `wdata` | 32 |
| output | `rdata` | 32 |

Clocked: everything changes on the rising edge of `clk`.
The test bench is `tests/tb_p29_data_ram.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p29.s`)

# P29 program: RAM test  (●●○)

Read a signed decimal K. Fill 64 words of a RAM array with 0, K, 2K, ... 63K (add K each time), then read all 64 words back, check each against the expected value and add them up.
Output: `RAM OK` and `sum = <signed decimal>`; if a word is wrong print `RAM error at <8 hex digit address>` instead.

Example input:
```
3
```
Output:
```
RAM OK
sum = 6048
```

You may use the library routines: rcv_read_dec, rcv_print_dec, rcv_print_hex, rcv_puts, rcv_newline.
This exercises your block: every `sw`/`lw` here goes to your data memory.

Your program is a subroutine: it starts at `p29_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **SLTU**;
your review partners (E2) are P28 (Load extender) and P30 (Boot ROM).
