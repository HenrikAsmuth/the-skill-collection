---
name: experiment-close
description: Close an iteration of a numerical investigation and carry its results into STATE.md.
disable-model-invocation: true
---

# Experiment close

Ends the iteration: conclusions in `LOG.md`, the current picture in `STATE.md`, registries updated, the log frozen. Also the exit when the desk check in the frame already answered the question.

Read [CONVENTIONS.md](../experiment/CONVENTIONS.md) first.

## Steps

1. **Conclusions.** Write the bottom line and the Conclusions section of `LOG.md`: the final verdict and evidence level per hypothesis, what changed in the understanding, and the solver commits produced with a keep-or-drop call for each.

2. **STATE.md.** Visit every existing item against this iteration's results and keep it, update its evidence level and link, move it to Did not work (with the result and a link), park it (with its trigger) or remove it (with a one-line reason). Add the new established findings, hypotheses, Next items (question, test, effort) and Do-not-forget items. Update Solver changes in use and the Updated line.
   _Done when_ every pre-existing item has been visited and every new item links to a section of this iteration's log.

3. **Registries.** `TESTBEDS.md`: proxy-validity evidence gained. `METRICS.md`: new metrics, and validation status from the null cases. `GLOSSARY.md`: new case names, switches and concepts, through the domain-modeling skill.

4. **Freeze.** Set `closed` and phase `closed`, check every link, and commit the investigation repo as "Close iteration NN: <bottom line>".

5. **Hand over.** Report the bottom line and the top Next item; recommend a fresh session and `/experiment-frame`.
