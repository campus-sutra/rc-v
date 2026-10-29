# P14 - Program counter register

**Group:** B. Registers and program counter · **Syllabus focus:** Unit 1 (Digital logic circuits), Unit 2 (Digital components), Unit 4 (Basic computer organisation)
**Work:** hardware ●○○ + program ●●● = the same total as every other package

Loads d on the clock edge when en=1; rst=1 (synchronous) sets it to 0, the reset address.

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P14.dig` | your circuit in Digital |
| `p14_pc_reg.v` | the same block in Verilog |
| `p14.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P14.dig`)

8-bit version from D flip-flops with a 2-to-1 hold/load choice built from gates.

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `rst` | 1 |
| input | `en` | 1 |
| input | `d` | 8 |
| output | `q` | 8 |

Allowed parts: gates + D_FF, JK_FF, T_FF, RS_FF. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p14_pc_reg.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `rst` | 1 |
| input | `en` | 1 |
| input | `d` | 32 |
| output | `q` | 32 |

Clocked: everything changes on the rising edge of `clk`.
The test bench is `tests/tb_p14_pc_reg.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p14.s`)

# P14 program: Menu with a jump table  (●●●)

Put a table of 3 routine addresses in ROM (`.rodata`, `.word p14_r0, p14_r1, p14_r2`). Read characters one at a time; ignore newlines and spaces. For a digit 0-2, load the address from the table and call that routine with `jalr`; for any other character print `invalid choice`; stop at `q`.
Routine 0 prints `Hello, RC-V!`, routine 1 prints `1 2 3 4 5` and routine 2 prints `5 4 3 2 1` (each a whole line; routines 1 and 2 must use a loop).

Example input:
```
0
1
5
2
q
```
Output:
```
Hello, RC-V!
1 2 3 4 5
invalid choice
5 4 3 2 1
```

You may use the library routines: rcv_getc, rcv_puts, rcv_putc, rcv_print_udec, rcv_newline.
This exercises your block: `jalr` loads a computed address into your PC register.

Your program is a subroutine: it starts at `p14_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **SB**;
your review partners (E2) are P13 (Register-file read port) and P11 (Register-file write decoder).
