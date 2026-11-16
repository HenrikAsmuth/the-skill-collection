# Experiment conventions

Shared reference for the `experiment-*` skills. Every phase skill reads it first. Facts specific to one investigation live in that investigation's repo, set up by `/experiment-init`; this file stays generic.

## Investigation repo layout

```
AGENTS.md            pointers for any session in this repo
CONTEXT.md, GLOSSARY.md, docs/adr/    domain model
CONSTRAINTS.md       resources, data, solver, environment, hard rules
STATE.md             the current picture; the only document rewritten across iterations
TESTBEDS.md          test beds, cost, proxy validity
METRICS.md           metric definitions, scripts, reference values, validation status
tools/               shared loaders, case generator, metric scripts
archive/             material from before the workflow, read-only
iterations/NN_<topic>/
  LOG.md             status block, then Frame, Design, Results, Review, Conclusions
  plan.yaml          predictions and the case registry
  SPEC.md            solver change spec, only when the solver changes
  review.md          independent review
  scripts/  tables/  figures/
```

`NN` is a two-digit running number. Large outputs live under the data root from `CONSTRAINTS.md`, at `<data root>/iterations/NN_<topic>/<case>/`; the repo keeps only files under the size limit there. File formats: [templates/](templates/).

## Status block

The YAML front matter of `LOG.md`. The router reads it; each phase skill updates it as its last step.

| Field | Set by |
|---|---|
| `phase`: `frame` → `design` → `implement` (only with `SPEC.md`) → `run` → `analyse` → `review` → `close` → `closed` | each phase skill on exit |
| `frame_approved`, `design_approved` (date) | frame, design, on the user's approval |
| `solver_commits` | run, after checking the implementation deliverables |
| `closed` (date) | close |

When the block and the files disagree, the files win; fix the block and say so.

## Provenance

- Every case in `plan.yaml` records solver commit, build, config hash and output path.
- Solver changes are committed in the solver repo on an experiment branch with the trailer `Investigation: <investigation name>/<NN>`, and run from a frozen build.
- Every number in a log is a **ledger** entry: the number, its window or denominator, and the script in `scripts/` or `tools/` whose table it comes from.

## Evidence levels

Tag every claim in `LOG.md` and `STATE.md` with one level:

| Level | Requires |
|---|---|
| **proven** | code reading with file:line, or an exact test: bitwise identity, analytic solution, conservation identity |
| **established** | controlled comparison whose control reproduces its baseline, effect outside the noise band, consistent across at least two cases or test beds |
| **supported** | one controlled comparison; alternatives not excluded |
| **suggested** | correlation, an uncontrolled comparison, or a single case |
| **speculative** | mechanism argument without a test |

Scope each claim to the conditions tested: "not observed in X" stays about X, and an exclusion needs a test that could have shown the effect. A metric that improved is evidence about that metric; check the others before calling a configuration correct.

## Writing for the human

- Bottom line first, in plain language.
- Each section self-contained: restate the setup in one or two sentences.
- Name cases and switches with `GLOSSARY.md` terms or in words; define each metric with units at its first use in a section, or link its `METRICS.md` entry.
- One table per question; numbers carry units and the averaging window.
- Observation and interpretation in separate sentences.
- Corrections marked in place: "corrected after review: …".

## Explain-only questions

A question asked during any phase ("why", "elaborate", "what is") gets its answer in chat. Files change once the user asks for it ("add it"); the phase and status block stay as they are.

## State discipline

- Each phase reads `STATE.md`, `CONSTRAINTS.md` and its own iteration folder, and earlier logs only through the links in `STATE.md`.
- Closed logs are frozen; new knowledge goes into the open iteration and `STATE.md`.
- `STATE.md` holds the current picture: superseded items move to "Did not work" or leave with a one-line reason and a link.

## Delegation

- Subagents read `CONSTRAINTS.md` themselves. Give them the iteration folder, a bounded task, the verified facts they need and a stop condition.
- Implementation works from `SPEC.md` alone.
- Reviewers get artifacts, never conclusions to defend.
