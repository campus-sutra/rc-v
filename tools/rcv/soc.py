"""Build and run the whole RC-V computer in Verilog (the class build).

    python -m rcv.soc program.s [--input file] [--fallback DIR] [--userom]

For every package the student's module in packages/ is used. With
--fallback DIR, a package whose module is missing or fails its own test
bench is taken from DIR instead (the teacher's integration build).
Set RCV_DOCKER=1 to run iverilog inside the rcv-tools Docker image.
"""
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

from . import spec
from .asm import assemble
from .packages import PACKAGES
from .progrun import wrapper

ROOT = Path(os.environ.get("RCV_ROOT") or Path(__file__).resolve().parents[2])
LIB = ROOT / "sw" / "lib"


def sh(cmd, cwd):
    """Run a shell command with iverilog available (natively or in Docker)."""
    if os.environ.get("RCV_DOCKER"):
        drive = str(Path(cwd).resolve())
        mount = drive.replace("\\", "/")
        full = ["docker", "run", "--rm", "-v", f"{mount}:/w", "-w", "/w", "rcv-tools", "sh", "-c", cmd]
        env = dict(os.environ, MSYS_NO_PATHCONV="1")
        return subprocess.run(full, capture_output=True, text=True, env=env)
    return subprocess.run(["sh", "-c", cmd], cwd=cwd, capture_output=True, text=True)


def package_dir(p):
    return ROOT / "packages" / f"P{p['id']:02d}-{p['slug']}"


def module_file(p):
    return package_dir(p) / f"p{p['id']:02d}_{p['slug']}.v"


def is_placeholder(path):
    t = path.read_text(encoding="utf-8", errors="replace")
    return "// placeholder" in t


def unit_test(p, vfile, work):
    """Run the package's own test bench on vfile; True if it passes."""
    d = Path(work) / f"ut{p['id']}"
    d.mkdir()
    shutil.copy(vfile, d / "dut.v")
    for f in (package_dir(p) / "tests").iterdir():
        if f.is_file():
            shutil.copy(f, d / f.name)
    tb = f"tb_p{p['id']:02d}_{p['slug']}.v"
    (d / "tests").mkdir()
    if (d / "boot_test.hex").exists():
        shutil.copy(d / "boot_test.hex", d / "tests" / "boot_test.hex")
    r = sh(f"iverilog -g2012 -o sim {tb} dut.v && vvp -n sim", d)
    return "RESULT PASS" in r.stdout


def choose_modules(fallback=None, work=None, check=True):
    """Return (list of files, report dict pid -> 'student'|'reference'|'missing')."""
    files, report = [], {}
    for p in PACKAGES:
        f = module_file(p)
        ok = f.exists() and not is_placeholder(f) and (not check or unit_test(p, f, work))
        if ok:
            files.append(f)
            report[p["id"]] = "student"
        elif fallback and (Path(fallback) / f.name).exists():
            files.append(Path(fallback) / f.name)
            report[p["id"]] = "reference"
        else:
            files.append(f)
            report[p["id"]] = "missing"
    return files, report


def build_rom(sources, out_hex):
    res = assemble(sources)
    if res["errors"]:
        raise SystemExit("\n".join(res["errors"]))
    words = [res["rom"].get(spec.ROM_BASE + 4 * k, 0) for k in range(spec.ROM_WORDS)]
    Path(out_hex).write_text("".join(f"{w:08x}\n" for w in words))
    return res


def run_soc(sources, kbd_input="", fallback=None, userom=False, max_cycles=3_000_000, check=True):
    work = tempfile.mkdtemp(prefix="rcv_soc_")
    try:
        build_rom(sources, Path(work) / "rom.hex")
        (Path(work) / "kbd.in").write_bytes(kbd_input.encode())
        files, report = choose_modules(fallback, work, check)
        vdir = Path(work) / "v"
        vdir.mkdir()
        names = []
        for f in files:
            shutil.copy(f, vdir / f.name)
            names.append(f"v/{f.name}")
        shutil.copy(ROOT / "shared/rtl/rcv_soc.v", Path(work) / "rcv_soc.v")
        shutil.copy(ROOT / "shared/sim/soc_tb.v", Path(work) / "soc_tb.v")
        cmd = (f"iverilog -g2012 -s soc_tb -o soc -P soc_tb.ROM_FILE=\\\"rom.hex\\\" soc_tb.v rcv_soc.v {' '.join(names)}"
               f" && vvp -n soc +input=kbd.in +maxcycles={max_cycles}" + (" +userom" if userom else ""))
        r = sh(cmd, work)
        out = r.stdout
        out = "\n".join(l for l in out.splitlines() if not l.startswith(("VCD", "soc_tb.v:"))) + "\n"
        return out, r.stderr, report
    finally:
        shutil.rmtree(work, ignore_errors=True)


def program_sources(n, path):
    return [("crt0.s", (LIB / "crt0.s").read_text()), ("wrapper.s", wrapper(n)),
            (str(path), Path(path).read_text(encoding="utf-8")), ("rcv_lib.s", (LIB / "rcv_lib.s").read_text())]


def main(argv=None):
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument("n", type=int, help="package number of the program")
    ap.add_argument("program")
    ap.add_argument("--input-file")
    ap.add_argument("--fallback")
    ap.add_argument("--userom", action="store_true")
    ap.add_argument("--no-check", action="store_true", help="skip the per-module test benches")
    a = ap.parse_args(argv)
    inp = Path(a.input_file).read_text() if a.input_file else ""
    out, err, report = run_soc(program_sources(a.n, a.program), inp, a.fallback, a.userom, check=not a.no_check)
    sys.stdout.write(out)
    if err.strip():
        print(err, file=sys.stderr)
    used = {k: sum(1 for v in report.values() if v == k) for k in ("student", "reference", "missing")}
    print(f"[modules: {used['student']} student, {used['reference']} reference, {used['missing']} missing]", file=sys.stderr)


if __name__ == "__main__":
    main()
