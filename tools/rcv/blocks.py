"""Behaviour of every hardware block, used to generate the test vectors.

A combinational block is a function  inputs(dict) -> outputs(dict).
A clocked block is a class with  reset(), outputs(inputs) and clock(inputs):
outputs() is what the block shows *after* the clock edge has been applied
(the test vectors apply inputs, pulse the clock, then compare).

Widths are parameters so the same model checks both the full-size Verilog
module and the scaled-down Digital circuit.
"""
from . import spec
from .devices import (Access, Uart, Kbd, Gpio, Timer, IrqCtrl, Dma, Perf, CacheStats, Mul,
                      Simd, Bcd, Wdt, Rng, SpGuard, Stats, Halt, Bpred, Hazard, Parity, Screen,
                      IrqLat, HwStack, CodeConv, Compl, uses_regs)


def mask(w):
    return (1 << w) - 1


def sgn(v, w):
    v &= mask(w)
    return v - (1 << w) if v >> (w - 1) else v


# ------------------------------------------------------------ arithmetic
def alu_addsub(i, W=32):
    a, b, sub = i["a"], i["b"], i["sub"]
    bb = (~b & mask(W)) if sub else b
    t = a + bb + sub
    y = t & mask(W)
    sa, sb, sy = a >> (W - 1), bb >> (W - 1), y >> (W - 1)
    return {"y": y, "c": t >> W, "v": int(sa == sb and sy != sa)}


def target_adder(i, W=32):
    return {"y": (i["a"] + i["b"]) & mask(W)}


def pc_inc(i, W=32):
    return {"pc4": (i["pc"] + 4) & mask(W)}


def alu_logic(i, W=32):
    a, b, op = i["a"], i["b"], i["op"]
    return {"y": {0: a & b, 1: a | b, 2: a ^ b}.get(op, 0)}


def shift_left(i, W=32):
    return {"y": (i["a"] << i["sh"]) & mask(W)}


def shift_right(i, W=32):
    a, sh = i["a"], i["sh"]
    if i["arith"]:
        return {"y": (sgn(a, W) >> sh) & mask(W)}
    return {"y": a >> sh}


def slt_unit(i, W=32):
    a, b = i["a"], i["b"]
    return {"lt": int(sgn(a, W) < sgn(b, W)), "ltu": int(a < b)}


def alu_select(i, W=32):
    op = i["aluop"]
    y = {0: i["add_y"], 1: i["add_y"], 2: i["logic_y"], 3: i["logic_y"], 4: i["logic_y"],
         5: i["shl_y"], 6: i["shr_y"], 7: i["shr_y"], 8: i["lt"], 9: i["ltu"]}.get(op, 0)
    return {"y": y, "zero": int(y == 0)}


def branch_cmp(i, W=32):
    a, b, f3 = i["a"], i["b"], i["funct3"]
    sa, sb = sgn(a, W), sgn(b, W)
    t = {0: a == b, 1: a != b, 4: sa < sb, 5: sa >= sb, 6: a < b, 7: a >= b}.get(f3, False)
    return {"take": int(t)}


def aluctl(i, W=None):
    f3, b5 = i["funct3"], i["funct7b5"]
    if i["is_op"]:
        op = [1 if b5 else 0, 5, 8, 9, 4, 7 if b5 else 6, 3, 2][f3]
    elif i["is_opimm"]:
        op = [0, 5, 8, 9, 4, 7 if b5 else 6, 3, 2][f3]
    else:
        op = 0
    return {"aluop": op}


# ------------------------------------------------------------ registers
def rf_decoder(i, N=32):
    return {"wen": 0 if (not i["we"] or i["rd"] == 0) else (1 << i["rd"]) & mask(N)}


class RfStorage:
    """N registers of W bits; register 0 is never written (wen[0] ignored)."""
    def __init__(self, N=32, W=32):
        self.N, self.W = N, W
        self.reset()

    def reset(self):
        self.r = [0] * self.N

    def clock(self, i):
        if i["rst"]:
            self.reset()
            return
        for k in range(1, self.N):
            if i["wen"] >> k & 1:
                self.r[k] = i["wd"] & mask(self.W)

    def outputs(self, i):
        return {"q_flat": sum(v << (self.W * k) for k, v in enumerate(self.r))}


def rf_readmux(i, N=32, W=32):
    return {"rd": (i["q_flat"] >> (W * i["ra"])) & mask(W)}


class PcReg:
    def __init__(self, W=32):
        self.W = W
        self.reset()

    def reset(self):
        self.q = 0

    def clock(self, i):
        if i["rst"]:
            self.q = 0
        elif i["en"]:
            self.q = i["d"] & mask(self.W)

    def outputs(self, i):
        return {"q": self.q}


