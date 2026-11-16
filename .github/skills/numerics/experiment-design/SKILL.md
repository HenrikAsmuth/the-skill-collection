---
name: experiment-design
description: Turn approved predictions into a run plan with controls, fixed acceptance criteria and a solver spec.
disable-model-invocation: true
---

# Experiment design

Turns the approved predictions into a run plan: the cheapest valid **test bed**, cases with **controls**, acceptance criteria fixed before any run, validated diagnostics, and `SPEC.md` when the solver must change.

Read [CONVENTIONS.md](../experiment/CONVENTIONS.md) first. Requires `frame_approved`.

## Steps

1. **Load.** Read the Frame section of `LOG.md`, `plan.yaml`, `TESTBEDS.md`, `METRICS.md` and `CONSTRAINTS.md`.

2. **Test beds.** For each prediction pick the cheapest test bed whose proxy validity for this question is validated in `TESTBEDS.md`. Where it is not, add a **bridge case**: the same configuration on the test bed and on the target, compared on the predicted metric.
   _Done when_ every prediction has a validated or bridged test bed.

3. **Cases.** Write the case registry in `plan.yaml`. Each test case changes one thing against its control and names the predictions it serves. Controls cover:
   - the baseline with the switch off, from the same build;
   - the configuration without the suspected ingredient;
   - replicates, or a variability estimate, wherever the noise band is unknown.
   Name cases with `GLOSSARY.md` terms.
   _Done when_ every prediction maps to a test case and its control, and every case states its role and the predictions it serves.

4. **Acceptance criteria.** For each hypothesis, the outcome that supports it and the outcome that refutes it: metric, window, threshold against the noise band. Write them into the Design section; once runs start they stay fixed, and any later change is recorded as a change.
   _Done when_ an analyst could give every verdict from the criteria alone.

5. **Diagnostics.** Every new or changed diagnostic gets a **null case** in the matrix: a configuration with a known answer (zero by construction, analytic solution, conservation identity, bitwise equality with the switch off). Existing metrics that a verdict depends on and that `METRICS.md` lists as not validated get one too.
   _Done when_ every metric in an acceptance criterion is validated or has a null case.

6. **Solver changes** (branch: the plan needs a change in the solver). Write `SPEC.md` from the [template](../experiment/templates/SPEC.md): scope, switches whose default reproduces the base build bitwise, diagnostics with exact output format, unit seams, smoke tests with expected numbers (including the switch-off identity and the null cases), build and frozen build per `CONSTRAINTS.md`, commit trailer, deliverables.
   _Done when_ `SPEC.md` is self-contained: an implementer needs no conversation context.

7. **Budget.** Estimate wall time and resources per case and in total against `CONSTRAINTS.md`. Order the cases so the cheapest discriminating ones finish first.

8. **Approval.** Present the design, bottom line first. On approval set `design_approved` and the phase:
   - with `SPEC.md`: phase `implement`. Hand off to the user: `/review-spec` on `SPEC.md`, then `/implement` (or `/implement-spec`) in the solver repo on the experiment branch; `/experiment-run` then records the commit.
   - without: phase `run`; recommend `/experiment-run`.
