# How we work together

RC-V is one repository shared by 66 people. These are the same rules real
engineering teams use, scaled down.

## Ownership

* After you join, your package folder is **yours**: only your GitHub account may change
  its four hand-in files (`PNN.dig`, `pNN_name.v`, `pNN.s`, `DOSSIER.md`, plus pictures for
  the dossier and helper sub-circuits named `PNN_something.dig`).
* `tests/`, `README.md`, `shared/`, `sw/`, `tools/` and `docs/` belong to the teacher. A pull
  request that touches them is rejected automatically.
* Think of it like a shared database where every student's tables start with their own
  prefix: you can *use* everyone's work, but you only *change* your own.

## The cycle: fork → change → pull request → check → merge

1. Your **fork** is your private copy. Change things there as often as you like.
2. A **pull request** (PR) asks the class repository to take your changes.
3. The **checker** (a GitHub Action) runs on every PR: Digital tests, Verilog test bench,
   program tests on the simulator, and dossier completeness.
4. When everything you handed in passes, the PR is **merged** automatically. Your block
   then becomes part of the class computer, and the class board updates.

Keep your fork up to date: on your fork's page click **Sync fork → Update branch** before
starting new work.

## Commit messages

Write what changed, starting with your package number:

```
P17: Digital circuit for the field splitter
P17: Verilog module passes all tests
P17: dossier U1-U3
```

## Reviews (E2)

Each package has two review partners (named in its README). Review their PRs:

* Look at **Files changed**. Click a line to comment on it.
* Be specific and kind: "Row 12 of the truth table looks wrong: should `sel` be 3 here?"
  is useful; "looks good" is not a review.
* Reviews do not block the merge; they are part of your marks and of the learning.

## Issues

* Your join issue is your notebook. Write progress notes and questions there.
* Found a problem in someone else's block (e.g. your program misbehaves because of it)?
  Open an issue, mention the package (`P42`) and its owner, and describe how to reproduce it.
* Found a mistake in the task, tests or tools? Open an issue and mention the teacher.

## Integrity

You may discuss ideas with anyone. The circuit, Verilog, program and dossier you hand in
must be your own work: the viva checks that you can explain every part of it.
