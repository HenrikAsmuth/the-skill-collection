---
name: experiment-review
description: Have an independent reviewer recompute and challenge an iteration's results; the user decides what changes.
disable-model-invocation: true
---

# Experiment review

A fresh reviewer checks the iteration's results and the user decides what changes. The reviewer gets the artifacts, never the conclusions to defend.

Read [CONVENTIONS.md](../experiment/CONVENTIONS.md) first.

## Steps

1. **Dispatch** (branch: no `review.md` yet; with an external review already in `review.md`, go to step 2). Start one subagent in a fresh context, read-only on the solver and the data, writing only `review.md` and its own scripts as `scripts/review_*`. Give it the iteration folder, `CONSTRAINTS.md`, `METRICS.md`, the path of `CONVENTIONS.md`, the solver commits, and these tasks:
   - recompute with its own code the numbers each verdict rests on, and flag differences above 10 %;
   - check the analysis scripts for errors in units, normalisation, windows and which level or region owns a value;
   - check each claim's evidence level against its evidence, and each exclusion for a test that could have shown the effect;
   - check each mechanism against the solver code;
   - name alternative hypotheses the data fit equally well, each with a discriminating test;
   - verify external claims against primary sources with the research skill, or mark them unverified.
   Each finding states severity, location, evidence and a concrete fix.
   _Done when_ `review.md` holds findings in that form.

2. **Check the review.** Recompute every finding that would change a verdict before proposing to accept it; reviewers err too.

3. **Dispositions.** Propose accept or reject with a one-line reason for each finding, and present them to the user as one list. The user decides.
   _Done when_ every finding carries the user's disposition in `review.md`.

4. **Apply** the accepted findings: re-run the affected scripts, correct the Results in `LOG.md` marked "corrected after review", and summarise the changes in the Review section. Set phase `close` and recommend `/experiment-close`.
