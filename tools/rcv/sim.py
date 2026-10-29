"""rcv-sim: cycle-accurate reference model of the whole RC-V computer.

    python -m rcv.sim build/prog --input "12\\n30\\n" [--trace]

One clock cycle executes one instruction (the processor is single-cycle),
except when the DMA controller has stolen the bus. The Verilog class build
must produce exactly the same terminal output and cycle counts.
"""
import sys
from pathlib import Path

from . import spec
from .devices import DEVICE_CLASSES, Access, M32


def sx(v, bits):
    v &= (1 << bits) - 1
    return v - (1 << bits) if v >> (bits - 1) else v


def s32(v):
    return sx(v, 32)


def imm_i(i): return sx(i >> 20, 12)
def imm_s(i): return sx(((i >> 25) << 5) | ((i >> 7) & 31), 12)
def imm_b(i): return sx((((i >> 31) & 1) << 12) | (((i >> 7) & 1) << 11) | (((i >> 25) & 63) << 5) | (((i >> 8) & 15) << 1), 13)
def imm_u(i): return i & 0xFFFFF000
def imm_j(i): return sx((((i >> 31) & 1) << 20) | (((i >> 12) & 255) << 12) | (((i >> 20) & 1) << 11) | (((i >> 21) & 1023) << 1), 21)


def is_legal(i):
    op, f3, f7 = i & 0x7F, (i >> 12) & 7, i >> 25
    if op in (0x37, 0x17, 0x6F):
        return True
    if op == 0x67: return f3 == 0
    if op == 0x63: return f3 not in (2, 3)
    if op == 0x03: return f3 in (0, 2, 4)
    if op == 0x23: return f3 in (0, 2)
    if op == 0x13:
        if f3 == 1: return f7 == 0
        if f3 == 5: return f7 in (0, 0x20)
        return True
    if op == 0x33:
        if f7 == 0: return True
        if f7 == 0x20: return f3 in (0, 5)
        return False
    if op == 0x73:
        if i == 0x00000073 or i == 0x30200073:
            return True
        return f3 in (1, 2, 3)
    return False


