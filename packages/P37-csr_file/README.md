# P37 - Control and status registers

**Group:** E. Traps and interrupts · **Syllabus focus:** Unit 4 (Basic computer organisation), Unit 6 (Memory and I/O)
**Work:** hardware ●●● + program ●○○ = the same total as every other package

mstatus (MIE bit 3, MPIE bit 7), mtvec, mscratch, mepc, mcause. On trap: mepc=pc, mcause=cause, MPIE=MIE, MIE=0. On mret: MIE=MPIE, MPIE=1. Otherwise a CSR write when we=1.

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P37.dig` | your circuit in Digital |
| `p37_csr_file.v` | the same block in Verilog |
| `p37.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P37.dig`)

Scaled: an 8-bit mtvec register and the MIE/MPIE flip-flops with trap and mret behaviour.

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `rst` | 1 |
| input | `we` | 1 |
| input | `wdata` | 8 |
| input | `trap` | 1 |
| input | `mret` | 1 |
| input | `set_mie` | 1 |
| output | `mtvec` | 8 |
| output | `mie` | 1 |
| output | `mpie` | 1 |

Allowed parts: gates + multiplexer/decoder parts + flip-flops. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p37_csr_file.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `clk` | 1 |
| input | `rst` | 1 |
| input | `addr` | 12 |
| input | `we` | 1 |
| input | `wdata` | 32 |
| input | `trap` | 1 |
| input | `cause` | 32 |
| input | `pc` | 32 |
| input | `mret` | 1 |
| output | `rdata` | 32 |
| output | `mtvec` | 32 |
| output | `mepc` | 32 |
| output | `mie` | 1 |

Clocked: everything changes on the rising edge of `clk`.
The test bench is `tests/tb_p37_csr_file.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p37.s`)

# P37 program: Write and read a CSR

Read a signed number. Write it to the CSR `mscratch` with `csrw`, clear the register you used, read the CSR
back with `csrr` into another register and print it as `mscratch = <n>`.

Write `p37_main` as a subroutine ending with `ret`; every label starts with `p37_`; keep sp and s0-s11.

Example input:
```
-42
```
Output:
```
mscratch = -42
```
Library: rcv_read_dec, rcv_puts, rcv_print_dec, rcv_newline.

Your block: `csrw` and `csrr` are CSRRW and CSRRS instructions that write and read your CSR file.

Your program is a subroutine: it starts at `p37_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **MRET**;
your review partners (E2) are P40 (Illegal-instruction detector) and P38 (CSR read-modify-write).
