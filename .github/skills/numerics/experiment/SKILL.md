---
name: experiment
description: Track a numerical investigation and orchestrate its phases as nested sessions in the session tree.
disable-model-invocation: true
---

# Experiment

Orchestrator over the `experiment-*` skills for iterative numerical investigations: hypothesis, run, evaluation, repeated. It reads the investigation's files, reports status, and spawns each phase as a **nested session** in the current session tree via `create_session`. It edits no repository files itself; every phase runs in its own child session.

Before describing what a skill does, read its `SKILL.md`. Shared rules for all phases: [CONVENTIONS.md](CONVENTIONS.md).

## Steps

1. **Inspect state.** Locate the investigation repo (the path the user gives, else the current directory). If `CONSTRAINTS.md` or `STATE.md` is missing, the next step is `init`. Otherwise read the status block of the highest-numbered `iterations/NN_*/LOG.md` and `plan.yaml`, cross-checked against the files with the **Phase table** (when block and files disagree, trust the files and report the mismatch). Call `get_current_session` to inspect existing nested sessions in `chats` (and `list_sessions` / `get_session_context` when a child's status or verdict—such as `review-spec`—decides the next step).
   _Done when_ you know the phase from disk, any open child session for it, and the next step or stop condition.

2. **Report status** in at most ten lines: iteration and topic, phase, blockers (missing approval, running cases with progress from `plan.yaml`, failed cases), any open nested session for the current phase (as a clickable `openLink`), the next step with a one-line reason, and any detour that applies.

3. **Confirm before spawning.** When `create_session` is unavailable, end after step 2 and recommend the slash command in a fresh session. Otherwise ask with `ask_user` before calling `create_session`:
   - If an active or idle nested session already exists for the current phase, ask whether to continue there or spawn a fresh one.
   - Otherwise confirm spawning the next phase session and the advancement mode: **spawn and auto-advance** (default: automatically spawn subsequent unblocked phases as each finishes up to the next stop condition), **spawn this phase only**, or **status only**.

4. **Spawn the nested session.** Call `create_session` with default `relationship` (`currentSession`) following **Session setup**. Reply with the spawned session's clickable `openLink` and end the turn.

5. **Advance on completion.** When a nested session finishes and wakes this session (or the user returns to advance), re-run step 1 from disk and inspect the finished child's outcome via `get_session_context`.
   - In **auto-advance** mode, if the child completed cleanly, the files advanced to an **unblocked** next step, and no stop condition or detour holds, spawn the next session directly with step 4.
   - At any **stop condition** (approval gate, iteration boundary, running/failed cases, validity-gate failure, blocking `review-spec` findings, detour, child error/stall) or in single-step mode, report status with the relevant `openLink` and wait for the user.

## Phase table

| The files show | Phase | Next skill | Workspace | Auto-advance |
|---|---|---|---|---|
| `CONSTRAINTS.md` or `STATE.md` missing | init | `experiment-init` | investigation | **stop** (confirm setup) |
| No iteration, or latest has `closed` | none open | `experiment-frame` (top of `STATE.md` Next) | investigation | **stop** (iteration boundary) |
| Frame section, no `frame_approved` | frame | continue open `frame` session | investigation | **stop** (awaiting approval) |
| `frame_approved`, Design empty | design | `experiment-design` | investigation | unblocked |
| Design section, no `design_approved` | design | continue open `design` session | investigation | **stop** (awaiting approval) |
| `design_approved`, `SPEC.md`, no solver commit with trailer, no passing `review-spec` session yet | implement | `review-spec` | solver | unblocked |
| `design_approved`, `SPEC.md`, `review-spec` ready, no solver commit with trailer | implement | `implement` | solver | unblocked (**stop** on blocking findings) |
| Solver commits with trailer (`solver_commits` empty), or `design_approved` without `SPEC.md`, or cases planned | run | `experiment-run` | investigation | unblocked |
| Cases launched/running or failed | run | `experiment-run` (status or relaunch) | investigation | **stop** (wait for runs or fix failures) |
| All cases finished cleanly, Results empty | analyse | `experiment-analyse` | investigation | unblocked |
| Results written, validity gate passed, `review.md` missing | review | `experiment-review` | investigation | unblocked (pauses in child for dispositions) |
| `review.md` has findings without a disposition | review | continue open `review` session | investigation | **stop** (awaiting dispositions) |
| All findings have dispositions, `closed` empty | close | `experiment-close` | investigation | unblocked |

## Session setup

- **Title:** `init`, or `NN · <step>` (e.g. `03 · frame`, `03 · review-spec`, `03 · implement`, `03 · run`).
- **Workspace:** omit when this session is already in the investigation repo; otherwise pass the investigation repo's absolute path with `worktree: false`. For `review-spec` and `implement`, pass the solver repo's absolute path from `CONSTRAINTS.md` (`Solver → Repo`) with `worktree: false` so work runs directly on the experiment branch.
- **Prompt:** keep it pointer-based and self-contained:
  1. Absolute path to the target skill's `SKILL.md` (resolved from this skill's directory: `../experiment-<phase>/SKILL.md`, or `../../engineering/<skill>/SKILL.md`—falling back to `../<skill>/SKILL.md` in flattened installs), instructing the child to read and follow it completely.
  2. Absolute paths to the investigation repo and current `iterations/NN_<topic>/` folder (plus `SPEC.md` and `CONSTRAINTS.md` for solver sessions), and any user argument passed to `/experiment`.
  3. For `implement`: state the `SPEC.md` deliverables (commit trailer, frozen build, `SMOKE.md` next to `SPEC.md`).

## Detours

Any detour is a **stop condition** for auto-advance; report it and confirm the branch before spawning:

- **The desk check answers the question:** from frame straight to `experiment-close`, no runs.
- **The validity gate fails** (null case wrong, control misses baseline): back to `experiment-design` in the same iteration.
- **Failed runs:** `experiment-run` to diagnose and relaunch before analysing.
- **The review overturns a mechanism:** close this iteration with the correction; open the next iteration for the new hypothesis.
- **A question asked in passing:** answer it explain-only in this session; the phase stays.

## The flow

Orientation only; each skill's `SKILL.md` is authoritative.

- Once per investigation: **`experiment-init`** sets up the investigation repo (`CONSTRAINTS.md`, `STATE.md`, `TESTBEDS.md`, `METRICS.md`). Expects the domain model (`GLOSSARY.md`) to exist.
- Per iteration (`iterations/NN_<topic>/`):
  1. **`experiment-frame`** — question, decision, desk-checked hypotheses, predictions. Gate: user approves.
  2. **`experiment-design`** — test beds, controls, fixed acceptance criteria, null cases, `SPEC.md` if solver changes. Gate: user approves.
  3. **Implement** (only with `SPEC.md`, in solver repo) — **`review-spec`** on `SPEC.md`, then **`implement`** (ending with `code-review`).
  4. **`experiment-run`** — records solver commit and frozen build, launches cases detached, keeps provenance in `plan.yaml`, reports status.
  5. **`experiment-analyse`** — validity gate, then verdicts against predictions.
  6. **`experiment-review`** — independent reviewer recomputes and challenges results. Gate: user decides dispositions.
  7. **`experiment-close`** — conclusions, `STATE.md`, registries, iteration frozen.
