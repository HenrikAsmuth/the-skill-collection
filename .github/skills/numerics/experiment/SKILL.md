---
name: experiment
description: Say where a numerical investigation stands and which experiment step comes next.
disable-model-invocation: true
---

# Experiment

Router over the `experiment-*` skills for iterative numerical investigations: hypothesis, run, evaluation, repeated. It reads the investigation's files, names the current phase and recommends one next step. It changes no files and starts no skill; the user invokes the step.

Before describing what a skill does, read its SKILL.md; the summaries here are for orientation. Shared rules for all phases: [CONVENTIONS.md](CONVENTIONS.md).

## The flow

Once per investigation: **`/experiment-init`** sets up the investigation repo and records everything specific to it (resources, data, solver, test beds, metrics). It expects the domain model (glossary) to exist.

Then one **iteration** per question, each in its own `iterations/NN_<topic>/` folder:

1. **`/experiment-frame`**: the question and the decision it feeds, 1–3 hypotheses whose mechanisms pass a **desk check** against the code, and **predictions** that tell them apart. Gate: the user approves.
2. **`/experiment-design`**: test beds, cases with **controls**, acceptance criteria fixed before the runs, null cases for diagnostics, `SPEC.md` when the solver changes. Gate: the user approves.
3. **Implement**, only with `SPEC.md`, in the solver repo with the engineering skills: `/review-spec` on `SPEC.md`, then `/implement` (or `/implement-spec`), which ends with `/code-review`.
4. **`/experiment-run`**: records the solver commit and frozen build, launches the cases detached, keeps the **provenance** in `plan.yaml`, and reports status.
5. **`/experiment-analyse`**: validity gate, then verdicts against the predictions.
6. **`/experiment-review`**: an independent reviewer recomputes and checks for overreach; the user decides what changes.
7. **`/experiment-close`**: conclusions, `STATE.md`, registries, the iteration frozen.

## Steps

1. Find the investigation repo: the path the user gives, else the current directory. If `CONSTRAINTS.md` or `STATE.md` is missing, recommend `/experiment-init` and stop.
2. Read the status block of the highest-numbered `iterations/NN_*/LOG.md` and check it against the files with the table below. When block and files disagree, trust the files and report the mismatch.
3. Report in at most ten lines: iteration and topic, phase, blockers (a missing approval, running cases with progress from `plan.yaml`, failed cases), the recommended next step with a one-line reason, and any detour that applies.

| The files show | Phase | Recommend |
|---|---|---|
| No iteration, or the latest is closed | none open | `/experiment-frame`, with the top item of `STATE.md` Next |
| Frame section, no `frame_approved` | frame | finish or approve the frame |
| `frame_approved`, Design empty | design | `/experiment-design` |
| `design_approved`, `SPEC.md`, no commit with the iteration trailer in the solver repo | implement | `/review-spec` on `SPEC.md`, then `/implement` in the solver repo |
| Commits with the trailer exist but `solver_commits` is empty, or cases are planned, launched or running | run | `/experiment-run` |
| All cases finished or failed, Results empty | analyse | `/experiment-analyse` |
| Results written, `review.md` missing or findings without a disposition | review | `/experiment-review` |
| All findings have dispositions, `closed` empty | close | `/experiment-close` |

## Detours

- **The desk check answers the question**: from frame straight to `/experiment-close`, no runs.
- **The validity gate fails** (a null case gives the wrong answer, a control misses its baseline): back to `/experiment-design` in the same iteration.
- **Failed runs**: `/experiment-run` to diagnose and relaunch before analysing.
- **The review overturns a mechanism**: close this iteration with the correction; the new hypothesis opens the next one.
- **A question asked in passing**: answer it explain-only; the phase stays.

## Context

Every phase works from files, so each can start in a fresh session. Recommend a fresh session at least between iterations and after a long run phase.
