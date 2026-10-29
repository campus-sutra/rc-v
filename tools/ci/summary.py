"""Turn the check results into the comment posted on a pull request.

    python tools/ci/summary.py report/   > comment.md
"""
import json
import sys
from pathlib import Path

d = Path(sys.argv[1])
gate = json.loads((d / "gate.json").read_text())
out = ["<!-- rcv-check -->", "## RC-V checker", ""]
if gate["problems"]:
    out += ["**This pull request cannot be merged yet:**", ""]
    out += [f"- {p}" for p in gate["problems"]]
    out += ["", "Fork the repository, change only your own package's four files, and open the pull "
                "request from your fork. See docs/WORKFLOW.md.", ""]
md = d / "check.md"
if md.exists():
    out.append(md.read_text(encoding="utf-8"))
res = json.loads((d / "check.json").read_text()) if (d / "check.json").exists() else {}
parts = [v["status"] for r in res.values() for v in r.values()]
if res and not gate["problems"]:
    if any(s == "fail" for s in parts):
        out.append("\n❌ Fix the failing parts and push again; this comment will update.")
    elif all(s == "pass" for s in parts):
        out.append("\n🎉 Everything passes. This pull request will be merged automatically.")
    else:
        out.append("\n✅ Everything you have handed in so far passes. Parts marked ⬜ are not started; "
                   "this pull request will be merged so the class can use your work now.")
print("\n".join(out))
