# P31 - Address decoder (memory map)

**Group:** D. Memory and bus · **Syllabus focus:** Unit 2 (Digital components), Unit 6 (Memory and I/O)
**Work:** hardware ●●○ + program ●●○ = the same total as every other package

ROM 0x00000000-0x0000FFFF, RAM 0x00010000-0x00013FFF, I/O 0x00020000-0x000207FF (dev = address bits 10..6, ridx = bits 5..2).

You hand in four files, all in this folder:

| File | What it is |
|---|---|
| `P31.dig` | your circuit in Digital |
| `p31_addr_decode.v` | the same block in Verilog |
| `p31.s` | your RISC-V program |
| `DOSSIER.md` | your answers (U1-U6, E1-E4) |

Do not change anything in `tests/` or outside this folder: the checker rejects it.

## 1. Digital circuit (`P31.dig`)

Full size: Splitters and gates comparing the upper address bits.

| Direction | Name | Bits |
|---|---|---|
| input | `addr` | 32 |
| output | `sel_rom` | 1 |
| output | `sel_ram` | 1 |
| output | `sel_io` | 1 |
| output | `dev` | 5 |
| output | `ridx` | 4 |

Allowed parts: And, Or, Not, NAnd, NOr, XOr, XNOr + wiring parts. The file already contains the pins and the
public tests: in Digital use **Tests → Run tests** (or F8).

## 2. Verilog module (`p31_addr_decode.v`)

The full-size block, exactly as the RC-V computer uses it:

| Direction | Name | Bits |
|---|---|---|
| input | `addr` | 32 |
| output | `sel_rom` | 1 |
| output | `sel_ram` | 1 |
| output | `sel_io` | 1 |
| output | `dev` | 5 |
| output | `ridx` | 4 |

Combinational: outputs depend only on the current inputs.
The test bench is `tests/tb_p31_addr_decode.v`. The checker runs it with Icarus Verilog
when you push; you can also run it on your laptop (see docs/GETTING-STARTED.md).

## 3. RISC-V program (`p31.s`)

# P31 program: Memory-map explorer  (●●○)

Print the base addresses ROM_BASE, RAM_BASE and IO_BASE. Read the register GPIO_BUTTONS and print it. Then read a hex value, store it to GPIO_LEDS, read GPIO_LEDS back and print what you wrote and what you read (the LEDs keep only 16 bits).
Output, all values as 8 hex digits: `ROM base = `, `RAM base = `, `I/O base = `, `buttons  = `, `wrote    = `, `leds     = ` (note the spaces).

Example input:
```
0xDEADBEEF
```
Output:
```
ROM base = 00000000
RAM base = 00010000
I/O base = 00020000
buttons  = 000000A5
wrote    = DEADBEEF
leds     = 0000BEEF
```

You may use the library routines: rcv_read_hex, rcv_print_hex, rcv_puts, rcv_newline.
This exercises your block: your address decoder decides which region each of these addresses belongs to.

Your program is a subroutine: it starts at `p31_main` and returns with `ret`.
The checker runs it on the RC-V simulator with every `tests/program/*.in` file
as keyboard input and compares the terminal output with the matching `.out` file.

## 4. Dossier (`DOSSIER.md`)

Fill in every section. Your instruction to trace (E1) is **SRL**;
your review partners (E2) are P30 (Boot ROM) and P32 (Memory read selector).
