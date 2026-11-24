---
name: experiment-run
description: Launch the planned cases of an iteration with full provenance, or report their status.
disable-model-invocation: true
---

# Experiment run

Launches the planned cases and keeps `plan.yaml` as the **provenance** record. Invoked while cases run, it reports status. Interpretation belongs to `/experiment-analyse`; this phase reports progress and health only.

Read [CONVENTIONS.md](../experiment/CONVENTIONS.md) first. Requires `design_approved`. When cases are already launched, go to step 5.

## Steps

1. **Solver build** (branch: `SPEC.md` exists). Find the implementation commits by the iteration trailer and check the spec's deliverables: the frozen build exists and `SMOKE.md` reports every smoke test passed. Record the commits in `solver_commits` and the build in `plan.yaml`. A missing deliverable or failed smoke test means the implementation is unfinished: report it and stop.
   _Done when_ every case points at a frozen build with a recorded commit.

2. **Generate.** Produce the case configurations from `plan.yaml` with the case generator from `CONSTRAINTS.md`, into the data root. Diff each test case against its control.
   _Done when_ every diff shows exactly the change `plan.yaml` declares.

3. **Launch.** Check free resources with the command from `CONSTRAINTS.md`, then launch detached, in `plan.yaml` order, so the runs survive logout. Record per case: status, resource, solver commit, build, config hash, PID or job id, output, log, launch time. Set phase `run`.

4. **First-output check.** Once each case has written its first output: the process is alive, the log and first fields are free of NaN/Inf, and the first diagnostic values sit in the plausible range from `METRICS.md`. Stop or relaunch only runs you launched, by their recorded PID or job id.
   _Done when_ every case has passed or is marked failed with a log excerpt.

5. **Status.** Update each case's status in `plan.yaml`. Report progress as simulated time against `planned_end`, the estimated finish, and failures with log excerpts. When every case is finished or failed, set phase `analyse` and recommend `/experiment-analyse`.
