"""RC-V system constants: memory map, I/O slots, control word.

This file is the single source of truth. docs/ARCHITECTURE.md, the Verilog
top level and the simulator all follow it.
"""

ROM_BASE, ROM_WORDS = 0x0000_0000, 16384         # 64 KB, instructions + constants
RAM_BASE, RAM_WORDS = 0x0001_0000, 4096          # 16 KB, data + stack
IO_BASE = 0x0002_0000                            # 32 device slots x 64 bytes
STACK_TOP = RAM_BASE + RAM_WORDS * 4             # sp starts here (grows down)

# Every device has 16 word registers; register 15 always reads the device ID
# (the package number that built it).
ID_REG = 15

# slot -> (name, package id, {register name: index})
DEVICES = {
    0:  ("uart",     41, {"TXDATA": 0, "TXSTATUS": 1}),
    1:  ("kbd",      42, {"RXDATA": 0, "RXSTATUS": 1, "PEEK": 2}),
    2:  ("gpio",     43, {"LEDS": 0, "SEG": 1, "BUTTONS": 2}),
    3:  ("timer",    46, {"COUNT": 0, "CMP": 1, "CTRL": 2, "STATUS": 3}),
    4:  ("irq",      47, {"PENDING": 0, "MASK": 1, "CAUSE": 2, "SWI": 3}),
    5:  ("dma",      48, {"SRC": 0, "DST": 1, "LEN": 2, "CTRL": 3, "STATUS": 4}),
    6:  ("perf",     49, {"CYCLE": 0, "INSTRET": 1, "CLEAR": 2}),
    7:  ("cache",    36, {"HITS": 0, "MISSES": 1, "CLEAR": 2}),
    8:  ("mul",      50, {"A": 0, "B": 1, "CTRL": 2, "STATUS": 3, "RESULT": 4}),
    9:  ("simd",     51, {"A": 0, "B": 1, "SUM": 2, "MAX": 3, "SUB": 4}),
    10: ("bcd",      52, {"BIN": 0, "BCD": 1}),
    11: ("wdt",      53, {"LOAD": 0, "CTRL": 1, "STATUS": 2, "COUNT": 3, "KICK": 4}),
    12: ("rng",      54, {"SEED": 0, "VALUE": 1, "PEEK": 2}),
    13: ("spguard",  55, {"LIMIT": 0, "STATUS": 1, "MINSP": 2}),
    14: ("stats",    56, {"LOADS": 0, "STORES": 1, "BRANCHES": 2, "TAKEN": 3, "JUMPS": 4, "CLEAR": 5}),
    15: ("halt",     57, {"HALT": 0, "CODE": 1}),
    16: ("bpred",    58, {"BRANCHES": 0, "CORRECT": 1, "CLEAR": 2}),
    17: ("hazard",   59, {"LOADUSE": 0, "RAW1": 1, "CLEAR": 2}),
    18: ("parity",   60, {"DATA": 0, "PARITY": 1, "ODD": 2}),
    19: ("screen",   61, {"CHAR": 0, "CURSOR": 1, "CLEAR": 2, "READ": 3}),
    20: ("irqlat",   62, {"LAST": 0, "MAX": 1, "CLEAR": 2, "COUNT": 3}),
    21: ("hwstack",  63, {"PUSH": 0, "POP": 1, "TOP": 2, "COUNT": 3, "STATUS": 4}),
    22: ("codeconv", 64, {"VAL": 0, "GRAY": 1, "FROMGRAY": 2, "XS3": 3}),
    23: ("compl",    65, {"VAL": 0, "ONES": 1, "TWOS": 2, "SIGNMAG": 3, "NINES": 4, "TENS": 5}),
}

# Interrupt sources, lowest index = highest priority. mcause = 0x80000010 + index.
IRQ_SOURCES = ["timer", "kbd", "dma", "spguard", "swi"]

