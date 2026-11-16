# P07 Less-than unit (signed and unsigned) - dossier

Answer in your own words; short answers are fine. Diagrams can be photos of
hand drawings (put them next to this file and link them).

## U1 Digital logic
Give the truth table (or state table) of one part of your circuit and the
simplified Boolean expression you used. Which gates or flip-flops did you need?

- **Gates / Flip-flops used:** Only combinational logic gates (`NOT`, `AND`, `OR`, `XOR`, `XNOR`) are used. No flip-flops are needed because the less-than unit is purely combinational.

- **Truth table for 1-bit comparator cell** (inputs: `a_i`, `b_i`, `lt_in`; output: `lt_out`):

| a_i | b_i | lt_in | lt_out |
| :---: | :---: | :---: | :---: |
| 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 1 |
| 0 | 1 | 0 | 1 |
| 0 | 1 | 1 | 1 |
| 1 | 0 | 0 | 0 |
| 1 | 0 | 1 | 0 |
| 1 | 1 | 0 | 0 |
| 1 | 1 | 1 | 1 |

- **Simplified Boolean expressions:**
  - **1-bit cell:** `lt_out = (~a_i & b_i) | (~(a_i ^ b_i) & lt_in)`
  - **Signed output (`lt`) sign-bit correction** (using MSB `a_3`, `b_3` and unsigned result `ltu`): `lt = (a_3 & ~b_3) | (~(a_3 ^ b_3) & ltu)`


## U2 Digital components
Which building blocks (adders, multiplexers, decoders, registers, memory)
does your Digital circuit use, and how are they connected?

- **Building blocks used:** None of the higher-level sequential or arithmetic blocks (adders, multiplexers, decoders, registers, or memory) are used in `P07.dig`.
- **How they are connected:** The 4-bit inputs `a` and `b` are split into individual wires (`a3..a0` and `b3..b0`) using splitters. Four 1-bit comparator cells are cascaded from the LSB (bit 0, with `lt_in = 0`) up to the MSB (bit 3) to produce `ltu`. Finally, an `XOR`, `NOT`, `AND`, and `OR` gate network checks the sign bits (`a3`, `b3`) to adjust `ltu` into the signed output `lt`.



## U3 Data representation
Pick three test vectors of your block and explain them in binary, hex and
decimal (signed where it matters). Where could overflow or sign extension go wrong?