# ------------------------------------------------------------ control
def next_pc(i, W=32):
    s = i["sel"]
    y = {0: i["pc4"], 1: i["target"], 2: i["jalr_y"] & ~1 & mask(W), 3: i["mtvec"], 4: i["mepc"]}.get(s, i["pc4"])
    return {"npc": y}


def pcsel_logic(i, W=None):
    if i["trap"]: s = 3
    elif i["is_mret"]: s = 4
    elif i["is_jalr"]: s = 2
    elif i["is_jal"] or (i["is_branch"] and i["take"]): s = 1
    else: s = 0
    return {"sel": s}


def ifields(i, W=None):
    x = i["instr"]
    return {"opcode": x & 0x7F, "rd": (x >> 7) & 31, "funct3": (x >> 12) & 7, "rs1": (x >> 15) & 31,
            "rs2": (x >> 20) & 31, "funct7": x >> 25, "csr": x >> 20}


def imm_is(i, W=None):
    x = i["instr"]
    return {"imm_i": sgn(x >> 20, 12) & mask(32),
            "imm_s": sgn(((x >> 25) << 5) | ((x >> 7) & 31), 12) & mask(32)}


def imm_bju(i, W=None):
    x = i["instr"]
    b = sgn((((x >> 31) & 1) << 12) | (((x >> 7) & 1) << 11) | (((x >> 25) & 63) << 5) | (((x >> 8) & 15) << 1), 13)
    j = sgn((((x >> 31) & 1) << 20) | (((x >> 12) & 255) << 12) | (((x >> 20) & 1) << 11) | (((x >> 21) & 1023) << 1), 21)
    return {"imm_b": b & mask(32), "imm_j": j & mask(32), "imm_u": x & 0xFFFFF000}


def imm_select(i, W=32):
    return {"imm": {0: i["imm_i"], 1: i["imm_s"], 2: i["imm_b"], 3: i["imm_u"], 4: i["imm_j"]}.get(i["immsel"], 0)}


CLASS_OPS = [("is_lui", 0x37), ("is_auipc", 0x17), ("is_jal", 0x6F), ("is_jalr", 0x67),
             ("is_branch", 0x63), ("is_load", 0x03), ("is_store", 0x23), ("is_opimm", 0x13),
             ("is_op", 0x33), ("is_system", 0x73)]


def opclass_dec(i, W=None):
    x = i["instr"]
    op = x & 0x7F
    out = {n: int(op == c) for n, c in CLASS_OPS}
    out["is_ecall"] = int(x == 0x00000073)
    out["is_mret"] = int(x == 0x30200073)
    return out


def ctrl_from_classes(i):
    for n, c in CLASS_OPS:
        if i.get(n):
            return spec.control_word(c)
    return 0


def ctrl_hw(i, W=None):
    return {"ctrl": ctrl_from_classes(i)}


def ctrl_rom(i, W=None):
    return {"ctrl": spec.control_word((i["op_hi"] << 2) | 3)}


def ctrl_check(i, W=None):
    return {"ctrl": i["ctrl_rom"] if i["use_rom"] else i["ctrl_hw"],
            "mismatch": int(i["ctrl_hw"] != i["ctrl_rom"])}


def wb_mux(i, W=32):
    return {"wd": [i["alu_y"], i["mem_val"], i["pc4"], i["csr_rd"]][i["wbsel"]]}


def opab_mux(i, W=32):
    a = 0 if i["a_zero"] else (i["pc"] if i["asel_pc"] else i["rs1"])
    b = i["imm"] if i["bsel_imm"] else i["rs2"]
    return {"a": a, "b": b}


# ------------------------------------------------------------ memory
def store_align(i, W=None):
    if i["funct3"] == 2:
        return {"wdata": i["rs2"], "be": 0xF}
    b = i["rs2"] & 0xFF
    return {"wdata": b * 0x01010101, "be": 1 << i["addr_lo"]}


def load_extend(i, W=None):
    raw, lo, f3 = i["raw"], i["addr_lo"], i["funct3"]
    lane = (raw >> (8 * lo)) & 0xFF
    if f3 == 2: v = raw
    elif f3 == 4: v = lane
    else: v = sgn(lane, 8) & mask(32)
    return {"val": v}


class DataRam:
    def __init__(self, WORDS=4096, AW=12):
        self.n = WORDS
        self.reset()

    def reset(self):
        self.m = [None] * self.n          # unknown until written

    def clock(self, i):
        if i["we"]:
            a = i["addr"] % self.n
            if i["be"] != 0xF and self.m[a] is None:
                return                    # partly written word stays unknown
            msk = sum(0xFF << (8 * k) for k in range(4) if i["be"] >> k & 1)
            self.m[a] = ((self.m[a] or 0) & ~msk) | (i["wdata"] & msk)

    def outputs(self, i):
        return {"rdata": self.m[i["addr"] % self.n]}


