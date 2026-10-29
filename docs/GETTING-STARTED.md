# Getting started (read this first)

You do not need to know Git, Verilog or RISC-V yet. Follow the steps in order.
Everything except Digital works in a web browser.

## Step 1 - Join (5 minutes)

1. Sign in to [github.com](https://github.com) with your own account.
2. Open this repository, click **Issues → New issue → Join RC-V → Get started**.
3. Paste the join code from your slip (like `ABCD-EFGH-JKLM`) and click **Submit new issue**.
4. Wait a minute and refresh. The bot replies with your package, for example
   *"You are building P17 - Instruction field splitter"*. The issue is now your
   notebook: ask questions there.

Never write your name or roll number in this repository; it is public. Keep your
code secret until you have used it: whoever uses it first gets the package.

## Step 2 - Read your task (15 minutes)

Open `packages/PNN-name/README.md` for your package (the bot gave you the link). It
tells you exactly what to build. You hand in four files, all in that folder:

| File | What | Tool |
|---|---|---|
| `PNN.dig` | the circuit | Digital (on your laptop) |
| `pNN_name.v` | the same block in Verilog | any text editor, or GitHub's web editor |
| `pNN.s` | the RISC-V program | any text editor, or GitHub's web editor |
| `DOSSIER.md` | your answers | GitHub's web editor |

## Step 3 - Make your own copy of the repository: a fork (2 minutes)

Click **Fork** (top right of the repository page) → **Create fork**. You now have
`github.com/<you>/rc-v`. You work in your fork and then *ask* for your work to be
taken into the class repository: that request is a **pull request**. This is how
real teams work on one big project without overwriting each other.

## Step 4 - Install Digital (10 minutes)

1. Install Java if you do not have it: [adoptium.net](https://adoptium.net) → Temurin 21 (JRE is enough).
2. Download Digital v0.31: <https://github.com/hneemann/Digital/releases/tag/v0.31> → `Digital.zip`.
   Unzip it anywhere and double-click `Digital.exe` (Windows) or `Digital.jar`.
3. In Digital: **Edit → Settings → Use IEEE 91-1984 shapes** (the gate shapes from our textbook).

## Step 5 - Build your circuit

1. From your fork, open `packages/PNN-name/PNN.dig` → **Download raw file** (the ⬇ button).
2. Open it in Digital. The input and output pins are already there, plus a test table.
   **Do not rename, move or delete the pins.**
3. Build the circuit with the parts your README allows.
4. Press **F8** (Tests → Run tests). Every row must turn green.
5. Save.

## Step 6 - Hand it in (pull request)

1. In **your fork** on GitHub, open your package folder → **Add file → Upload files** →
   drop in your `PNN.dig` → **Commit changes**.
2. GitHub shows a yellow bar *"This branch is 1 commit ahead"* → **Contribute → Open pull request**
   → **Create pull request**.
3. Within a few minutes the **RC-V checker** comments on your pull request: ✅ pass,
   ❌ fail (with the reason) or ⬜ not started yet.
4. If something fails, fix it, upload again in your fork; the pull request and the
   comment update by themselves.
5. When everything you handed in passes, the pull request is merged automatically
   and your tile on the class board turns green for that part.

You can hand in the four files one at a time; each one gets merged when it passes.

## Step 7 - Verilog and the program

Edit `pNN_name.v` and `pNN.s` directly on GitHub in your fork: open the file → ✏️ (edit)
→ write → **Commit changes** → open a pull request as above. The checker runs your
Verilog against its test bench and your program on the RC-V simulator.

* Verilog: start from the examples in `docs/ARCHITECTURE.md` and the course's HDL platform.
  You can also try it online at [edaplayground.com](https://www.edaplayground.com)
  (Icarus Verilog), pasting your module and `tests/tb_*.v`.
* RISC-V: read `docs/ISA.md`. To try code online before handing it in, the course's HDL
  platform has a RISC-V simulator; the checker's output shows exactly what your
  program printed.

## Step 8 - Dossier and reviews

Fill in `DOSSIER.md` (edit on GitHub). For E2, open your review partners' pull requests
(**Pull requests** tab, search for their package number), click **Files changed**, and
leave at least one useful comment each: what works, what could be clearer, a test they
could add. Paste the links into your dossier.

## Getting help

* Ask in your join issue (your notebook). Mention your partners with @.
* Look at the class board to see who has already finished a similar block.
* Error messages from the checker tell you which test row failed and what was expected.

## Optional: working on your laptop with Git

If you want to learn the command line (recommended for later semesters):

```bash
git clone https://github.com/<you>/rc-v.git
cd rc-v/tools
python -m rcv.check 17          # needs Python 3; Digital tests need RCV_DIGITAL_JAR set
```

Then `git add`, `git commit -m "P17: Digital circuit"` and `git push`, and open the pull
request on GitHub. GitHub Desktop (desktop.github.com) does the same with buttons.
