# The project: rules, marks and timeline

## The idea

The whole class builds **one** computer. Each of the 66 students owns one package, and
every package exercises the whole syllabus:

| Part of your package | Syllabus units |
|---|---|
| Digital circuit, built from gates, flip-flops, multiplexers... | Unit 1 (logic, K-maps, flip-flops), Unit 2 (components) |
| Test vectors in binary/hex, signed and unsigned | Unit 3 (data representation) |
| Verilog module, plugged into the class computer | a little HDL; Units 2, 4 |
| RISC-V program running on the class computer | Units 3, 4, 5 (instructions, addressing, stack, RISC) |
| Dossier U1-U6 + instruction trace + syllabus map | all six units |
| Pull requests, reviews, issues | working in a real combined project |

**Equal work:** each package has a hardware weight and a program weight that always add
up to 4. A large circuit (●●●) comes with a short program (●○○); a small circuit (●○○)
comes with a longer program (●●●). Packages were given out by a seeded random draw.

## Common rules

1. Join with your own join code only, and only once. Never share your code.
2. Change only your own package's four hand-in files (the checker enforces this).
3. Keep every pin name, width and direction in `PNN.dig`, and the module name and port list
   in `pNN_name.v`, exactly as given: 65 other blocks connect to them.
4. Digital: use only the parts allowed in your README. Helper sub-circuits must be named
   `PNN_something.dig` and sit in your folder.
5. Verilog: one module in the file, with the given name. Do not instantiate any other
   package's module; the top level (`shared/rtl/rcv_soc.v`) connects everything.
6. Clocked blocks change only on the rising edge of `clk`; `rst` is synchronous, active high.
7. Program: start at `pNN_main`, end with `ret`, start every label with `pNN_`, and keep `sp`
   and `s0`-`s11` unchanged when you return (the checker tests this). Interrupt handlers
   must restore everything they use.
8. Use the library in `sw/lib/rcv_lib.s` for printing and reading unless your task says
   otherwise.
9. Your program must not depend on where it sits in memory (the class ROM links all 66
   programs together).
10. No names or roll numbers in the repository. Your GitHub account identifies you.
11. Commit messages start with your package number.
12. Review your two partners' pull requests (at least one useful comment each).
13. Report problems you find in other blocks as issues, politely, with a way to reproduce them.
14. Everything you hand in is your own work; you must be able to explain it in the viva.
15. Work handed in after the freeze (end of day 13) is not marked, except for fixes the
    teacher asks for.

## Marks (100)

| Part | Marks | How it is judged |
|---|---|---|
| Digital circuit | 25 | public tests (12), hidden tests (5), allowed parts and clean, labelled layout (8) |
| Verilog module | 20 | public test bench (10), hidden test bench (5), works inside the class computer (5) |
| RISC-V program | 20 | public tests (8), hidden test (6), calling rules and comments (6) |
| Dossier | 15 | U1-U6 (9), E1 instruction trace (4), E3/E4 (2) |
| Teamwork | 10 | reviews given (4), issues/notebook (2), merged on time, clean pull requests (4) |
| Demo and viva | 10 | explain your block, and one question about any other part of the computer |

The hidden tests are run by the teacher after the freeze, together with the full class
build (all 66 Verilog modules together running the class ROM).

## Timeline (two weeks)

Dates assume a start on Monday 2 November 2026; your teacher will confirm.

| Day | Date | Goal |
|---|---|---|
| 1 | Mon 2 Nov | Introduction in class. Join with your code, fork, install Digital. |
| 2 | Tue 3 Nov | Read your README; draw the circuit on paper (truth table / K-map). |
| 3-4 | Wed-Thu | Build the Digital circuit; all public tests green in Digital (F8). |
| 5 | Fri 6 Nov | **Milestone 1:** Digital circuit merged. |
| 6-7 | Sat-Mon | Verilog module; checker green. |
| 8 | Tue 10 Nov | **Milestone 2:** Verilog merged. First class build. |
| 9-10 | Wed-Thu | RISC-V program; checker green. |
| 11 | Fri 13 Nov | **Milestone 3:** program merged. Class ROM runs on the board. |
| 12 | Sat 14 Nov | Dossier and reviews of your partners. |
| 13 | Mon 16 Nov | **Freeze** at midnight. |
| 14 | Tue 17 Nov | Demo day and viva: the RC-V computer boots and runs all 66 programs. |

## Syllabus map

| Unit | Where the class computer uses it | Packages |
|---|---|---|
| 1 Digital logic | gate-level circuits, K-maps, flip-flops, counters | P07 P10 P14 P16 P21 P22 P44 P66 + every Digital circuit |
| 2 Digital components | adders, decoders, multiplexers, registers, RAM, ROM | P01-P06 P11-P13 P23 P29-P34 P45 P54 |
| 3 Data representation | 2's complement, overflow, sign extension, BCD, Gray, complements | P01 P06 P07 P18 P19 P28 P52 P64 P65 |
| 4 Basic computer organisation | bus, instruction formats, instruction cycle, hardwired vs microprogrammed control, interrupts, pipelining | P09 P10 P14-P26 P37-P40 P47 P49 P58 P59 |
| 5 Processors | register file, stack, addressing modes, RISC vs CISC, GPU/SIMD | P12 P13 P26 P50 P51 P55 P63 |
| 6 Memory and I/O | memory map, cache, programmed and interrupt I/O, DMA | P27-P36 P41-P48 P53 P61 P62 |
