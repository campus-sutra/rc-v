"""Reference models of the RC-V I/O devices.

Each device has 16 word registers. `read(reg)` is the value the device drives
on the bus during a cycle (no side effects). `edge(acc, info)` is the clock
edge at the end of the cycle: `acc` describes this cycle's bus access to the
device (or None), `info` describes what the processor did this cycle. All
devices see the state from the *start* of the cycle, exactly like the
hardware, so the order in which edges are applied does not matter.

The Verilog of every device must behave exactly like its model here; the
package test vectors are generated from these classes.
"""
from . import spec

M32 = 0xFFFFFFFF


class Access:
    __slots__ = ("reg", "we", "re", "wdata")

    def __init__(self, reg, we, re, wdata=0):
        self.reg, self.we, self.re, self.wdata = reg, we, re, wdata & M32


class Device:
    slot = None
    pkg = 0

    def reset(self):
        pass

    def read(self, reg):
        if reg == spec.ID_REG:
            return self.pkg
        return self.read_reg(reg) & M32

    def read_reg(self, reg):
        return 0

    def edge(self, acc, info):
        pass

    def irq(self):
        return 0


class Uart(Device):
    """Terminal output. TXSTATUS bit0 = ready. A write while busy is dropped."""
    pkg = 41

    def __init__(self, out=None):
        self.out = out if out is not None else []
        self.reset()

    def reset(self):
        self.busy = 0

    def read_reg(self, r):
        return 1 if (r == 1 and self.busy == 0) else 0

    def edge(self, acc, info):
        if acc and acc.we and acc.reg == 0 and self.busy == 0:
            self.out.append(chr(acc.wdata & 0xFF))
            self.busy = spec.UART_BUSY_CYCLES
        elif self.busy:
            self.busy -= 1


class Kbd(Device):
    """Keyboard: one-character buffer filled from the outside world.
    Reading RXDATA returns the character and empties the buffer (at the edge).
    RXSTATUS bit0 = a character is waiting. irq while a character is waiting."""
    pkg = 42

    def __init__(self, text=""):
        self.queue = list(text)
        self.reset()

    def reset(self):
        self.full, self.data = 0, 0

    def read_reg(self, r):
        if r in (0, 2):
            return self.data if self.full else 0
        if r == 1:
            return self.full
        return 0

    def ext_ready(self):
        return not self.full

    def edge(self, acc, info):
        popped = acc is not None and acc.re and acc.reg == 0
        if popped:
            self.full = 0
        if not self.full and not popped and self.queue:
            # buffer was empty at the start of the cycle: latch the next key
            self.data, self.full = ord(self.queue.pop(0)) & 0xFF, 1

    def irq(self):
        return self.full


class Gpio(Device):
    """LEDS (16 bits, rw), SEG (32 bits, rw, shown on the hex display), BUTTONS (read)."""
    pkg = 43

    def __init__(self, buttons=0xA5):
        self.buttons = buttons
        self.reset()

    def reset(self):
        self.leds, self.seg = 0, 0

    def read_reg(self, r):
        return {0: self.leds, 1: self.seg, 2: self.buttons}.get(r, 0)

    def edge(self, acc, info):
        if acc and acc.we:
            if acc.reg == 0:
                self.leds = acc.wdata & 0xFFFF
            elif acc.reg == 1:
                self.seg = acc.wdata


class Timer(Device):
    """COUNT counts up every cycle while CTRL bit0 (enable). STATUS bit0 (match)
    is set when COUNT == CMP while enabled; any write to STATUS clears it.
    CTRL bit1 = interrupt enable. irq = match & CTRL bit1.
    Writing COUNT loads it (the write wins over counting)."""
    pkg = 46

    def reset(self):
        self.count = self.cmp = self.ctrl = self.match = 0

    def __init__(self):
        self.reset()

    def read_reg(self, r):
        return {0: self.count, 1: self.cmp, 2: self.ctrl, 3: self.match}.get(r, 0)

    def edge(self, acc, info):
        en = self.ctrl & 1
        hit = en and self.count == self.cmp
        if acc and acc.we and acc.reg == 3:
            self.match = 0
        elif hit:
            self.match = 1
        if acc and acc.we and acc.reg == 0:
            self.count = acc.wdata
        elif en:
            self.count = (self.count + 1) & M32
        if acc and acc.we:
            if acc.reg == 1:
                self.cmp = acc.wdata
            elif acc.reg == 2:
                self.ctrl = acc.wdata & 3

    def irq(self):
        return self.match & (self.ctrl >> 1) & 1


