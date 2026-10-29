# P32 - Memory read selector

**Group:** D. Memory and bus · **Syllabus focus:** Unit 2 (Digital components), Unit 6 (Memory and I/O)
**Work:** hardware ●○○ + program ●●● = the same total as every other package

Passes the data of the selected region (ROM, RAM or I/O); nothing selected gives 0.

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P32.dig` | your circuit in Digital |
| `p32_read_mux.v` | the same block in Verilog |
| `p32.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P32.dig`)

4-bit version from AND/OR gates.

| Direction | Name | Bits |
|---|---|---|
| input | `sel_rom` | 1 |
| input | `sel_ram` | 1 |
| input | `sel_io` | 1 |
| input | `rom_d` | 4 |
| input | `ram_d` | 4 |
| input | `io_d` | 4 |
| output | `rdata` | 4 |

Allowed parts: And, Or, Not, NAnd, NOr, XOr, XNOr + wiring parts. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p32_read_mux.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `sel_rom` | 1 |
| input | `sel_ram` | 1 |
| input | `sel_io` | 1 |
| input | `rom_d` | 32 |
| input | `ram_d` | 32 |
| input | `io_d` | 32 |
| output | `rdata` | 32 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p32_read_mux.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p32.s`)

# P32 program: Student records  (●●●)

Read 5 lines `roll marks` (two non-negative decimal numbers). Store them in RAM as 5 records of two words (roll at offset 0, marks at offset 4). Then go through the records: find the topper (highest marks; if two are equal, the first one wins) and the average (total / 5, integer, with rcv_udiv).
Output: `topper: roll <r> (marks <m>)` and `average: <n>`.

Example input:
```
101 78
102 91
103 65
104 91
105 80
```
Output:
```
topper: roll 102 (marks 91)
average: 81
```

You may use the library routines: rcv_read_dec, rcv_print_udec, rcv_udiv, rcv_puts, rcv_putc, rcv_newline.
This exercises your block: loads from RAM come back through your memory read selector.

Your program is a subroutine: it starts at `p32_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **SRA**;
your review partners (E2) are P31 (Address decoder (memory map)) and P33 (I/O read bus).
