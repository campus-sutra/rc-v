"""rcv-asm: a small two-pass assembler for the RC-V subset of RV32I.

    python -m rcv.asm prog.s [more.s ...] -o build/prog

Writes prog.rom.hex (instruction ROM, one word per line), prog.ram.hex
(initial RAM) and prog.lst (listing with addresses and machine code).

Supported: LUI AUIPC JAL JALR BEQ BNE BLT BGE BLTU BGEU LB LBU LW SB SW
ADDI SLTI SLTIU XORI ORI ANDI SLLI SRLI SRAI ADD SUB SLL SLT SLTU XOR SRL SRA
OR AND ECALL MRET CSRRW CSRRS CSRRC, the usual pseudo-instructions (li la mv
not neg j jr ret call nop beqz bnez bltz bgez blez bgtz bgt ble bgtu bleu
seqz snez csrr csrw csrs csrc) and the directives .text .data .rodata .word
.byte .ascii .asciz .string .space .align .equ .set .globl.
"""
import re
import sys
from pathlib import Path

from . import spec

REGS = {f"x{i}": i for i in range(32)}
REGS.update({n: i for i, n in enumerate(
    "zero ra sp gp tp t0 t1 t2 s0 s1 a0 a1 a2 a3 a4 a5 a6 a7 "
    "s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 t3 t4 t5 t6".split())})
REGS["fp"] = 8

R = {"add": (0, 0), "sub": (0, 0x20), "sll": (1, 0), "slt": (2, 0), "sltu": (3, 0),
     "xor": (4, 0), "srl": (5, 0), "sra": (5, 0x20), "or": (6, 0), "and": (7, 0)}
I_ALU = {"addi": 0, "slti": 2, "sltiu": 3, "xori": 4, "ori": 6, "andi": 7}
SHIFT_I = {"slli": (1, 0), "srli": (5, 0), "srai": (5, 0x20)}
LOADS = {"lb": 0, "lw": 2, "lbu": 4}
STORES = {"sb": 0, "sw": 2}
BRANCH = {"beq": 0, "bne": 1, "blt": 4, "bge": 5, "bltu": 6, "bgeu": 7}
CSRI = {"csrrw": 1, "csrrs": 2, "csrrc": 3}
UNSUPPORTED = {"lh", "lhu", "sh", "mul", "div", "rem", "fence", "ebreak"}


class AsmError(Exception):
    pass


def _u(v, bits):
    return v & ((1 << bits) - 1)


def enc_r(f7, rs2, rs1, f3, rd, op):
    return (f7 << 25) | (rs2 << 20) | (rs1 << 15) | (f3 << 12) | (rd << 7) | op


def enc_i(imm, rs1, f3, rd, op):
    return (_u(imm, 12) << 20) | (rs1 << 15) | (f3 << 12) | (rd << 7) | op


def enc_s(imm, rs2, rs1, f3, op):
    imm = _u(imm, 12)
    return ((imm >> 5) << 25) | (rs2 << 20) | (rs1 << 15) | (f3 << 12) | ((imm & 31) << 7) | op


def enc_b(imm, rs2, rs1, f3, op):
    imm = _u(imm, 13)
    return (((imm >> 12) & 1) << 31) | (((imm >> 5) & 63) << 25) | (rs2 << 20) | (rs1 << 15) | \
           (f3 << 12) | (((imm >> 1) & 15) << 8) | (((imm >> 11) & 1) << 7) | op


def enc_u(imm, rd, op):
    return (_u(imm, 20) << 12) | (rd << 7) | op


def enc_j(imm, rd, op):
    imm = _u(imm, 21)
    return (((imm >> 20) & 1) << 31) | (((imm >> 1) & 1023) << 21) | (((imm >> 11) & 1) << 20) | \
           (((imm >> 12) & 255) << 12) | (rd << 7) | op


def split_operands(s):
    out, cur, quote = [], "", None
    for ch in s:
        if quote:
            cur += ch
            if ch == quote:
                quote = None
        elif ch in "'\"":
            quote = ch
            cur += ch
        elif ch == ",":
            out.append(cur.strip())
            cur = ""
        else:
            cur += ch
    if cur.strip():
        out.append(cur.strip())
    return out


