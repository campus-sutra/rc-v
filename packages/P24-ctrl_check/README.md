# P24 - Control selector and checker

**Group:** C. Decode and control · **Syllabus focus:** Unit 4 (Basic computer organisation)
**Work:** hardware ●○○ + program ●●● = the same total as every other package

Passes on one control unit's word (use_rom selects) and raises mismatch when the hardwired and microprogrammed units disagree.

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P24.dig` | your circuit in Digital |
| `p24_ctrl_check.v` | the same block in Verilog |
| `p24.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P24.dig`)

Full size: multiplexer plus XOR/OR gates.

| Direction | Name | Bits |
|---|---|---|
| input | `ctrl_hw` | 16 |
| input | `ctrl_rom` | 16 |
| input | `use_rom` | 1 |
| output | `ctrl` | 16 |
| output | `mismatch` | 1 |

Allowed parts: gates + Multiplexer, Demultiplexer, Decoder, PriorityEncoder. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p24_ctrl_check.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `ctrl_hw` | 16 |
| input | `ctrl_rom` | 16 |
| input | `use_rom` | 1 |
| output | `ctrl` | 16 |
| output | `mismatch` | 1 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p24_ctrl_check.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p24.s`)

# P24 program: Sieve of Eratosthenes  (●●●)

Read N (2 to 500). Use a byte array in RAM (`.space 504`): clear bytes 0..N, then for i = 2..N: if byte i is 0, i is prime - print it and set the bytes of 2i, 3i, ... (up to N) to 1.
Output: `primes:` followed by each prime with one space in front, then a line `count: <n>`.

Example input:
```
30
```
Output:
```
primes: 2 3 5 7 11 13 17 19 23 29
count: 10
```

You may use the library routines: rcv_read_dec, rcv_print_udec, rcv_putc, rcv_puts, rcv_newline.

Your program is a subroutine: it starts at `p24_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **SRAI**;
your review partners (E2) are P23 (Microprogrammed control (control ROM)) and P25 (Write-back selector).
