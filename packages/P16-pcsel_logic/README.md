# P16 - Next-PC decision logic

**Group:** C. Decode and control · **Syllabus focus:** Unit 1 (Digital logic circuits), Unit 4 (Basic computer organisation)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

Priority: trap > mret > jalr > (jal or taken branch) > pc+4. Produces the sel code for P15.

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P16.dig` | your circuit in Digital |
| `p16_pcsel_logic.v` | the same block in Verilog |
| `p16.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P16.dig`)

Full size, gates only: truth table with don't-cares, then K-maps.

| Direction | Name | Bits |
|---|---|---|
| input | `trap` | 1 |
| input | `is_mret` | 1 |
| input | `is_jalr` | 1 |
| input | `is_jal` | 1 |
| input | `is_branch` | 1 |
| input | `take` | 1 |
| output | `sel` | 3 |

Allowed parts: And, Or, Not, NAnd, NOr, XOr, XNOr + wiring parts. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p16_pcsel_logic.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `trap` | 1 |
| input | `is_mret` | 1 |
| input | `is_jalr` | 1 |
| input | `is_jal` | 1 |
| input | `is_branch` | 1 |
| input | `take` | 1 |
| output | `sel` | 3 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p16_pcsel_logic.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p16.s`)

# P16 program: Collatz sequence  (●●○)

Read N (1 or more). Repeat until N is 1: if N is even, N = N/2 (use a shift), otherwise N = 3N+1 (use shift and add). Print every value and count the steps.
Output: one line with all values separated by single spaces (starting with N, ending with 1), then `steps: <count>`.

Example input:
```
6
```
Output:
```
6 3 10 5 16 8 4 2 1
steps: 8
```

You may use the library routines: rcv_read_dec, rcv_print_udec, rcv_putc, rcv_puts, rcv_newline.
This exercises your block: each taken or not-taken branch is decided by your next-PC logic.

Your program is a subroutine: it starts at `p16_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **ADDI**;
your review partners (E2) are P15 (Next-PC selector) and P17 (Instruction field splitter).