class IrqCtrl(Device):
    """PENDING = source lines | SWI (read only). MASK rw (5 bits). CAUSE = index of
    the highest-priority (lowest index) pending & masked source, 31 if none.
    SWI rw: bit0 raises the software interrupt (source 4) until cleared."""
    pkg = 47

    def __init__(self):
        self.reset()
        self.lines = 0

    def reset(self):
        self.mask = self.swi = 0

    def pending(self):
        return (self.lines & 0xF) | ((self.swi & 1) << 4)

    def active(self):
        return self.pending() & self.mask

    def cause(self):
        a = self.active()
        for i in range(5):
            if a >> i & 1:
                return i
        return 31

    def read_reg(self, r):
        return {0: self.pending(), 1: self.mask, 2: self.cause(), 3: self.swi}.get(r, 0)

    def edge(self, acc, info):
        if acc and acc.we:
            if acc.reg == 1:
                self.mask = acc.wdata & 0x1F
            elif acc.reg == 3:
                self.swi = acc.wdata & 1

    def irq(self):
        return 1 if self.active() else 0


class Dma(Device):
    """Copies LEN words from SRC to DST. Write CTRL bit0=1 to start (bit1 = irq
    enable, kept). Each word takes two stolen bus cycles: READ then WRITE.
    STATUS bit0 busy, bit1 done (sticky, cleared by writing STATUS).
    While busy the device requests the bus (req); the processor stalls."""
    pkg = 48

    def __init__(self):
        self.reset()

    def reset(self):
        self.src = self.dst = self.len = 0
        self.ie = self.busy = self.done = 0
        self.phase = 0          # 0 = READ, 1 = WRITE
        self.buf = 0

    def read_reg(self, r):
        return {0: self.src, 1: self.dst, 2: self.len, 3: self.ie << 1,
                4: self.busy | (self.done << 1)}.get(r, 0)

    def req(self):
        return self.busy

    def master(self):
        """Bus request for this cycle: (addr, we, wdata)."""
        if self.phase == 0:
            return self.src, 0, 0
        return self.dst, 1, self.buf

    def edge(self, acc, info, bus_rdata=0):
        if self.busy:
            if self.phase == 0:
                self.buf = bus_rdata
                self.phase = 1
            else:
                self.src = (self.src + 4) & M32
                self.dst = (self.dst + 4) & M32
                self.len = (self.len - 1) & M32
                self.phase = 0
                if self.len == 0:
                    self.busy, self.done = 0, 1
            return
        if acc and acc.we:
            r, v = acc.reg, acc.wdata
            if r == 0: self.src = v
            elif r == 1: self.dst = v
            elif r == 2: self.len = v
            elif r == 3:
                self.ie = (v >> 1) & 1
                if v & 1 and self.len:
                    self.busy, self.phase = 1, 0
                elif v & 1:
                    self.done = 1
            elif r == 4:
                self.done = 0

    def irq(self):
        return self.done & self.ie


class Perf(Device):
    """CYCLE counts every cycle, INSTRET every committed instruction. Writing
    CLEAR zeroes both (the clearing edge itself is not counted)."""
    pkg = 49

    def __init__(self):
        self.reset()

    def reset(self):
        self.cycle = self.instret = 0

    def read_reg(self, r):
        return {0: self.cycle, 1: self.instret}.get(r, 0)

    def edge(self, acc, info):
        if acc and acc.we and acc.reg == 2:
            self.cycle = self.instret = 0
            return
        self.cycle = (self.cycle + 1) & M32
        if info["commit"]:
            self.instret = (self.instret + 1) & M32


class CacheStats(Device):
    """Direct-mapped cache model (16 lines of 16 bytes) watching every committed
    RAM access. Only tags are kept: it measures, it does not store data.
    Includes the tag store (package P35) and the counters (P36)."""
    pkg = 36

    def __init__(self):
        self.reset()

    def reset(self):
        self.valid = [0] * spec.CACHE_LINES
        self.tag = [0] * spec.CACHE_LINES
        self.hits = self.misses = 0

    def lookup(self, addr):
        idx = (addr >> 4) & 15
        tag = addr >> 8
        return idx, tag, bool(self.valid[idx] and self.tag[idx] == tag)

    def read_reg(self, r):
        return {0: self.hits, 1: self.misses}.get(r, 0)

    def edge(self, acc, info):
        if acc and acc.we and acc.reg == 2:
            self.hits = self.misses = 0
        elif info["commit"] and info["ram_access"]:
            idx, tag, hit = self.lookup(info["mem_addr"])
            if hit:
                self.hits = (self.hits + 1) & M32
            else:
                self.misses = (self.misses + 1) & M32
        if info["commit"] and info["ram_access"]:
            idx, tag, hit = self.lookup(info["mem_addr"])
            self.valid[idx], self.tag[idx] = 1, tag