class Machine:
    def __init__(self, rom, ram=None, kbd_input="", buttons=0xA5):
        self.rom = list(rom) + [0] * (spec.ROM_WORDS - len(rom))
        self.ram = list(ram or []) + [0] * (spec.RAM_WORDS - len(ram or []))
        self.x = [0] * 32
        self.pc = spec.ROM_BASE
        self.mie = self.mpie = 0
        self.mtvec = self.mepc = self.mcause = self.mscratch = 0
        self.out = []
        self.dev = {}
        for slot, (name, _pkg, _regs) in spec.DEVICES.items():
            cls = DEVICE_CLASSES[name]
            if name == "uart":
                d = cls(self.out)
            elif name == "kbd":
                d = cls(kbd_input)
            elif name == "gpio":
                d = cls(buttons)
            else:
                d = cls()
            d.slot = slot
            self.dev[name] = d
        self.slot_dev = {d.slot: d for d in self.dev.values()}
        self.cycles = 0
        self.trace = None

    # ------------------------------------------------------------ the bus
    @staticmethod
    def decode_addr(a):
        if a >> 16 == 0:
            return "rom", (a >> 2) & (spec.ROM_WORDS - 1), 0
        if a >> 14 == spec.RAM_BASE >> 14:
            return "ram", (a >> 2) & (spec.RAM_WORDS - 1), 0
        if a >> 11 == spec.IO_BASE >> 11:
            return "io", (a >> 6) & 31, (a >> 2) & 15
        return None, 0, 0

    def bus_read(self, a):
        kind, idx, reg = self.decode_addr(a)
        if kind == "rom": return self.rom[idx]
        if kind == "ram": return self.ram[idx]
        if kind == "io":
            d = self.slot_dev.get(idx)
            return d.read(reg) if d else 0
        return 0

    def csr_read(self, n):
        return {0x300: (self.mie << 3) | (self.mpie << 7), 0x305: self.mtvec, 0x340: self.mscratch,
                0x341: self.mepc, 0x342: self.mcause}.get(n, 0)

    def csr_write(self, n, v):
        if n == 0x300:
            self.mie, self.mpie = (v >> 3) & 1, (v >> 7) & 1
        elif n == 0x305: self.mtvec = v
        elif n == 0x340: self.mscratch = v
        elif n == 0x341: self.mepc = v
        elif n == 0x342: self.mcause = v

    # ----------------------------------------------------------- one cycle
    def step(self):
        d = self.dev
        irqc = d["irq"]
        irqc.lines = d["timer"].irq() | (d["kbd"].irq() << 1) | (d["dma"].irq() << 2) | (d["spguard"].irq() << 3)
        irq_line = irqc.irq() & self.mie
        info = dict(commit=0, instr=0, pc=self.pc, is_load=0, is_store=0, is_branch=0, taken=0,
                    is_jump=0, rd=0, rf_we=0, rf_wd=0, ram_access=0, mem_addr=0,
                    trap_irq=0, irq_line=irq_line)
        acc_slot, acc = None, None
        self.cycles += 1

        if d["dma"].req():                                    # stolen cycle
            addr, we, wdata = d["dma"].master()
            rdata = self.bus_read(addr)
            kind, idx, _ = self.decode_addr(addr)
            if we and kind == "ram":
                self.ram[idx] = wdata & M32
            for dv in d.values():
                if dv is d["dma"]:
                    dv.edge(None, info, bus_rdata=rdata)
                else:
                    dv.edge(None, info)
            return

        i = self.rom[(self.pc >> 2) & (spec.ROM_WORDS - 1)]
        info["instr"] = i
        op, rd, f3 = i & 0x7F, (i >> 7) & 31, (i >> 12) & 7
        rs1, rs2, f7 = (i >> 15) & 31, (i >> 20) & 31, i >> 25
        a, b = self.x[rs1], self.x[rs2]
        pc4 = (self.pc + 4) & M32
        npc = pc4
        illegal = not is_legal(i)
        ecall = i == 0x00000073
        mret = i == 0x30200073

        if irq_line or ecall or illegal:                     # trap: nothing commits
            cause = (0x80000010 + irqc.cause()) if irq_line else (2 if illegal else 11)
            info["trap_irq"] = 1 if irq_line else 0
            if self.trace is not None:
                self.trace.append(f"{self.cycles:6d} {self.pc:08x} {i:08x}  TRAP cause={cause:#x}")
            self.mepc, self.mcause = self.pc, cause
            self.mpie, self.mie = self.mie, 0
            self.pc = self.mtvec & M32
            for dv in d.values():
                dv.edge(None, info)
            return

        wd, we = None, False
        mem_we, mem_addr, mem_wdata, mem_be = False, None, 0, 0
        if op == 0x37:
            wd = imm_u(i)
        elif op == 0x17:
            wd = (self.pc + imm_u(i)) & M32
        elif op == 0x6F:
            wd, npc = pc4, (self.pc + imm_j(i)) & M32
            info["is_jump"] = 1
        elif op == 0x67:
            wd, npc = pc4, (a + imm_i(i)) & M32 & ~1
            info["is_jump"] = 1
        elif op == 0x63:
            sa, sb = s32(a), s32(b)
            take = {0: a == b, 1: a != b, 4: sa < sb, 5: sa >= sb, 6: a < b, 7: a >= b}[f3]
            info["is_branch"], info["taken"] = 1, int(take)
            if take:
                npc = (self.pc + imm_b(i)) & M32
        elif op == 0x03:
            addr = (a + imm_i(i)) & M32
            raw = self.bus_read(addr)
            lane = (raw >> (8 * (addr & 3))) & 0xFF
            wd = raw if f3 == 2 else (lane if f3 == 4 else sx(lane, 8) & M32)
            mem_addr = addr
            info["is_load"] = 1
        elif op == 0x23:
            addr = (a + imm_s(i)) & M32
            if f3 == 2:
                mem_wdata, mem_be = b, 0xF
            else:
                mem_wdata, mem_be = (b & 0xFF) * 0x01010101, 1 << (addr & 3)
            mem_we, mem_addr = True, addr
            info["is_store"] = 1
        elif op in (0x13, 0x33):
            imm = op == 0x13
            bv = imm_i(i) & M32 if imm else b
            sh = bv & 31
            alt = f7 == 0x20
            if f3 == 0: wd = (a - bv) if (alt and not imm) else (a + bv)
            elif f3 == 1: wd = a << sh
            elif f3 == 2: wd = int(s32(a) < s32(bv))
            elif f3 == 3: wd = int(a < bv)
            elif f3 == 4: wd = a ^ bv
            elif f3 == 5: wd = (s32(a) >> sh) if alt else (a >> sh)
            elif f3 == 6: wd = a | bv
            elif f3 == 7: wd = a & bv
            wd &= M32
        elif op == 0x73:
            if mret:
                npc = self.mepc & M32
                self.mie, self.mpie = self.mpie, 1
            else:
                csr = i >> 20
                old = self.csr_read(csr)
                if f3 == 1: new, w = a, True
                elif f3 == 2: new, w = old | a, rs1 != 0
                else: new, w = old & ~a & M32, rs1 != 0
                wd = old
                if w:
                    self.csr_write(csr, new & M32)

        # ---- memory side effects at the edge
        acc_dev = None
        if mem_addr is not None:
            kind, idx, reg = self.decode_addr(mem_addr)
            info["mem_addr"] = mem_addr
            if kind == "ram":
                info["ram_access"] = 1
                if mem_we:
                    old = self.ram[idx]
                    mask = sum(0xFF << (8 * k) for k in range(4) if mem_be >> k & 1)
                    self.ram[idx] = (old & ~mask) | (mem_wdata & mask)
            elif kind == "io" and idx in self.slot_dev:
                acc_dev = self.slot_dev[idx]
                acc = Access(reg, mem_we, not mem_we, mem_wdata)

        if wd is not None and rd != 0:
            self.x[rd] = wd & M32
            info["rd"], info["rf_we"], info["rf_wd"] = rd, 1, wd & M32
        elif wd is not None:
            info["rd"], info["rf_we"], info["rf_wd"] = 0, 0, 0
        info["commit"] = 1
        if self.trace is not None:
            self.trace.append(f"{self.cycles:6d} {self.pc:08x} {i:08x}" + (f"  x{rd}={wd & M32:#010x}" if wd is not None and rd else ""))
        self.pc = npc
        for dv in d.values():
            dv.edge(acc if dv is acc_dev else None, info)

    def run(self, max_cycles=2_000_000):
        while not self.dev["halt"].halted and self.cycles < max_cycles:
            self.step()
        return self

    @property
    def output(self):
        return "".join(self.out)

    def screen_text(self):
        rows = self.dev["screen"].dump()
        if all(r.strip() == "" for r in rows):
            return ""
        return "[screen]\n" + "\n".join("|" + r + "|" for r in rows) + "\n"


