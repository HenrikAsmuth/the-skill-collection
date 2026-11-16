---
name: experiment-frame
description: Open an iteration of a numerical investigation with hypotheses checked against the code and predictions.
argument-hint: "The question, or the STATE.md Next item to work on"
disable-model-invocation: true
---

# Experiment frame

Opens iteration NN. The deliverable is the Frame section of `LOG.md`: a question tied to a decision, 1–3 hypotheses whose mechanisms survived a **desk check** against the solver code and algorithm, and **predictions** that tell them apart. This phase reads code and existing data; runs wait for the design.

Read [CONVENTIONS.md](../experiment/CONVENTIONS.md) first.

## Steps

1. **Load the state.** Read `CONSTRAINTS.md`, `STATE.md` and `GLOSSARY.md`; read earlier logs only where `STATE.md` links them for the item at hand.
   _Done when_ you can restate the established findings, the leading hypotheses and the Next list in ten lines.

2. **Pin the question.** Take it from the user's argument, else the top of `STATE.md` Next. State the decision it feeds: "if …, we …; otherwise …". Create `iterations/NN_<topic>/` with `LOG.md` and `plan.yaml` from the [templates](../experiment/templates/) (phase `frame`).
   _Done when_ the question names concrete quantities and the decision has two branches.

3. **Hypotheses.** Write each as a causal chain in solver terms: which operator, step or term, acting on which nodes, cells or fields, produces the observed effect. Add the competing explanation the same data would fit, and what `STATE.md` already says about each.
   _Done when_ every link of every chain names a concrete element of the code or the algorithm.

4. **Desk check.** Verify each link against the solver code and the algorithm: the code does what the link requires, in that order, on those entities. Cite file:line.
   - A link that is a suspected defect provable from the code gets settled here; use the diagnosing-bugs skill for a tight check.
   - A link resting on an external claim gets verified against the primary source with the research skill, or marked unverified.
   - A chain the code contradicts is rewritten or dropped, with the reason in `LOG.md`.
   - When the desk check answers the question, say so and recommend `/experiment-close`.
   _Done when_ every link carries a citation, a verified source, or "unverifiable without a run".

5. **Predictions.** For each hypothesis, predictions on metrics from `METRICS.md`: the outcome if true, the outcome if false, and its size against the known noise band. Mirror them into `plan.yaml`.
   _Done when_ each hypothesis has a prediction that would refute it, and every pair of hypotheses differs in at least one prediction.

6. **Approval.** Present the Frame, bottom line first. When the user wants it stress-tested, run the grilling skill on it. On approval set `frame_approved` and phase `design`, and recommend `/experiment-design`.