def addr_decode(i, W=None):
    a = i["addr"]
    return {"sel_rom": int(a >> 16 == 0), "sel_ram": int(a >> 14 == spec.RAM_BASE >> 14),
            "sel_io": int(a >> 11 == spec.IO_BASE >> 11), "dev": (a >> 6) & 31, "ridx": (a >> 2) & 15}


def read_mux(i, W=32):
    if i["sel_rom"]: v = i["rom_d"]
    elif i["sel_ram"]: v = i["ram_d"]
    elif i["sel_io"]: v = i["io_d"]
    else: v = 0
    return {"rdata": v}


def io_bus_mux(i, N=32, W=32):
    return {"rdata": (i["dev_flat"] >> (W * i["dev"])) & mask(W)}


def bus_arbiter(i, W=None):
    g = i["dma_req"]
    return {"grant": g, "stall": g,
            "addr": i["dma_addr"] if g else i["cpu_addr"],
            "wdata": i["dma_wdata"] if g else i["cpu_wdata"],
            "we": i["dma_we"] if g else i["cpu_we"],
            "be": 0xF if g else i["cpu_be"]}


class CacheTags:
    """hit is combinational for the current address; on an access the line is filled."""
    def __init__(self):
        self.reset()

    def reset(self):
        self.valid = [0] * 16
        self.tag = [0] * 16

    def _look(self, a):
        idx, tag = (a >> 4) & 15, a >> 8
        return idx, tag, int(self.valid[idx] and self.tag[idx] == tag)

    def clock(self, i):
        if i["rst"]:
            self.reset()
        elif i["access"]:
            idx, tag, _ = self._look(i["addr"])
            self.valid[idx], self.tag[idx] = 1, tag

    def outputs(self, i):
        return {"hit": self._look(i["addr"])[2] if i["access"] else 0}


# ------------------------------------------------------------ trap / CSR
class CsrFile:
    def __init__(self):
        self.reset()

    def reset(self):
        self.mie = self.mpie = 0
        self.mtvec = self.mepc = self.mcause = self.mscratch = 0

    def read(self, n):
        return {0x300: (self.mie << 3) | (self.mpie << 7), 0x305: self.mtvec, 0x340: self.mscratch,
                0x341: self.mepc, 0x342: self.mcause}.get(n, 0)

    def clock(self, i):
        if i["rst"]:
            self.reset()
            return
        if i["trap"]:
            self.mepc, self.mcause = i["pc"], i["cause"]
            self.mpie, self.mie = self.mie, 0
            return
        if i["mret"]:
            self.mie, self.mpie = self.mpie, 1
            return
        if i["we"]:
            n, v = i["addr"], i["wdata"]
            if n == 0x300: self.mie, self.mpie = (v >> 3) & 1, (v >> 7) & 1
            elif n == 0x305: self.mtvec = v
            elif n == 0x340: self.mscratch = v
            elif n == 0x341: self.mepc = v
            elif n == 0x342: self.mcause = v

    def outputs(self, i):
        return {"rdata": self.read(i["addr"]), "mtvec": self.mtvec, "mepc": self.mepc, "mie": self.mie}


def csr_op(i, W=None):
    f3, v, old = i["funct3"], i["rs1_val"], i["old"]
    if f3 == 1: return {"new_val": v, "write": 1}
    if f3 == 2: return {"new_val": old | v, "write": int(i["rs1_idx"] != 0)}
    if f3 == 3: return {"new_val": old & ~v & mask(32), "write": int(i["rs1_idx"] != 0)}
    return {"new_val": old, "write": 0}


def trap_ctrl(i, W=None):
    if i["stall"]:
        return {"trap": 0, "cause": 0}
    if i["irq"] and i["mie"]:
        return {"trap": 1, "cause": 0x80000010 + i["irq_cause"]}
    if i["illegal"]:
        return {"trap": 1, "cause": 2}
    if i["is_ecall"]:
        return {"trap": 1, "cause": 11}
    return {"trap": 0, "cause": 0}


def illegal_detect(i, W=None):
    from .sim import is_legal
    return {"illegal": int(not is_legal(i["instr"]))}


def seg7(i, W=None):
    # segments gfedcba, active high
    t = [0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71]
    return {"seg": t[i["hex"] & 15]}


class HexDisplay:
    """Scans 8 digits: each clock moves to the next digit (0..7)."""
    def __init__(self, D=8):
        self.D = D
        self.reset()

    def reset(self):
        self.k = 0

    def clock(self, i):
        self.k = 0 if i["rst"] else (self.k + 1) % self.D

    def outputs(self, i):
        return {"digit": (i["value"] >> (4 * self.k)) & 15, "anode": 1 << self.k}