class Mul(Device):
    """Shift-and-add multiplier. Write A and B, then write CTRL bit0 = 1.
    STATUS bit0 = busy for 32 cycles. RESULT = low 32 bits of A*B."""
    pkg = 50

    def __init__(self):
        self.reset()

    def reset(self):
        self.a = self.b = 0
        self.acc = self.mcand = self.mplier = self.count = 0

    def read_reg(self, r):
        return {0: self.a, 1: self.b, 3: 1 if self.count else 0, 4: self.acc}.get(r, 0)

    def edge(self, acc, info):
        if self.count:
            if self.mplier & 1:
                self.acc = (self.acc + self.mcand) & M32
            self.mcand = (self.mcand << 1) & M32
            self.mplier >>= 1
            self.count -= 1
        if acc and acc.we:
            if acc.reg == 0: self.a = acc.wdata
            elif acc.reg == 1: self.b = acc.wdata
            elif acc.reg == 2 and acc.wdata & 1 and not self.count:
                self.acc, self.mcand, self.mplier, self.count = 0, self.a, self.b, spec.MUL_CYCLES


def _lanes(x):
    return [(x >> (8 * i)) & 0xFF for i in range(4)]


def _pack(l):
    return sum((v & 0xFF) << (8 * i) for i, v in enumerate(l))


class Simd(Device):
    """Four 8-bit lanes. SUM = lane-wise add (wrap), SUB = lane-wise subtract
    (wrap), MAX = lane-wise unsigned maximum."""
    pkg = 51

    def __init__(self):
        self.reset()

    def reset(self):
        self.a = self.b = 0

    def read_reg(self, r):
        A, B = _lanes(self.a), _lanes(self.b)
        if r == 0: return self.a
        if r == 1: return self.b
        if r == 2: return _pack([x + y for x, y in zip(A, B)])
        if r == 3: return _pack([max(x, y) for x, y in zip(A, B)])
        if r == 4: return _pack([x - y for x, y in zip(A, B)])
        return 0

    def edge(self, acc, info):
        if acc and acc.we:
            if acc.reg == 0: self.a = acc.wdata
            elif acc.reg == 1: self.b = acc.wdata


def to_bcd(v, digits):
    out = 0
    for i in range(digits):
        out |= (v % 10) << (4 * i)
        v //= 10
    return out


class Bcd(Device):
    """BIN (16 bits, rw). BCD = five packed BCD digits of BIN."""
    pkg = 52

    def __init__(self):
        self.reset()

    def reset(self):
        self.bin = 0

    def read_reg(self, r):
        return {0: self.bin, 1: to_bcd(self.bin, 5)}.get(r, 0)

    def edge(self, acc, info):
        if acc and acc.we and acc.reg == 0:
            self.bin = acc.wdata & 0xFFFF


class Wdt(Device):
    """Watchdog. LOAD rw. CTRL bit0 = enable. While enabled COUNT counts down;
    when it reaches 0 STATUS bit0 (bite) is set (sticky; write STATUS to clear)
    and COUNT reloads from LOAD. Writing KICK reloads COUNT from LOAD.
    Writing CTRL with bit0 = 1 also loads COUNT from LOAD."""
    pkg = 53

    def __init__(self):
        self.reset()

    def reset(self):
        self.load = self.en = self.bite = self.count = 0

    def read_reg(self, r):
        return {0: self.load, 1: self.en, 2: self.bite, 3: self.count}.get(r, 0)

    def edge(self, acc, info):
        w = acc if (acc and acc.we) else None
        if w and w.reg == 2:
            self.bite = 0
        if w and w.reg == 0:
            self.load = w.wdata
        if w and w.reg == 1:
            self.en = w.wdata & 1
            if self.en:
                self.count = self.load
            return
        if w and w.reg == 4:
            self.count = self.load
            return
        if self.en:
            if self.count == 0:
                self.bite = 1
                self.count = self.load
            else:
                self.count -= 1