- **Three 4-bit test vectors:**
  1. **`a = 1111` (`0xF`), `b = 0001` (`0x1`)**
     - *Unsigned:* `15 < 1` is **False** (`ltu = 0`).
     - *Signed (2's complement):* `-1 < 1` is **True** (`lt = 1`).
  2. **`a = 1000` (`0x8`), `b = 0111` (`0x7`)**
     - *Unsigned:* `8 < 7` is **False** (`ltu = 0`).
     - *Signed (2's complement):* `-8 < +7` is **True** (`lt = 1`).
  3. **`a = 0011` (`0x3`), `b = 0101` (`0x5`)**
     - *Unsigned:* `3 < 5` is **True** (`ltu = 1`).
     - *Signed (2's complement):* `+3 < +5` is **True** (`lt = 1`).

- **Where overflow or sign extension could go wrong:**
  - If comparison is built using a subtractor (`a - b`) and only checks the sign bit of the result, signed overflow (e.g., `-8 - (+7) = -15`, which wraps around in 4-bit 2's complement to `+1`) gives the wrong answer unless the sign bit is XORed with the overflow flag (`N ^ V`).
  - In software or datapaths, failing to sign-extend narrow values (like 8-bit bytes or 12-bit immediates) to 32 bits before feeding them into `slt` or `sltu` treats negative numbers as small positive numbers and produces wrong comparisons.


## U4 Computer organisation
In which step of the instruction cycle (fetch, decode, execute, memory,
write-back, interrupt) does your block do its work? Which instructions need it?


- **Instruction cycle step:** **Execute (EX)** stage.
- **Instructions that need it:**
  - **Set-less-than ALU instructions:** `SLT`, `SLTI` (uses `lt`), and `SLTU`, `SLTIU` (uses `ltu`).
  - **Conditional branch instructions:** `BLT`, `BGE` (uses `lt` and `~lt`), and `BLTU`, `BGEU` (uses `ltu` and `~ltu`).


## U5 Processors
How would a CISC processor, a stack machine or a GPU do the job of your
block differently? (Look at the RISC-V vs Mano comparison in docs/ARCHITECTURE.md.)

- **CISC processor (e.g., Mano's Basic Computer / x86):** Instead of dedicated `SLT`/`SLTU` instructions that write `0` or `1` into a general-purpose register, a CISC processor performs a `CMP` (subtract) instruction that updates status flags in a flags register (`N`, `Z`, `V`, `C`), followed by conditional jump instructions (`JL`, `JB`) that read those flags.
- **Stack machine:** Pops the top two operands (`B`, then `A`) from the evaluation stack, compares them inside the ALU, and pushes a boolean `1` or `0` back onto the top of the stack without specifying register numbers.
- **GPU:** Executes the comparison across thousands of threads in parallel (SIMT); instead of branching a single instruction pointer, GPUs use the comparison result to set per-thread predicate masks that disable lanes where the condition is false.

## U6 Memory and I/O
How does your block take part in a memory access or an I/O transfer? If it
does not, explain which neighbouring block does and how data reaches it.

- **Role in memory/I/O:** The less-than unit does **not** directly take part in memory accesses or I/O transfers.
- **Neighbouring blocks:** The **Address Generation / Adder unit** inside the ALU computes effective memory addresses (`rs1 + imm`), and the **Load/Store Unit (LSU) / Data Memory interface** handles reading and writing data to RAM or memory-mapped I/O. Data from memory reaches our block only after a load instruction (`LW`, `LB`, etc.) writes the value back into the **Register File**, which then feeds our inputs `a` and `b` on a subsequent instruction.


## E1 Instruction trace: BLT
Trace one **BLT** instruction through the whole RC-V processor,
block by block (use docs/ARCHITECTURE.md and the simulator's --trace output).
List the blocks it passes through and the value on the main signals.

- **Example instruction:** `blt x5, x6, +8` (branch if `x5 < x6` signed).
- **Block-by-block path:**
  1. **PC & Instruction Memory (IF):** `PC` supplies the instruction address; Instruction Memory outputs the 32-bit `BLT` machine code (`opcode = 1100011`, `funct3 = 100`).
  2. **Decoder & Control Unit (ID):** Extracts `rs1 = x5`, `rs2 = x6`, and sign-extends the B-type immediate (`imm = +8`). Sets `Branch = 1` and selects `funct3 = 100` (signed less-than).
  3. **Register File (ID):** Outputs the 32-bit values of `x5` on `rd1` (wired to input `a`) and `x6` on `rd2` (wired to input `b`).
  4. **P07 Less-Than Unit (EX):** Compares `a` and `b` as 2's complement numbers and asserts `lt = 1` (if `x5 < x6`) or `lt = 0` (otherwise).
  5. **Branch Control & Next-PC Mux (EX/MEM):** Because `Branch = 1` and `lt = 1`, `PCSrc = 1`. The Next-PC multiplexer selects `PC + imm` instead of `PC + 4` to update `PC` on the next clock edge.


## E2 Neighbour review
Review the pull requests of P06 (Right barrel shifter) and P08 (ALU result selector). Paste the links to your review
comments here.
- **P06 (Right barrel shifter):** [Link to review comment on P06 PR]
- **P08 (ALU result selector):** [Link to review comment on P08 PR]


## E3 Where my block sits
In two or three sentences: which layer of the computer is your block in
(gates / components / datapath / control / instruction set / memory / I/O),
which blocks feed it and which blocks use its output?
My block sits in the **datapath layer** inside the **Execute (EX) stage** of the ALU. It is fed by the **Register File** (or **Immediate Generator** mux for `SLTI`/`SLTIU`) on inputs `a` and `b`, and its 1-bit `lt` and `ltu` outputs feed the **ALU Result Selector (P08)** (zero-extended to 32 bits for `SLT`/`SLTU`) and the **Branch Control Unit** (for `BLT`/`BGE`/`BLTU`/`BGEU`).


## E4 Syllabus map
Tick every syllabus topic your work touched (main units: Unit 1, Unit 3).

- [x ] Logic gates, Boolean algebra, K-maps
- [x ] Combinational circuits (adders, decoders, encoders, multiplexers)
- [ ] Flip-flops, registers, counters
- [ ] Memory (RAM, ROM)
- [x ] Number systems, complements, signed arithmetic
- [x ] Bus organisation, instruction codes and formats
- [x ] Instruction cycle, hardwired vs microprogrammed control
- [ ] Interrupts and the interrupt cycle
- [ ] Pipelining
- [x ] Register organisation, stack, addressing modes
- [x ] RISC vs CISC, multicore, GPU
- [ ] Memory hierarchy, cache
- [ ] I/O interface, programmed / interrupt-driven I/O, DMA
