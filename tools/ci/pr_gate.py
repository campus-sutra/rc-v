"""Decide what a pull request touches and whether its author may touch it.

    python tools/ci/pr_gate.py <base-sha> <head-sha> <author> <members.json>

Prints JSON: {"packages": [17], "problems": [...], "teacher": false}.
Students may change only the four hand-in files of the package they joined:
PNN.dig (+ helper PNN_*.dig sub-circuits), pNN_slug.v, pNN.s, DOSSIER.md
(+ images for the dossier).
"""
import json
import re
import subprocess
import sys

TEACHERS = {"nikhilkrajput"}
STUDENT_FILE = re.compile(
    r"^packages/P(\d\d)-[a-z0-9_]+/("
    r"P\d\d(_[A-Za-z0-9_]+)?\.dig|p\d\d_[a-z0-9_]+\.v|p\d\d\.s|DOSSIER\.md|[A-Za-z0-9_-]+\.(png|jpg|jpeg|svg))$")


def main(base, head, author, members_path):
    files = subprocess.run(["git", "diff", "--name-only", f"{base}...{head}"], capture_output=True,
                           text=True, check=True).stdout.split()
    try:
        members = json.load(open(members_path))
    except (OSError, ValueError):
        members = {}
    owned = {int(k) for k, v in members.items() if v.get("github", "").lower() == author.lower()}
    pk, problems = set(), []
    teacher = author.lower() in TEACHERS
    for f in files:
        m = STUDENT_FILE.match(f)
        if m:
            n = int(m.group(1))
            pk.add(n)
            if not teacher and n not in owned:
                problems.append(f"`{f}`: package P{n:02d} is not yours" +
                                (" (you have not joined yet: open a Join issue)" if not owned else
                                 f" (yours: {', '.join(f'P{k:02d}' for k in sorted(owned))})"))
        elif f.startswith("packages/P") and not teacher:
            problems.append(f"`{f}`: only your four hand-in files may change (not tests/ or README.md)")
            m2 = re.match(r"packages/P(\d\d)", f)
            pk.add(int(m2.group(1)))
        elif not teacher:
            problems.append(f"`{f}`: files outside packages/ belong to the teacher")
    print(json.dumps({"packages": sorted(pk), "problems": problems, "teacher": teacher}))


if __name__ == "__main__":
    main(*sys.argv[1:5])
