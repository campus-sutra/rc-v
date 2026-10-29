# P40 - Illegal-instruction detector

**Group:** E. Traps and interrupts · **Syllabus focus:** Unit 4 (Basic computer organisation), Unit 5 (Processors)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

1 for any word that is not one of the RC-V instructions (see docs/ISA.md), e.g. 0x00000000.

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P40.dig` | your circuit in Digital |
| `p40_illegal_detect.v` | the same block in Verilog |
| `p40.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P40.dig`)

Full size: decode opcode/funct3/funct7 with gates (Comparators with Consts allowed).

| Direction | Name | Bits |
|---|---|---|
| input | `instr` | 32 |
| output | `illegal` | 1 |

Allowed parts: all of the above + Add, Sub, Comparator, Neg. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p40_illegal_detect.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `instr` | 32 |
| output | `illegal` | 1 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p40_illegal_detect.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p40.s`)

# P40 program: Catch illegal instructions

Read N (1..5). Install your own trap handler (save/restore `mtvec`). Run a loop N times that contains, right after
the label `p40_bad`, the two illegal words `.word 0x00000000` and `.word 0xFFFFFFFF`. For each trap the handler
prints `illegal instruction: mcause=<mcause, 8 hex digits> offset=<mepc - p40_bad, decimal>`, counts the trap,
adds 4 to `mepc` (skips the bad word) and returns with `mret`. At the end print `recovered after <count> traps`.

Write `p40_main` as a subroutine ending with `ret`; every label starts with `p40_`; keep sp and s0-s11.

Example input:
```
1
```
Output:
```
illegal instruction: mcause=00000002 offset=0
illegal instruction: mcause=00000002 offset=4
recovered after 2 traps
```
Library: rcv_read_dec, rcv_puts, rcv_print_hex, rcv_print_dec, rcv_newline.

Your block: both words must be recognised as illegal by your detector (mcause 2).

Your program is a subroutine: it starts at `p40_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **SW to the terminal**;
your review partners (E2) are P39 (Trap controller) and P37 (Control and status registers).