def lfsr_step(x):
    """16-bit Galois LFSR, taps 0xB400 (x^16 + x^14 + x^13 + x^11 + 1)."""
    lsb = x & 1
    x >>= 1
    if lsb:
        x ^= 0xB400
    return x


class Rng(Device):
    """SEED (write) loads the 16-bit LFSR (0 is replaced by 0xACE1).
    VALUE returns the current value and steps the LFSR (at the edge).
    PEEK returns the value without stepping."""
    pkg = 54

    def __init__(self):
        self.reset()

    def reset(self):
        self.x = 0xACE1

    def read_reg(self, r):
        return self.x if r in (1, 2) else 0

    def edge(self, acc, info):
        if acc and acc.we and acc.reg == 0:
            self.x = (acc.wdata & 0xFFFF) or 0xACE1
        elif acc and acc.re and acc.reg == 1:
            self.x = lfsr_step(self.x)


class SpGuard(Device):
    """Watches writes to sp (x2). MINSP = lowest value written to sp since
    reset/clear (starts at 0xFFFFFFFF). If LIMIT != 0 and sp is set below
    LIMIT, STATUS bit0 is set (sticky; any write to STATUS clears it and resets
    MINSP). irq = STATUS bit0."""
    pkg = 55

    def __init__(self):
        self.reset()

    def reset(self):
        self.limit, self.flag, self.minsp = 0, 0, M32

    def read_reg(self, r):
        return {0: self.limit, 1: self.flag, 2: self.minsp}.get(r, 0)

    def edge(self, acc, info):
        clear = acc and acc.we and acc.reg == 1
        if acc and acc.we and acc.reg == 0:
            self.limit = acc.wdata
        sp_write = info["commit"] and info["rf_we"] and info["rd"] == 2
        if clear:
            self.flag, self.minsp = 0, M32
        elif sp_write:
            v = info["rf_wd"]
            if v < self.minsp:
                self.minsp = v
            if self.limit and v < self.limit:
                self.flag = 1

    def irq(self):
        return self.flag


class Stats(Device):
    """Counts committed loads, stores, branches, taken branches and jumps
    (jal/jalr). Writing CLEAR zeroes all counters."""
    pkg = 56

    def __init__(self):
        self.reset()

    def reset(self):
        self.c = [0] * 5

    def read_reg(self, r):
        return self.c[r] if r < 5 else 0

    def edge(self, acc, info):
        if acc and acc.we and acc.reg == 5:
            self.c = [0] * 5
            return
        if info["commit"]:
            for i, k in enumerate(("is_load", "is_store", "is_branch", "taken", "is_jump")):
                if info[k]:
                    self.c[i] = (self.c[i] + 1) & M32


class Halt(Device):
    """Writing HALT stops the machine (the simulation ends). CODE rw holds an
    exit code. A committed `j .` (jal x0, 0) also halts."""
    pkg = 57

    def __init__(self):
        self.reset()

    def reset(self):
        self.halted = self.code = 0

    def read_reg(self, r):
        return {0: self.halted, 1: self.code}.get(r, 0)

    def edge(self, acc, info):
        if acc and acc.we and acc.reg == 0:
            self.halted = 1
        if acc and acc.we and acc.reg == 1:
            self.code = acc.wdata
        if info["commit"] and info["instr"] == 0x0000006F:
            self.halted = 1


class Bpred(Device):
    """16-entry table of 2-bit counters indexed by pc[5:2], all starting at 1
    (weakly not-taken). Predict taken when counter >= 2. On every committed
    branch: BRANCHES += 1, CORRECT += 1 if the prediction was right, then the
    counter moves toward the outcome. CLEAR zeroes the counts (not the table)."""
    pkg = 58

    def __init__(self):
        self.reset()

    def reset(self):
        self.t = [1] * spec.BPRED_ENTRIES
        self.br = self.ok = 0

    def read_reg(self, r):
        return {0: self.br, 1: self.ok}.get(r, 0)

    def edge(self, acc, info):
        if acc and acc.we and acc.reg == 2:
            self.br = self.ok = 0
            return
        if info["commit"] and info["is_branch"]:
            i = (info["pc"] >> 2) & 15
            pred = self.t[i] >= 2
            self.br = (self.br + 1) & M32
            if pred == bool(info["taken"]):
                self.ok = (self.ok + 1) & M32
            self.t[i] = min(3, self.t[i] + 1) if info["taken"] else max(0, self.t[i] - 1)


