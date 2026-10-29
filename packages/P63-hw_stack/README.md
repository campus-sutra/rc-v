# P63 - Hardware stack

**Group:** G. Measurement and support devices · **Syllabus focus:** Unit 5 (Processors)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

Slot 21: PUSH, POP (read removes), TOP, COUNT, STATUS (empty, full, overflow, underflow). 8 entries: stack organisation in hardware. It is I/O device slot 21 (registers at 0x00020540; register 15 must read 63, the package number).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P63.dig` | your circuit in Digital |
| `p63_hw_stack.v` | the same block in Verilog |
| `p63.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P63.dig`)

4 entries x 4 bits with a stack pointer.

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `rst` | 1 |
| input | `push` | 1 |
| input | `pop` | 1 |
| input | `d` | 4 |
| output | `top` | 4 |
| output | `count` | 3 |
| output | `empty` | 1 |
| output | `full` | 1 |

Allowed parts: gates + multiplexer/decoder parts + flip-flops. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p63_hw_stack.v`)

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

Clocked: everything changes on the rising edge of `clk`.
The test bench is `tests/tb_p63_hw_stack.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p63.s`)

# P63 program: RPN calculator on the hardware stack

First empty the hardware stack (POP while HWSTACK_COUNT > 0) and write HWSTACK_STATUS. Read one line character
by character with `rcv_getc`: a digit 0..9 is pushed (HWSTACK_PUSH); `+`, `-`, `*` pop the right operand, then
the left one, and push the result; spaces are skipped; the newline ends the expression. If STATUS shows overflow
(bit 2) or underflow (bit 3), or COUNT is not 1 at the end, print `stack error`; otherwise pop the result and
print `result = <n>`.

Write `p63_main` as a subroutine ending with `ret`; every label starts with `p63_`; keep sp and s0-s11.

Example input:
```
3 4 + 2 *
```
Output:
```
result = 14
```
Library: rcv_getc, rcv_umul, rcv_puts, rcv_print_dec, rcv_newline.

Your block: all operands live in your 8-entry hardware stack; a pop from the empty stack sets the underflow bit.

Your program is a subroutine: it starts at `p63_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **SLLI**;
your review partners (E2) are P62 (Interrupt latency meter) and P64 (Code converter (Gray, excess-3)).
