# P23 - Microprogrammed control (control ROM)

**Group:** C. Decode and control · **Syllabus focus:** Unit 2 (Digital components), Unit 4 (Basic computer organisation)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

The same 16-bit control word, read from a 32-entry control memory addressed by opcode[6:2]. Unused opcodes give 0.

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P23.dig` | your circuit in Digital |
| `p23_ctrl_rom.v` | the same block in Verilog |
| `p23.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P23.dig`)

Full size: a ROM part (5 address bits, 16 data bits); you work out and enter the contents.

| Direction | Name | Bits |
|---|---|---|
| input | `op_hi` | 5 |
| output | `ctrl` | 16 |

Allowed parts: gates + multiplexer/decoder parts + ROM. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p23_ctrl_rom.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `op_hi` | 5 |
| output | `ctrl` | 16 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p23_ctrl_rom.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p23.s`)

# P23 program: GCD and LCM  (●●○)

Read two positive numbers A and B (one per line). Find the GCD with Euclid's method by subtraction (while a != b: subtract the smaller from the larger). Then LCM = (A / GCD) * B.
Output: `gcd = <n>` and `lcm = <n>`.

Example input:
```
12
18
```
Output:
```
gcd = 6
lcm = 36
```

You may use the library routines: rcv_read_dec, rcv_print_udec, rcv_udiv, rcv_umul, rcv_puts, rcv_newline.

Your program is a subroutine: it starts at `p23_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **SRLI**;
your review partners (E2) are P22 (Hardwired control unit) and P24 (Control selector and checker).
