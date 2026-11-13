---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

If the user passes a ticket reference, fetch it from the issue tracker and state its title before starting. If the reference is ambiguous, ask.

Before the first test run, find the runner's partial-run commands and the full suite's expected duration from repository guidance or recent CI results. If the duration is unknown, say so; learn timings from necessary runs rather than launching the full suite just to measure it.

Call the Skill tool with "tdd" where possible, at pre-agreed seams. Typecheck after each coherent edit, using the smallest supported scope covering the change.

Once done, call the Skill tool with "code-review" to review the work and fix its findings.

Then run the full suite at least once on the final revision as the **gate**, regardless of its duration. If it fails, re-run only the failing tests and affected regressions while fixing them, then repeat the full gate on the repaired revision. Use duration estimates to plan the run, not to skip it. Honor repository-required checks and explicit user instructions. If missing infrastructure or another execution limit prevents completion, report the gate as blocked and identify what is needed; scoped tests are not a substitute.

Report the commands run, their scope, outcomes, and observed durations, plus checks not run. A passing gate covers only the revision tested; further changes need validation of their affected scope.

Commit your work to the current branch.