def uses_regs(instr):
    """(uses rs1, uses rs2) for the RC-V subset."""
    op = instr & 0x7F
    rs1 = op in (0x67, 0x63, 0x03, 0x23, 0x13, 0x33) or (op == 0x73 and (instr >> 12) & 7)
    rs2 = op in (0x63, 0x23, 0x33)
    return bool(rs1), bool(rs2)


class Hazard(Device):
    """Pipeline hazard meter. For each committed instruction, compare its source
    registers with the destination of the previous committed instruction
    (ignoring x0). RAW1 counts every such dependence; LOADUSE counts those
    where the previous instruction was a load. CLEAR zeroes both and forgets
    the previous instruction."""
    pkg = 59

    def __init__(self):
        self.reset()

    def reset(self):
        self.prev_rd = 0
        self.prev_load = 0
        self.lu = self.raw = 0

    def read_reg(self, r):
        return {0: self.lu, 1: self.raw}.get(r, 0)

    def edge(self, acc, info):
        if acc and acc.we and acc.reg == 2:
            self.lu = self.raw = 0
            self.prev_rd = self.prev_load = 0
            return
        if not info["commit"]:
            return
        ins = info["instr"]
        u1, u2 = uses_regs(ins)
        rs1, rs2 = (ins >> 15) & 31, (ins >> 20) & 31
        dep = self.prev_rd != 0 and ((u1 and rs1 == self.prev_rd) or (u2 and rs2 == self.prev_rd))
        if dep:
            self.raw = (self.raw + 1) & M32
            if self.prev_load:
                self.lu = (self.lu + 1) & M32
        self.prev_rd = info["rd"] if info["rf_we"] else 0
        self.prev_load = 1 if info["is_load"] else 0


def parity8(b):
    return bin(b & 0xFF).count("1") & 1


class Parity(Device):
    """DATA rw. PARITY = even-parity bit of each byte of DATA in bits 3..0 and
    the parity of the whole word in bit 4. ODD = number of bytes with odd parity."""
    pkg = 60

    def __init__(self):
        self.reset()

    def reset(self):
        self.d = 0

    def read_reg(self, r):
        bits = [parity8(self.d >> (8 * i)) for i in range(4)]
        if r == 0: return self.d
        if r == 1: return sum(b << i for i, b in enumerate(bits)) | ((sum(bits) & 1) << 4)
        if r == 2: return sum(bits)
        return 0

    def edge(self, acc, info):
        if acc and acc.we and acc.reg == 0:
            self.d = acc.wdata