def strip_comment(line):
    out, quote = "", None
    i = 0
    while i < len(line):
        ch = line[i]
        if quote:
            out += ch
            if ch == "\\" and i + 1 < len(line):
                out += line[i + 1]
                i += 1
            elif ch == quote:
                quote = None
        elif ch in "'\"":
            quote = ch
            out += ch
        elif ch == "#" or line.startswith("//", i) or ch == ";":
            break
        else:
            out += ch
        i += 1
    return out


ESC = {"n": "\n", "t": "\t", "r": "\r", "0": "\0", "\\": "\\", "'": "'", '"': '"'}


def unescape(s):
    out, i = "", 0
    while i < len(s):
        if s[i] == "\\" and i + 1 < len(s):
            out += ESC.get(s[i + 1], s[i + 1])
            i += 2
        else:
            out += s[i]
            i += 1
    return out


class Assembler:
    def __init__(self):
        self.symbols = dict(self.predefined())
        self._seen1 = set()
        self.errors = []

    @staticmethod
    def predefined():
        syms = {"ROM_BASE": spec.ROM_BASE, "RAM_BASE": spec.RAM_BASE, "_data_load": 0,
                "_data_start": spec.RAM_BASE, "_data_end": spec.RAM_BASE,
                "IO_BASE": spec.IO_BASE, "STACK_TOP": spec.STACK_TOP}
        for slot, (name, _pkg, regs) in spec.DEVICES.items():
            syms[f"{name.upper()}_BASE"] = spec.io_addr(slot, 0)
            for r, idx in regs.items():
                syms[f"{name.upper()}_{r}"] = spec.io_addr(slot, idx)
            syms[f"{name.upper()}_ID"] = spec.io_addr(slot, spec.ID_REG)
        for n, v in spec.CSR.items():
            syms[n] = v
        return syms

    # ---------------------------------------------------------------- values
    def value(self, expr, pass_no, loc):
        e = expr.strip()
        m = re.fullmatch(r"%(hi|lo)\((.*)\)", e)
        if m:
            v = self.value(m.group(2), pass_no, loc)
            lo = ((v & 0xFFF) ^ 0x800) - 0x800
            return _u((v - lo) >> 12, 20) if m.group(1) == "hi" else lo
        tokens = re.findall(r"'(?:\\.|[^'])'|0[xX][0-9a-fA-F_]+|0[bB][01_]+|\d+|[A-Za-z_.$][\w.$]*|[-+*/()<>&|^~]+", e)
        if "".join(tokens).replace(" ", "") != e.replace(" ", ""):
            raise AsmError(f"cannot read value '{expr}'")
        py = ""
        for t in tokens:
            if t.startswith("'"):
                py += str(ord(unescape(t[1:-1])))
            elif re.fullmatch(r"0[xX][0-9a-fA-F_]+|0[bB][01_]+|\d+", t):
                py += str(int(t.replace("_", ""), 0))
            elif re.fullmatch(r"[A-Za-z_.$][\w.$]*", t):
                if t == ".":
                    py += str(loc)
                elif t in self.symbols:
                    py += str(self.symbols[t])
                elif pass_no == 1:
                    py += "0"
                else:
                    raise AsmError(f"unknown label or constant '{t}'")
            else:
                py += t.replace("/", "//")
        try:
            return int(eval(py, {"__builtins__": {}}))
        except Exception:
            raise AsmError(f"cannot evaluate '{expr}'")

    def reg(self, r):
        r = r.strip().lower()
        if r not in REGS:
            raise AsmError(f"'{r}' is not a register")
        return REGS[r]

    def mem_operand(self, s, pass_no, loc):
        m = re.fullmatch(r"(.*)\(\s*([\w]+)\s*\)", s.strip())
        if not m:
            raise AsmError(f"expected offset(register), got '{s}'")
        off = self.value(m.group(1), pass_no, loc) if m.group(1).strip() else 0
        return off, self.reg(m.group(2))

    # --------------------------------------------------------- instructions
    def size_of(self, mn, ops):
        return 8 if mn in ("li", "la", "call_far") else 4

    def expand(self, mn, ops, pc, p):
        """Return a list of 32-bit words for one source instruction."""
        v = lambda x: self.value(x, p, pc)
        rg = self.reg

        def need(n):
            if len(ops) != n:
                raise AsmError(f"'{mn}' needs {n} operands, got {len(ops)}")

        def check_imm(x, bits, what="immediate"):
            if p == 2 and not (-(1 << (bits - 1)) <= x < (1 << (bits - 1))):
                raise AsmError(f"{what} {x} does not fit in {bits} signed bits")
            return x

        def branch_off(target):
            off = v(target) - pc
            if p == 2 and (off % 2 or not -4096 <= off < 4096):
                raise AsmError(f"branch target too far or misaligned ({off} bytes)")
            return off

        if mn in UNSUPPORTED:
            raise AsmError(f"'{mn}' is not part of the RC-V subset")
        if mn in R:
            need(3); f3, f7 = R[mn]
            return [enc_r(f7, rg(ops[2]), rg(ops[1]), f3, rg(ops[0]), 0x33)]
        if mn in I_ALU:
            need(3)
            return [enc_i(check_imm(v(ops[2]), 12), rg(ops[1]), I_ALU[mn], rg(ops[0]), 0x13)]
        if mn in SHIFT_I:
            need(3); f3, f7 = SHIFT_I[mn]
            sh = v(ops[2])
            if p == 2 and not 0 <= sh < 32:
                raise AsmError("shift amount must be 0..31")
            return [enc_r(f7, sh & 31, rg(ops[1]), f3, rg(ops[0]), 0x13)]
        if mn in LOADS:
            need(2); off, base = self.mem_operand(ops[1], p, pc)
            return [enc_i(check_imm(off, 12, "offset"), base, LOADS[mn], rg(ops[0]), 0x03)]
        if mn in STORES:
            need(2); off, base = self.mem_operand(ops[1], p, pc)
            return [enc_s(check_imm(off, 12, "offset"), rg(ops[0]), base, STORES[mn], 0x23)]
        if mn in BRANCH:
            need(3)
            return [enc_b(branch_off(ops[2]), rg(ops[1]), rg(ops[0]), BRANCH[mn], 0x63)]
        if mn == "lui":
            need(2); return [enc_u(v(ops[1]), rg(ops[0]), 0x37)]
        if mn == "auipc":
            need(2); return [enc_u(v(ops[1]), rg(ops[0]), 0x17)]
        if mn == "jal":
            if len(ops) == 1:
                ops = ["ra", ops[0]]
            need(2)
            off = v(ops[1]) - pc
            if p == 2 and not -(1 << 20) <= off < (1 << 20):
                raise AsmError("jal target too far")
            return [enc_j(off, rg(ops[0]), 0x6F)]
        if mn == "jalr":
            if len(ops) == 1:
                return [enc_i(0, rg(ops[0]), 0, 1, 0x67)]
            if len(ops) == 2 and "(" in ops[1]:
                off, base = self.mem_operand(ops[1], p, pc)
                return [enc_i(off, base, 0, rg(ops[0]), 0x67)]
            need(3); return [enc_i(check_imm(v(ops[2]), 12), rg(ops[1]), 0, rg(ops[0]), 0x67)]
        if mn == "ecall":
            return [0x00000073]
        if mn == "mret":
            return [0x30200073]
        if mn in CSRI:
            need(3)
            return [enc_i(v(ops[1]), rg(ops[2]), CSRI[mn], rg(ops[0]), 0x73)]
        # ------------------------------------------------------ pseudo-ops
        if mn == "nop":
            return [enc_i(0, 0, 0, 0, 0x13)]
        if mn == "li":
            need(2); rd = rg(ops[0]); x = _u(v(ops[1]), 32)
            sx = x - (1 << 32) if x & 0x80000000 else x
            lo = ((x & 0xFFF) ^ 0x800) - 0x800
            hi = _u((sx - lo) >> 12, 20)
            if -2048 <= sx < 2048:     # still two words so sizes never change between passes
                return [enc_i(sx, 0, 0, rd, 0x13), enc_i(0, 0, 0, 0, 0x13)]
            return [enc_u(hi, rd, 0x37), enc_i(lo, rd, 0, rd, 0x13)]
        if mn == "la":
            need(2); rd = rg(ops[0]); x = _u(v(ops[1]), 32)
            lo = ((x & 0xFFF) ^ 0x800) - 0x800
            return [enc_u(_u((x - lo) >> 12, 20), rd, 0x37), enc_i(lo, rd, 0, rd, 0x13)]
        if mn == "mv":
            need(2); return [enc_i(0, rg(ops[1]), 0, rg(ops[0]), 0x13)]
        if mn == "not":
            need(2); return [enc_i(-1, rg(ops[1]), 4, rg(ops[0]), 0x13)]
        if mn == "neg":
            need(2); return [enc_r(0x20, rg(ops[1]), 0, 0, rg(ops[0]), 0x33)]
        if mn == "seqz":
            need(2); return [enc_i(1, rg(ops[1]), 3, rg(ops[0]), 0x13)]
        if mn == "snez":
            need(2); return [enc_r(0, rg(ops[1]), 0, 3, rg(ops[0]), 0x33)]
        if mn == "j":
            need(1); return self.expand("jal", ["zero", ops[0]], pc, p)
        if mn == "call":
            need(1); return self.expand("jal", ["ra", ops[0]], pc, p)
        if mn == "tail":
            need(1); return self.expand("jal", ["zero", ops[0]], pc, p)
        if mn == "jr":
            need(1); return [enc_i(0, rg(ops[0]), 0, 0, 0x67)]
        if mn == "ret":
            return [enc_i(0, 1, 0, 0, 0x67)]
        z = {"beqz": ("beq", 0), "bnez": ("bne", 0), "bltz": ("blt", 0), "bgez": ("bge", 0)}
        if mn in z:
            need(2); b, _ = z[mn]
            return self.expand(b, [ops[0], "zero", ops[1]], pc, p)
        if mn == "blez":
            need(2); return self.expand("bge", ["zero", ops[0], ops[1]], pc, p)
        if mn == "bgtz":
            need(2); return self.expand("blt", ["zero", ops[0], ops[1]], pc, p)
        sw = {"bgt": "blt", "ble": "bge", "bgtu": "bltu", "bleu": "bgeu"}
        if mn in sw:
            need(3); return self.expand(sw[mn], [ops[1], ops[0], ops[2]], pc, p)
        if mn == "csrr":
            need(2); return self.expand("csrrs", [ops[0], ops[1], "zero"], pc, p)
        if mn in ("csrw", "csrs", "csrc"):
            need(2)
            base = {"csrw": "csrrw", "csrs": "csrrs", "csrc": "csrrc"}[mn]
            return self.expand(base, ["zero", ops[0], ops[1]], pc, p)
        raise AsmError(f"unknown instruction '{mn}'")

    # ----------------------------------------------------------------- passes
    def run(self, sources):
        """sources: list of (filename, text). Returns dict with rom, ram, listing."""
        lines = []
        for fname, text in sources:
            for n, raw in enumerate(text.splitlines(), 1):
                lines.append((fname, n, raw))
        for p in (1, 2):
            rom, ram = {}, {}
            loc = {"text": spec.ROM_BASE, "data": spec.RAM_BASE}
            sect = "text"
            listing = []
            self.errors = []
            cur_file = None
            for fname, n, raw in lines:
                if fname != cur_file:           # every file starts in .text
                    cur_file, sect = fname, "text"
                where = f"{fname}:{n}"
                line = strip_comment(raw).strip()
                try:
                    while True:
                        m = re.match(r"([A-Za-z_.$][\w.$]*)\s*:(?!=)", line)
                        if not m:
                            break
                        lab = m.group(1)
                        if p == 1:
                            if lab in self._seen1:
                                raise AsmError(f"label '{lab}' defined twice")
                            self._seen1.add(lab)
                            self.symbols[lab] = loc[sect]
                        line = line[m.end():].strip()
                    if not line:
                        continue
                    parts = line.split(None, 1)
                    mn = parts[0].lower()
                    rest = parts[1] if len(parts) > 1 else ""
                    if mn.startswith("."):
                        sect = self.directive(mn, rest, loc, sect, rom, ram, p)
                        continue
                    if sect != "text":
                        raise AsmError("instructions must be in .text")
                    ops = split_operands(rest)
                    pc = loc["text"]
                    words = self.expand(mn, ops, pc, p)
                    for i, w in enumerate(words):
                        rom[pc + 4 * i] = w
                    listing.append((pc, words, raw.strip(), where))
                    loc["text"] += 4 * len(words)
                except AsmError as e:
                    self.errors.append(f"{where}: {e}")
            if self.errors and p == 1:
                break
            # initial data is stored in ROM after the code; crt0 copies it to RAM
            data_load = (loc["text"] + 3) & ~3
            data_end = (loc["data"] + 3) & ~3
            self.symbols.update(_data_load=data_load, _data_start=spec.RAM_BASE, _data_end=data_end)
        if self.errors:
            return {"rom": {}, "ram": {}, "listing": [], "symbols": self.symbols,
                    "errors": self.errors, "text_end": 0, "data_end": 0}
        for k in range(0, data_end - spec.RAM_BASE, 4):
            rom[data_load + k] = ram.get(spec.RAM_BASE + k, 0)
        if data_load + (data_end - spec.RAM_BASE) > spec.ROM_BASE + spec.ROM_WORDS * 4:
            self.errors.append("program and its initial data are too large for the 64 KB ROM")
        if loc["data"] > spec.RAM_BASE + spec.RAM_WORDS * 4 - 1024:
            self.errors.append("data too large: leave at least 1 KB of RAM for the stack")
        return {"rom": rom, "ram": ram, "listing": listing, "symbols": self.symbols,
                "errors": self.errors, "text_end": loc["text"], "data_end": loc["data"]}

    def directive(self, d, rest, loc, sect, rom, ram, p):
        if d in (".text",):
            return "text"
        if d in (".data", ".bss"):
            return "data"
        if d in (".rodata", ".section"):
            return "text" if d == ".rodata" or "rodata" in rest else "data"
        if d in (".globl", ".global", ".type", ".size", ".file", ".option"):
            return sect
        if d in (".equ", ".set"):
            name, val = split_operands(rest)
            self.symbols[name.strip()] = self.value(val, p, loc[sect])
            return sect
        mem = rom if sect == "text" else ram

        def put_byte(b):
            a = loc[sect]
            w = a & ~3
            mem[w] = (mem.get(w, 0) & ~(0xFF << 8 * (a & 3))) | ((b & 0xFF) << 8 * (a & 3))
            loc[sect] += 1

        if d == ".word":
            if loc[sect] % 4:
                raise AsmError(".word must be word aligned (use .align 2)")
            for x in split_operands(rest):
                mem[loc[sect]] = _u(self.value(x, p, loc[sect]), 32)
                loc[sect] += 4
        elif d == ".byte":
            for x in split_operands(rest):
                put_byte(self.value(x, p, loc[sect]))
        elif d in (".ascii", ".asciz", ".string"):
            for x in split_operands(rest):
                x = x.strip()
                if not (x.startswith('"') and x.endswith('"')):
                    raise AsmError(f"{d} needs a string in double quotes")
                for ch in unescape(x[1:-1]):
                    put_byte(ord(ch))
                if d != ".ascii":
                    put_byte(0)
        elif d in (".space", ".zero", ".skip"):
            for _ in range(self.value(rest, p, loc[sect])):
                put_byte(0)
        elif d in (".align", ".p2align", ".balign"):
            n = self.value(rest, p, loc[sect])
            step = n if d == ".balign" else (1 << n)
            while loc[sect] % step:
                put_byte(0)
        else:
            raise AsmError(f"unknown directive '{d}'")
        return sect


