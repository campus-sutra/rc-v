# P02 Branch-target adder (carry look-ahead) - dossier

Answer in your own words; short answers are fine. Diagrams can be photos of
hand drawings (put them next to this file and link them).

## U1 Digital logic
For each bit I make a generate G = a AND b and a propagate P = a XOR b. The carry is c1 = G0 OR (P0 AND c0), and the longer carries follow the same pattern. The truth table for one bit has a, b and cin as inputs, and G and P are enough to get the carry. I used only AND, OR, XOR and NOT gates, and no flip-flops because it's all combinational.

## U2 Digital components
There are two 4-bit CLA blocks, with the carry-out of the low block going into the carry-in of the high block. Each block has gates that make P and G, a carry look-ahead part (ANDs and ORs), and XORs for the sum bits. There are no muxes, registers or memory.

## U3 Data representation
- 0x05 + 0x03 = 0x08 (0000 0101 + 0000 0011 = 0000 1000, decimal 5 + 3 = 8)
- 0x7F + 0x01 = 0x80 (0111 1111 + 0000 0001 = 1000 0000, unsigned 127 + 1 = 128, but signed it becomes -128, so signed overflow)
- 0xFF + 0x01 = 0x00 (1111 1111 + 0000 0001 = 0000 0000, unsigned overflow with carry out, signed -1 + 1 = 0)
  Overflow can go wrong when the result doesn't fit in 8 bits. Sign extension can go wrong if a negative offset isn't extended properly before adding.
## U4 Computer organisation
It works in the execute step, where it calculates the branch target address. Branch and jump instructions need it (like BEQ, BNE and JAL), and AUIPC does too if the adder is used for PC + immediate.

## U5 Processors
A CISC processor would have one complex instruction do the address calculation and the memory access together, so it wouldn't need a separate adder step. A stack machine would just pop two values and add them. A GPU would add lots of numbers at the same time in parallel. My block adds just one pair.

## U6 Memory and I/O
My block doesn't touch memory or I/O directly. It only calculates an address. The program counter and the control unit use that address to fetch the next instruction from memory.

## E1 Instruction trace: AUIPC
AUIPC puts PC + (imm << 12) into a register.
1. PC sends the address to instruction memory (fetch).
2. The decoder reads the opcode and the immediate.
3. The immediate generator shifts it left by 12.
4. The adder adds PC + shifted imm. Example: PC = 0x00000004, imm = 0x00001000 -> result 0x00001004.
5. The result goes through to the register file (write-back) and is stored in rd.

## E2 Neighbour review
https://github.com/campus-sutra/rc-v/pull/138#pullrequestreview-5910943708
https://github.com/subham-cyberX/rc-v/pull/1#pullrequestreview-5910880099
## E3 Where my block sits
It's in the datapath layer, built from components (gates). The PC and the immediate generator feed it. The PC mux uses its output, which decides the next instruction address.

## E4 Syllabus map
Tick every syllabus topic your work touched (main units: Unit 2, Unit 3).

- [x] Logic gates, Boolean algebra, K-maps
- [x] Combinational circuits (adders, decoders, encoders, multiplexers)
- [ ] Flip-flops, registers, counters
- [ ] Memory (RAM, ROM)
- [x] Number systems, complements, signed arithmetic
- [x] Bus organisation, instruction codes and formats
- [x] Instruction cycle, hardwired vs microprogrammed control
- [ ] Interrupts and the interrupt cycle
- [ ] Pipelining
- [ ] Register organisation, stack, addressing modes
- [x] RISC vs CISC, multicore, GPU
- [ ] Memory hierarchy, cache
- [ ] I/O interface, programmed / interrupt-driven I/O, DMA ]
