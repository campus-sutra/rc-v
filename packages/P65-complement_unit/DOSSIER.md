# DOSSIER - P65 Complement unit

## U1-U6: Data representation (Unit 3)

### Radix and diminished-radix complements
- For binary, the 1's complement (r-1) flips every bit. For v = -8 (0xFFFFFFF8) it is 0x00000007.
- The 2's complement (r) is the 1's complement plus 1. For -8 it is 0x00000008.
- For decimal, the 9's complement (r-1) subtracts each digit from 9. For 1234 it is 8765.
- The 10's complement (r) is the 9's complement plus 1. For 1234 it is 8766.
- Check: 1234 + 8766 = 10000. The carry out is dropped, so 8766 behaves like -1234.

### Sign-magnitude
The top bit is the sign and the other bits hold the magnitude. For -8 the result is 0x80000008. This differs from 2's complement because only the sign bit changes.

### Packed BCD
Each decimal digit takes 4 bits, so 8765 is stored as 0x8765. The values A to F are not valid BCD digits. That is why the 9's complement circuit only accepts digits 0 to 9.

### Gate-level design (P65.dig)
- ones: a NOT gate on each of the 8 bits of v.
- twos: twos0 = v0, and for i = 1 to 7, twos_i = v_i XOR (v0 OR ... OR v_(i-1)). This is an incrementer built from OR and XOR gates.
- nines (9 - d): n0 = NOT d0, n1 = d1, n2 = d2 XOR d1, n3 = NOR(d3, d2, d1).
- Only And, Or, Not, NAnd, NOr, XOr, XNOr and wiring parts are used. The public tests pass (Tests -> Run tests).

### Verilog block (p65_complement_unit.v)
- It is clocked and everything changes on the rising edge of clk.
- Registers in I/O slot 23 (base 0x000205C0): VAL, ONES, TWOS, SIGNMAG, NINES, TENS. Register 15 reads 65, the package number.
- The unit converts the binary value in VAL to packed BCD for NINES and TENS.

### RISC-V program (p65.s)
- p65_main is a subroutine that ends with ret. All labels start with p65_.
- It reads a signed number with rcv_read_dec and writes it to COMPL_VAL.
- It prints the 1's complement, 2's complement and sign-magnitude as 8 hex digits.
- It then reads a number from 0 to 9999, writes it to COMPL_VAL, and prints the 9's and 10's complements.
- It saves and restores s0 and sp.
- For the input -8 and 1234 the output is:
  - 1's complement: 00000007
  - 2's complement: 00000008
  - sign-magnitude: 80000008
  - 9's complement: 00008765
  - 10's complement: 00008766

## E1: Instruction trace - SRAI
SRAI means shift right arithmetic immediate. Its syntax is `srai rd, rs1, shamt`.

- Format: I-type. Bits 31-25 = 0100000, bits 24-20 = shamt, funct3 = 101, opcode = 0010011.
- Operation: rd = rs1 >> shamt, with the sign bit rs1[31] copied into the vacated top bits.
- Example: `srai x5, x6, 2` with x6 = 0xFFFFFFF8 (-8) gives x5 = 0xFFFFFFFE (-2). A logical shift (SRLI) would give 0x3FFFFFFE.
- Datapath: the instruction is fetched and the decoder selects ALU operation "shift right arithmetic". Operand B is the immediate shamt, operand A is rs1, and register write enable is 1. The ALU result is written to rd.
- Link to P65: `srai t0, a0, 31` gives 0xFFFFFFFF for a negative number and 0 otherwise, which is a quick sign test.
- TODO: add the control-signal values from your own RC-V datapath.

## E2: Review partners

### P64 - Code converter (Gray, excess-3)
- What I checked: TODO (for example pins match the README, tests pass, Verilog matches the .dig)
- Findings: TODO
- Suggestion: TODO

### P66 - Reset controller
- What I checked: TODO
- Findings: TODO
- Suggestion: TODO

## E3
TODO

## E4
TODO
