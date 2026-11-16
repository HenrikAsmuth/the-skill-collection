# Spec: <change> (iteration NN)

Self-contained: an implementer needs only this file, the solver repo and `CONSTRAINTS.md` (path: <investigation repo>/CONSTRAINTS.md).

## Goal

<What the change lets the iteration test, and which predictions depend on it.>

## Scope

- Repo, base commit, branch to create:
- Files and modules owned by this change:
- Out of scope:

## Behaviour

<Each switch or config key: name, values, default. The default reproduces the base build bitwise.>

## Diagnostics

<New output: quantity, sign convention, units, where and how often it is written, exact format.>

## Tests

- Unit tests at these seams:
- Smoke tests, each with its expected number and pass criterion:
  - switch at default: bitwise identical to the base build on <case>;
  - null case per new diagnostic: <case>, expected <value>;
  - <functional test>.
- Resources for tests: <per CONSTRAINTS.md>.

## Build

<Build command, frozen build path pattern `<...>_<shortsha>`, per CONSTRAINTS.md.>

## Deliverables

- One commit on the branch with the trailer `Investigation: <investigation name>/<NN>`.
- Frozen build at <path>.
- `SMOKE.md` next to this spec: the smoke-test table with numbers and pass/fail.
