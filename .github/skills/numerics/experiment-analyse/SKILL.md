---
name: experiment-analyse
description: Judge an iteration's hypotheses against its predictions, behind a validity gate.
disable-model-invocation: true
---

# Experiment analyse

Judges the hypotheses against the predictions and acceptance criteria fixed in the design. Every claim is a **ledger** entry with an evidence level.

Read [CONVENTIONS.md](../experiment/CONVENTIONS.md) first.

## Steps

1. **Load.** Read the Frame and Design sections of `LOG.md` and `plan.yaml`. List the predictions and acceptance criteria to judge.

2. **Validity gate.** Before interpreting any metric, give each item a one-line verdict with evidence:
   - **Completion**: each case reached `planned_end`; truncated cases are compared over the common window only.
   - **Provenance**: commit, build and config hash match `plan.yaml`.
   - **Comparability**: the compared cases share metric definition, window, normalisation and region.
   - **Diagnostics**: every null case gives its known answer.
   - **Controls**: every control reproduces its baseline within the noise band.
   - **Noise band**: from replicates or temporal variability, stated per metric.
   _Done when_ every item has a verdict. A failed item becomes finding #1, and results resting on it stay unjudged; when it invalidates the design, recommend `/experiment-design`.

3. **Compute.** Each analysis is a script in `scripts/` that reuses `tools/` and the `METRICS.md` definitions and writes a table to `tables/`; figures read the tables. Quote numbers from tables only.
   _Done when_ every acceptance criterion has its number in a table.

4. **Verdicts.** Apply each hypothesis's acceptance criteria: supported, refuted or inconclusive, with the ledger entry and an evidence level. List what no prediction covered as **unexplained observations**, described, with no mechanism attached.
   _Done when_ every hypothesis has a verdict that cites a table.

5. **Write Results** in `LOG.md`: bottom line, validity verdicts, one table per question, verdicts, unexplained observations, proposed changes to `STATE.md` (applied later by `/experiment-close`). Re-run the quoted numbers and correct mismatches. Set phase `review`.
   _Done when_ the log's numbers match the tables and every link resolves.

6. **Discuss** the results with the user, explain-only, and recommend `/experiment-review`.

## Working rules

- Run scripts with the interpreter and environment from `CONSTRAINTS.md`.
- Analysis scripts are disposable evidence: keep them runnable; skip linting and unit tests.
- Read large outputs lazily and subsample in time; outputs stay in the data root.
