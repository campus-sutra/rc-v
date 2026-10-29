# P25 - Write-back selector

**Group:** C. Decode and control · **Syllabus focus:** Unit 4 (Basic computer organisation)
**Work:** hardware ●○○ + program ●●● = the same total as every other package

Chooses what is written to the register: 0 ALU result, 1 loaded value, 2 pc+4 (jal/jalr), 3 CSR.

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P25.dig` | your circuit in Digital |
| `p25_wb_mux.v` | the same block in Verilog |
| `p25.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P25.dig`)

4-bit version from gates (no Multiplexer part).

| Direction | Name | Bits |
|---|---|---|
| input | `wbsel` | 2 |
| input | `alu_y` | 4 |
| input | `mem_val` | 4 |
| input | `pc4` | 4 |
| input | `csr_rd` | 4 |
| output | `wd` | 4 |

Allowed parts: And, Or, Not, NAnd, NOr, XOr, XNOr + wiring parts. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p25_wb_mux.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `wbsel` | 2 |
| input | `alu_y` | 32 |
| input | `mem_val` | 32 |
| input | `pc4` | 32 |
| input | `csr_rd` | 32 |
| output | `wd` | 32 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p25_wb_mux.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p25.s`)

# P25 program: String routines  (●●●)

Read two words (one per line, at most 30 characters each). Write your own subroutines `p25_len` (length), `p25_copy` (copy a string, return the end) and `p25_equal` (1 if equal) - do not use library string routines other than rcv_read_line/rcv_puts.
Output: `length 1: <n>`, `length 2: <n>`, `joined: <word1><word2>`, `equal: yes` or `equal: no`.

Example input:
```
hello
world
```
Output:
```
length 1: 5
length 2: 5
joined: helloworld
equal: no
```

You may use the library routines: rcv_read_line, rcv_puts, rcv_print_udec, rcv_newline.

Your program is a subroutine: it starts at `p25_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **ADD**;
your review partners (E2) are P24 (Control selector and checker) and P26 (ALU operand selector).