UART_BUSY_CYCLES = 4      # after a TXDATA write the terminal is busy this long
MUL_CYCLES = 32
SCREEN_ROWS, SCREEN_COLS = 4, 16
HWSTACK_DEPTH = 8
CACHE_LINES, CACHE_LINE_BYTES = 16, 16
BPRED_ENTRIES = 16

# CSR numbers
CSR = {"mstatus": 0x300, "mtvec": 0x305, "mscratch": 0x340, "mepc": 0x341, "mcause": 0x342}

# Control word produced by both control units (P22 hardwired, P23 ROM).
CTRL_FIELDS = [            # (name, bits), most significant first
    ("regwrite", 1), ("asel_pc", 1), ("bsel_imm", 1), ("a_zero", 1),
    ("memread", 1), ("memwrite", 1), ("wbsel", 2), ("immsel", 3),
    ("is_branch", 1), ("is_jal", 1), ("is_jalr", 1), ("is_csr", 1),
]
CTRL_BITS = sum(b for _, b in CTRL_FIELDS)    # 16
WB_ALU, WB_MEM, WB_PC4, WB_CSR = 0, 1, 2, 3
IMM_I, IMM_S, IMM_B, IMM_U, IMM_J = 0, 1, 2, 3, 4

ALUOP = {"ADD": 0, "SUB": 1, "AND": 2, "OR": 3, "XOR": 4, "SLL": 5,
         "SRL": 6, "SRA": 7, "SLT": 8, "SLTU": 9}

# next-PC select (P15/P16)
NPC_PC4, NPC_TARGET, NPC_JALR, NPC_MTVEC, NPC_MEPC = 0, 1, 2, 3, 4

OPCODES = {"LUI": 0x37, "AUIPC": 0x17, "JAL": 0x6F, "JALR": 0x67, "BRANCH": 0x63,
           "LOAD": 0x03, "STORE": 0x23, "OPIMM": 0x13, "OP": 0x33, "SYSTEM": 0x73}


def io_addr(slot, reg):
    return IO_BASE + slot * 64 + reg * 4


def control_word(opcode):
    """Reference control word for an opcode (bits as CTRL_FIELDS)."""
    f = dict(regwrite=0, asel_pc=0, bsel_imm=0, a_zero=0, memread=0, memwrite=0,
             wbsel=WB_ALU, immsel=IMM_I, is_branch=0, is_jal=0, is_jalr=0, is_csr=0)
    o = opcode
    if o == 0x37:   f.update(regwrite=1, bsel_imm=1, a_zero=1, immsel=IMM_U)
    elif o == 0x17: f.update(regwrite=1, asel_pc=1, bsel_imm=1, immsel=IMM_U)
    elif o == 0x6F: f.update(regwrite=1, wbsel=WB_PC4, immsel=IMM_J, is_jal=1)
    elif o == 0x67: f.update(regwrite=1, bsel_imm=1, wbsel=WB_PC4, is_jalr=1)
    elif o == 0x63: f.update(immsel=IMM_B, is_branch=1)
    elif o == 0x03: f.update(regwrite=1, bsel_imm=1, memread=1, wbsel=WB_MEM)
    elif o == 0x23: f.update(bsel_imm=1, memwrite=1, immsel=IMM_S)
    elif o == 0x13: f.update(regwrite=1, bsel_imm=1)
    elif o == 0x33: f.update(regwrite=1)
    elif o == 0x73: f.update(regwrite=1, wbsel=WB_CSR, is_csr=1)
    return pack_ctrl(f)


def pack_ctrl(f):
    w = 0
    for name, bits in CTRL_FIELDS:
        w = (w << bits) | (f[name] & ((1 << bits) - 1))
    return w


def unpack_ctrl(w):
    out, shift = {}, CTRL_BITS
    for name, bits in CTRL_FIELDS:
        shift -= bits
        out[name] = (w >> shift) & ((1 << bits) - 1)
    return out