class ResetCtrl:
    """rst stays high for 4 cycles after power-on or after btn is seen high."""
    def __init__(self):
        self.reset()

    def reset(self):
        self.n = 0

    def clock(self, i):
        if i["btn"]:
            self.n = 0
        elif self.n < 4:
            self.n += 1

    def outputs(self, i):
        return {"rst": int(self.n < 4)}


# ------------------------------------------------- devices as bus blocks
NO_INFO = dict(commit=0, instr=0, pc=0, is_load=0, is_store=0, is_branch=0, taken=0, is_jump=0,
               rd=0, rf_we=0, rf_wd=0, ram_access=0, mem_addr=0, trap_irq=0, irq_line=0)


class DeviceBlock:
    """Wraps a device model with the common device port list."""
    def __init__(self, dev_cls, **kw):
        self.cls, self.kw = dev_cls, kw
        self.reset()

    def reset(self):
        self.d = self.cls(**self.kw)

    def acc(self, i):
        if not i.get("sel"):
            return None
        return Access(i["ridx"], i["we"], i["re"], i["wdata"])

    def info(self, i):
        x = dict(NO_INFO)
        for k in x:
            if k in i:
                x[k] = i[k]
        return x

    def clock(self, i):
        if i["rst"]:
            self.reset()
            return
        self.edge(i)

    def edge(self, i):
        self.d.edge(self.acc(i), self.info(i))

    def outputs(self, i):
        o = {"rdata": self.d.read(i["ridx"])}
        o.update(self.extra(i))
        return o

    def extra(self, i):
        return {}


class UartBlock(DeviceBlock):
    """tx_valid/tx_char show the character accepted at the last edge."""
    def __init__(self):
        super().__init__(Uart)
        self.last = None

    def reset(self):
        super().reset()
        self.last = None

    def edge(self, i):
        n = len(self.d.out)
        super().edge(i)
        self.last = self.d.out[-1] if len(self.d.out) > n else None

    def extra(self, i):
        return {"tx_valid": int(self.last is not None), "tx_char": ord(self.last) if self.last else 0}


class KbdBlock(DeviceBlock):
    def __init__(self):
        super().__init__(Kbd)

    def edge(self, i):
        self.d.queue = [chr(i["ext_char"])] if i["ext_valid"] else []
        super().edge(i)

    def extra(self, i):
        pop = i.get("sel") and i["re"] and i["ridx"] == 0
        return {"irq": self.d.irq(), "ext_take": int(bool(not self.d.full and i["ext_valid"] and not pop))}


class GpioBlock(DeviceBlock):
    def __init__(self):
        super().__init__(Gpio)

    def edge(self, i):
        self.d.buttons = i["buttons"]
        super().edge(i)

    def outputs(self, i):
        self.d.buttons = i["buttons"]
        o = super().outputs(i)
        o.update(leds=self.d.leds, seg=self.d.seg)
        return o


class IrqBlock(DeviceBlock):
    def __init__(self):
        super().__init__(IrqCtrl)

    def edge(self, i):
        self.d.lines = i["lines"]
        super().edge(i)

    def outputs(self, i):
        self.d.lines = i["lines"]
        o = super().outputs(i)
        o.update(irq=self.d.irq(), cause=self.d.cause())
        return o


class DmaBlock(DeviceBlock):
    def __init__(self):
        super().__init__(Dma)

    def edge(self, i):
        self.d.edge(self.acc(i), NO_INFO, bus_rdata=i["m_rdata"])

    def extra(self, i):
        a, we, wd = self.d.master()
        b = self.d.busy
        return {"req": b, "m_addr": a if b else 0, "m_we": we if b else 0, "m_wdata": wd if b else 0,
                "irq": self.d.irq()}


class IrqOut(DeviceBlock):
    def extra(self, i):
        return {"irq": self.d.irq()}


class HaltBlock(DeviceBlock):
    def __init__(self):
        super().__init__(Halt)

    def extra(self, i):
        return {"halted": self.d.halted}


class ScreenBlock(DeviceBlock):
    def __init__(self):
        super().__init__(Screen)

    def extra(self, i):
        return {"dbg_char": self.d.buf[i["dbg_addr"] & 63]}


class CacheStatsBlock(DeviceBlock):
    """P36: counts the hit/miss pulses it is given (the tag store is P35)."""
    def __init__(self):
        super().__init__(lambda: _Counts())

    def edge(self, i):
        self.d.edge2(self.acc(i), i["access"], i["hit"])


class _Counts:
    pkg = 36

    def __init__(self):
        self.hits = self.misses = 0

    def read(self, r):
        if r == spec.ID_REG:
            return self.pkg
        return {0: self.hits, 1: self.misses}.get(r, 0)

    def edge2(self, acc, access, hit):
        if acc and acc.we and acc.reg == 2:
            self.hits = self.misses = 0
        elif access:
            if hit: self.hits += 1
            else: self.misses += 1
