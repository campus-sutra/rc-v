# P57 - Halt controller

**Group:** G. Measurement and support devices · **Syllabus focus:** Unit 4 (Basic computer organisation)
**Work:** hardware ●○○ + program ●●● = the same total as every other package

Slot 15: HALT (any write stops the machine), CODE. A committed `j .` (0x0000006F) also halts. It is I/O device slot 15 (registers at 0x000203C0; register 15 must read 57, the package number).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P57.dig` | your circuit in Digital |
| `p57_halt_ctrl.v` | the same block in Verilog |
| `p57.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P57.dig`)

A sticky flip-flop and a 32-bit comparator.

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `rst` | 1 |
| input | `write_halt` | 1 |
| input | `commit` | 1 |
| input | `instr` | 32 |
| output | `halted` | 1 |

Allowed parts: all of the above + Add, Sub, Comparator, Neg. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p57_halt_ctrl.v`)

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
| input | `commit` | 1 |
| input | `instr` | 32 |
| output | `halted` | 1 |

Clocked: everything changes on the rising edge of `clk`.
The test bench is `tests/tb_p57_halt_ctrl.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p57.s`)

# P57 program: Command loop with an exit code

Read commands, one per line (at most 40 characters; ignore empty lines), and count every command. `h` prints
`commands: h help, c count, e <text> echo, q quit`; `c` prints `count: <commands so far, this one included>`;
`e <text>` prints the text after `e `; any other letter x prints `unknown command x`; `q` prints
`bye (<count> commands)`, writes the count to HALT_CODE and returns (do not write HALT_HALT: returning ends the
program). The input always ends with `q`.

Write `p57_main` as a subroutine ending with `ret`; every label starts with `p57_`; keep sp and s0-s11.

Example input:
```
h
c

e hello there
x
q
```
Output:
```
commands: h help, c count, e <text> echo, q quit
count: 2
hello there
unknown command x
bye (5 commands)
```
Library: rcv_read_line, rcv_puts, rcv_putc, rcv_print_dec, rcv_newline.

Your block: the exit code is stored in the CODE register of your halt controller.

Your program is a subroutine: it starts at `p57_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **ADDI**;
your review partners (E2) are P56 (Instruction-mix counters) and P58 (Branch predictor (2-bit counters)).
