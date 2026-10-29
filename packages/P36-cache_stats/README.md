# P36 - Cache statistics counters

**Group:** D. Memory and bus · **Syllabus focus:** Unit 6 (Memory and I/O)
**Work:** hardware ●○○ + program ●●● = the same total as every other package

I/O device (slot 7): HITS, MISSES, CLEAR. Counts each access as a hit or a miss. It is I/O device slot 7 (registers at 0x000201C0; register 15 must read 36, the package number).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P36.dig` | your circuit in Digital |
| `p36_cache_stats.v` | the same block in Verilog |
| `p36.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P36.dig`)

Two 8-bit counters with clear, from flip-flops (no Counter part).

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `rst` | 1 |
| input | `access` | 1 |
| input | `hit` | 1 |
| input | `clear` | 1 |
| output | `hits` | 8 |
| output | `misses` | 8 |

Allowed parts: gates + multiplexer/decoder parts + flip-flops. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p36_cache_stats.v`)

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
| input | `access` | 1 |
| input | `hit` | 1 |

Clocked: everything changes on the rising edge of `clk`.
The test bench is `tests/tb_p36_cache_stats.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p36.s`)

# P36 program: Cache experiment: sequential versus stride

Read a stride s (1..256). Fill a 256-word array (start it on a 16-byte boundary with `.align 4`) with a[i] = i,
in increasing order. Then measure twice, first with stride 1, then with stride s: write CACHE_CLEAR, do exactly
256 loads at index j = 0, s, 2s, ... (j = (j + s) mod 256) and add them up, then read CACHE_HITS and CACHE_MISSES.
Between CLEAR and reading the counters use only registers (no stack, no calls: every RAM access is counted).
Print for each part `stride <s>: sum=<sum> hits=<h> misses=<m> rate=<r>%` with r = h * 100 / (h + m)
(integer division).

Write `p36_main` as a subroutine ending with `ret`; every label starts with `p36_`; keep sp and s0-s11.

Example input:
```
16
```
Output:
```
stride 1: sum=32640 hits=192 misses=64 rate=75%
stride 16: sum=30720 hits=0 misses=256 rate=0%
```
Library: rcv_read_dec, rcv_puts, rcv_print_dec, rcv_putc, rcv_newline, rcv_udiv, rcv_umul.

Your block: HITS and MISSES are your counters; with 16-byte lines stride 1 hits 3 of every 4 accesses.

Your program is a subroutine: it starts at `p36_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **ECALL (trap)**;
your review partners (E2) are P35 (Cache tag store) and P27 (Store aligner).
