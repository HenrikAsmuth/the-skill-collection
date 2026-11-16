---
iteration: NN
topic: <topic>
phase: frame
opened: YYYY-MM-DD
frame_approved:
design_approved:
solver_commits: []
closed:
---

# Iteration NN: <topic>

State at start: [STATE.md](../../STATE.md) as of YYYY-MM-DD.

## Bottom line

_Written at close._

## 1. Frame

### Question and decision

<The question in concrete quantities. The decision it feeds: if …, we …; otherwise …>

### Hypotheses

| ID | Mechanism (causal chain in solver terms) | Desk check (file:line, source, or "unverifiable without a run") |
|---|---|---|

Dropped or rewritten after the desk check: <hypothesis, reason>.

### Predictions

| ID | Hypothesis | Metric | If true | If false | Size vs noise band |
|---|---|---|---|---|---|

## 2. Design

### Test beds

<Per prediction: test bed, proxy validity (link) or bridge case.>

### Cases

<Summary table; the registry is plan.yaml.>

### Acceptance criteria (fixed before the runs)

| Hypothesis | Supported if | Refuted if | Metric, window |
|---|---|---|---|

### Diagnostics validation

<Null case per new or unvalidated metric, with its known answer.>

### Solver changes

<SPEC.md, or "none".>

### Budget

<Wall time and resources per case and in total.>

## 3. Results

### Bottom line

### Validity

| Check | Verdict | Evidence |
|---|---|---|

### <One subsection per question, one table each>

### Verdicts

| Hypothesis | Verdict | Evidence level | Ledger (table, window) |
|---|---|---|---|

### Unexplained observations

### Proposed changes to STATE.md

## 4. Review

[review.md](review.md). Accepted findings and what they changed.

## 5. Conclusions