def load_hex(path):
    p = Path(path)
    return [int(l, 16) for l in p.read_text().split()] if p.exists() else []


def run_image(prefix, kbd_input="", max_cycles=2_000_000, trace=False):
    m = Machine(load_hex(f"{prefix}.rom.hex"), None, kbd_input)
    if trace:
        m.trace = []
    return m.run(max_cycles)


def run_result(asm_res, kbd_input="", max_cycles=2_000_000, trace=False):
    rom = [asm_res["rom"].get(spec.ROM_BASE + 4 * k, 0) for k in range(spec.ROM_WORDS)]
    m = Machine(rom, None, kbd_input)      # RAM starts empty: crt0 copies the data from ROM
    if trace:
        m.trace = []
    return m.run(max_cycles)


def main(argv=None):
    import argparse
    ap = argparse.ArgumentParser(description="RC-V reference simulator")
    ap.add_argument("image", help="prefix of the .rom.hex/.ram.hex files")
    ap.add_argument("--input", default="", help="keyboard input (\\n allowed)")
    ap.add_argument("--max-cycles", type=int, default=2_000_000)
    ap.add_argument("--trace", action="store_true")
    a = ap.parse_args(argv)
    m = run_image(a.image, a.input.encode().decode("unicode_escape"), a.max_cycles, a.trace)
    if m.trace:
        print("\n".join(m.trace))
    sys.stdout.write(m.output + m.screen_text())
    print(f"\n[{'halted' if m.dev['halt'].halted else 'cycle limit'} after {m.cycles} cycles]")


if __name__ == "__main__":
    main()
