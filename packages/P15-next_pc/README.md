# P15 - Next-PC selector

**Group:** C. Decode and control · **Syllabus focus:** Unit 4 (Basic computer organisation)
**Work:** hardware ●○○ + program ●●● = the same total as every other package

sel 0 = pc+4, 1 = branch/jal target, 2 = jalr result with bit 0 cleared, 3 = mtvec (trap), 4 = mepc (mret). Other values give pc+4.

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P15.dig` | your circuit in Digital |
| `p15_next_pc.v` | the same block in Verilog |
| `p15.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P15.dig`)

4-bit version with an 8-to-1 multiplexer.

| Direction | Name | Bits |
|---|---|---|
| input | `sel` | 3 |
| input | `pc4` | 4 |
| input | `target` | 4 |
| input | `jalr_y` | 4 |
| input | `mtvec` | 4 |
| input | `mepc` | 4 |
| output | `npc` | 4 |

Allowed parts: gates + Multiplexer, Demultiplexer, Decoder, PriorityEncoder. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p15_next_pc.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `sel` | 3 |
| input | `pc4` | 32 |
| input | `target` | 32 |
| input | `jalr_y` | 32 |
| input | `mtvec` | 32 |
| input | `mepc` | 32 |
| output | `npc` | 32 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p15_next_pc.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p15.s`)

# P15 program: Recursive factorial  (●●●)

Read N (1 to 12). For k = 1 to N print k!. Compute k! with a recursive subroutine `p15_fact` (n! = n * (n-1)!, 1! = 1) that saves ra and n on the stack; multiply with rcv_umul.
Output: N lines `<k>! = <value>`.

Example input:
```
5
```
Output:
```
1! = 1
2! = 2
3! = 6
4! = 24
5! = 120
```

You may use the library routines: rcv_read_dec, rcv_print_udec, rcv_umul, rcv_puts, rcv_newline.
This exercises your block: every `call` and `ret` is a next-PC choice (jal target, jalr result) made by your selector.

Your program is a subroutine: it starts at `p15_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **SW**;
your review partners (E2) are P26 (ALU operand selector) and P16 (Next-PC decision logic).