def assemble(sources):
    return Assembler().run(sources)


def assemble_files(paths):
    return assemble([(str(p), Path(p).read_text(encoding="utf-8")) for p in paths])


def write_outputs(res, out_prefix):
    out = Path(out_prefix)
    out.parent.mkdir(parents=True, exist_ok=True)
    rom = [res["rom"].get(spec.ROM_BASE + 4 * i, 0) for i in range(spec.ROM_WORDS)]
    ram = [res["ram"].get(spec.RAM_BASE + 4 * i, 0) for i in range(spec.RAM_WORDS)]
    Path(f"{out}.rom.hex").write_text("".join(f"{w:08x}\n" for w in rom))
    Path(f"{out}.ram.hex").write_text("".join(f"{w:08x}\n" for w in ram))
    lst = []
    for pc, words, src, where in res["listing"]:
        for i, w in enumerate(words):
            lst.append(f"{pc + 4 * i:08x}  {w:08x}  {src if i == 0 else ''}")
    Path(f"{out}.lst").write_text("\n".join(lst) + "\n")


def main(argv=None):
    import argparse
    ap = argparse.ArgumentParser(description="RC-V assembler")
    ap.add_argument("files", nargs="+")
    ap.add_argument("-o", "--out", default="build/prog")
    a = ap.parse_args(argv)
    res = assemble_files(a.files)
    if res["errors"]:
        print("\n".join(res["errors"]))
        return 1
    write_outputs(res, a.out)
    print(f"ok: {(res['text_end'] - spec.ROM_BASE) // 4} instruction words, "
          f"{res['data_end'] - spec.RAM_BASE} bytes of data")
    return 0


if __name__ == "__main__":
    sys.exit(main())