class Screen(Device):
    """4 x 16 character screen. CHAR (write) puts a character at the cursor and
    advances; '\\n' (10) moves to the start of the next row; after the last
    position the cursor wraps to 0. CURSOR rw (0..63). CLEAR (write) fills the
    screen with spaces and sets the cursor to 0. READ = character at cursor."""
    pkg = 61

    def __init__(self):
        self.reset()

    def reset(self):
        self.buf = [32] * 64
        self.cur = 0

    def read_reg(self, r):
        return {1: self.cur, 3: self.buf[self.cur]}.get(r, 0)

    def edge(self, acc, info):
        if not (acc and acc.we):
            return
        if acc.reg == 0:
            c = acc.wdata & 0xFF
            if c == 10:
                self.cur = ((self.cur // 16) + 1) * 16 % 64
            else:
                self.buf[self.cur] = c
                self.cur = (self.cur + 1) % 64
        elif acc.reg == 1:
            self.cur = acc.wdata & 63
        elif acc.reg == 2:
            self.buf = [32] * 64
            self.cur = 0

    def dump(self):
        rows = ["".join(chr(c) for c in self.buf[r * 16:(r + 1) * 16]) for r in range(4)]
        return rows


class IrqLat(Device):
    """Interrupt latency meter. While the interrupt line (irq & mie) is high and
    no interrupt has been taken, COUNT counts cycles. When an interrupt trap is
    taken: LAST = COUNT, MAX = max(MAX, COUNT), COUNT = 0. CLEAR zeroes all."""
    pkg = 62

    def __init__(self):
        self.reset()

    def reset(self):
        self.last = self.max = self.count = 0

    def read_reg(self, r):
        return {0: self.last, 1: self.max, 3: self.count}.get(r, 0)

    def edge(self, acc, info):
        if acc and acc.we and acc.reg == 2:
            self.last = self.max = self.count = 0
            return
        if info["trap_irq"]:
            self.last = self.count
            self.max = max(self.max, self.count)
            self.count = 0
        elif info["irq_line"]:
            self.count = (self.count + 1) & M32


class HwStack(Device):
    """8-deep hardware stack. PUSH (write) pushes; POP (read) returns the top
    and removes it at the edge; TOP reads without removing; COUNT = depth.
    STATUS: bit0 empty, bit1 full, bit2 overflow (push when full, sticky),
    bit3 underflow (pop when empty, sticky). Writing STATUS clears bits 2-3."""
    pkg = 63

    def __init__(self):
        self.reset()

    def reset(self):
        self.s = []
        self.ovf = self.unf = 0

    def read_reg(self, r):
        if r in (1, 2): return self.s[-1] if self.s else 0
        if r == 3: return len(self.s)
        if r == 4:
            return (not self.s) | ((len(self.s) == spec.HWSTACK_DEPTH) << 1) | (self.ovf << 2) | (self.unf << 3)
        return 0

    def edge(self, acc, info):
        if not acc:
            return
        if acc.we and acc.reg == 0:
            if len(self.s) < spec.HWSTACK_DEPTH:
                self.s.append(acc.wdata)
            else:
                self.ovf = 1
        elif acc.we and acc.reg == 4:
            self.ovf = self.unf = 0
        elif acc.re and acc.reg == 1:
            if self.s:
                self.s.pop()
            else:
                self.unf = 1


def from_gray(g):
    b = 0
    while g:
        b ^= g
        g >>= 1
    return b


class CodeConv(Device):
    """VAL (16 bits, rw). GRAY = Gray code of VAL. FROMGRAY = binary value of
    VAL read as a Gray code. XS3 = excess-3 code of the four decimal digits of
    VAL mod 10000 (each digit + 3, packed in 4-bit groups)."""
    pkg = 64

    def __init__(self):
        self.reset()

    def reset(self):
        self.v = 0

    def read_reg(self, r):
        v = self.v
        if r == 0: return v
        if r == 1: return v ^ (v >> 1)
        if r == 2: return from_gray(v)
        if r == 3:
            d = v % 10000
            return sum(((d // 10 ** i) % 10 + 3) << (4 * i) for i in range(4))
        return 0

    def edge(self, acc, info):
        if acc and acc.we and acc.reg == 0:
            self.v = acc.wdata & 0xFFFF


class Compl(Device):
    """VAL (32 bits, rw). ONES = ~VAL. TWOS = -VAL. SIGNMAG = VAL (signed) in
    sign-magnitude form (bit31 sign, bits 30..0 magnitude; 0x80000000 maps to
    0x80000000). NINES / TENS = 9's and 10's complement of (VAL mod 10000) as
    four packed BCD digits."""
    pkg = 65

    def __init__(self):
        self.reset()

    def reset(self):
        self.v = 0

    def read_reg(self, r):
        v = self.v
        if r == 0: return v
        if r == 1: return ~v & M32
        if r == 2: return -v & M32
        if r == 3:
            if v & 0x80000000:
                mag = (-v) & M32
                return 0x80000000 | (mag & 0x7FFFFFFF) if mag != 0x80000000 else 0x80000000
            return v
        d = v % 10000
        if r == 4: return to_bcd(9999 - d, 4)
        if r == 5: return to_bcd((10000 - d) % 10000, 4)
        return 0

    def edge(self, acc, info):
        if acc and acc.we and acc.reg == 0:
            self.v = acc.wdata


DEVICE_CLASSES = {
    "uart": Uart, "kbd": Kbd, "gpio": Gpio, "timer": Timer, "irq": IrqCtrl,
    "dma": Dma, "perf": Perf, "cache": CacheStats, "mul": Mul, "simd": Simd,
    "bcd": Bcd, "wdt": Wdt, "rng": Rng, "spguard": SpGuard, "stats": Stats,
    "halt": Halt, "bpred": Bpred, "hazard": Hazard, "parity": Parity,
    "screen": Screen, "irqlat": IrqLat, "hwstack": HwStack, "codeconv": CodeConv,
    "compl": Compl,
}
