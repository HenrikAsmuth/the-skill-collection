---
name: experiment-init
description: Set up the repo of a numerical investigation for the experiment skills.
argument-hint: "Investigation name and repo path; prior logs or results to adopt"
disable-model-invocation: true
---

# Experiment init

Creates the investigation repo and records everything specific to this investigation, so the phase skills stay generic. Layout and rules: [CONVENTIONS.md](../experiment/CONVENTIONS.md). File formats: [templates/](../experiment/templates/).

## Steps

1. **Locate the repo.** Use the given path, else the current directory; `git init` if it is not a repo yet. Check the domain model: `CONTEXT.md` and `GLOSSARY.md`. When they are missing, recommend `/grill-with-docs` (or the domain-modeling skill) and stop.
   _Done when_ the repo exists and holds a glossary.

2. **Constraints.** Write `CONSTRAINTS.md` from the template. Fill what the environment answers yourself: solver repo and branches from git, resource inventory from the system's tools, interpreter and packages. Ask the user for the rest with one `ask_user` form per template section: sharing rules, detached launch, data root and size limit, build and frozen-build procedure, changes to leave untouched, hard rules.
   _Done when_ every field holds a value or an "n/a" the user confirmed.

3. **Test beds and metrics.** Write `TESTBEDS.md` and `METRICS.md` from the templates with the test beds, metrics and reference data the user and existing material name. Proxy validity and metric validation stay "not validated" until evidence is linked.
   _Done when_ every test bed has a cost and what it stands in for, and every metric a definition, units, window and script (or "script missing").

4. **Tooling.** Locate or create `tools/` for shared loaders, the case generator and metric scripts, and record the paths in `CONSTRAINTS.md`.

5. **Adopt prior material** (branch: logs or results from before the workflow exist). Move or link them into `archive/` unchanged. Seed `STATE.md` from their most recent state summary: each item gets an evidence level and a link to its source section; an item without traceable evidence is **speculative**.
   _Done when_ every `STATE.md` item links to its source.

6. **State and pointers.** Without prior material, write the Problem and Setup sections of `STATE.md` with the user and leave the rest empty. Write `AGENTS.md` from `AGENTS.template.md`; create `iterations/`.

7. **Commit** the investigation repo. Report the files created and recommend `/experiment-frame`.
