"""Run a package program on the RC-V simulator.

    python -m rcv.progrun 17 ../packages/P17-ifields/p17.s --input "0x00a50533\\n"

The program is linked as  crt0 + wrapper + your file + rcv_lib. The wrapper
fills s0-s11 with marker values, calls pNN_main and reports an ABI error if
your routine did not give back sp and the s registers unchanged.
"""
import os
import re
import sys
from pathlib import Path

from . import spec
from .asm import assemble
from .sim import run_result

ROOT = Path(os.environ.get("RCV_ROOT") or Path(__file__).resolve().parents[2])
LIB = ROOT / "sw" / "lib"


def wrapper(n):
    sets = "\n".join(f"        li      s{k}, {0x5A000000 + k}" for k in range(12))
    checks = "\n".join(f"        li      t0, {0x5A000000 + k}\n        bne     s{k}, t0, rcv_w_abi" for k in range(12))
    return f"""
        .text
main:
        addi    sp, sp, -4
        sw      ra, 0(sp)
        mv      t6, sp
        la      t0, rcv_w_sp
        sw      t6, 0(t0)
{sets}
        call    p{n:02d}_main
        la      t0, rcv_w_sp
        lw      t0, 0(t0)
        bne     sp, t0, rcv_w_abi
{checks}
        lw      ra, 0(sp)
        addi    sp, sp, 4
        ret
rcv_w_abi:
        la      a0, rcv_w_msg
        call    rcv_puts
        li      t0, HALT_HALT
        sw      zero, 0(t0)
rcv_w_stop:
        j       rcv_w_stop
rcv_w_msg:
        .asciz  "\\n[ABI error: sp or an s register was not restored]\\n"
        .align  2
        .data
rcv_w_sp:
        .word   0
"""


def link(n, src_text, src_name="program.s"):
    sources = [("crt0.s", (LIB / "crt0.s").read_text()), ("wrapper.s", wrapper(n)),
               (src_name, src_text), ("rcv_lib.s", (LIB / "rcv_lib.s").read_text())]
    return assemble(sources)


def label_problems(n, res, src_text):
    """Labels defined in the student's file must start with pNN_."""
    bad = []
    for line in src_text.splitlines():
        line = re.sub(r"#.*", "", line)
        for m in re.finditer(r"^\s*([A-Za-z_.$][\w.$]*)\s*:", line):
            lab = m.group(1)
            if not lab.lower().startswith(f"p{n:02d}_"):
                bad.append(lab)
        m = re.match(r"\s*\.(equ|set)\s+([A-Za-z_][\w]*)", line)
        if m and not m.group(2).lower().startswith(f"p{n:02d}_"):
            bad.append(m.group(2))
    return bad


def run(n, src_text, kbd_input, max_cycles=3_000_000, trace=False):
    res = link(n, src_text)
    if res["errors"]:
        return None, res["errors"]
    m = run_result(res, kbd_input, max_cycles, trace)
    out = m.output + m.screen_text()
    if not m.dev["halt"].halted:
        out += f"\n[did not finish within {max_cycles} cycles]\n"
    return m, out


def main(argv=None):
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument("n", type=int)
    ap.add_argument("file")
    ap.add_argument("--input", default="")
    ap.add_argument("--input-file")
    ap.add_argument("--trace", action="store_true")
    a = ap.parse_args(argv)
    text = Path(a.file).read_text(encoding="utf-8")
    inp = Path(a.input_file).read_text() if a.input_file else a.input.encode().decode("unicode_escape")
    m, out = run(a.n, text, inp, trace=a.trace)
    if m is None:
        print("\n".join(out))
        return 1
    if a.trace:
        print("\n".join(m.trace))
    sys.stdout.write(out)
    bad = label_problems(a.n, None, text)
    if bad:
        print(f"[label rule: these labels must start with p{a.n:02d}_: {', '.join(bad)}]")
    print(f"[{m.cycles} cycles]", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
