---
name: implement-spec
description: "Implement the result of /to-spec and /to-tickets in code."
disable-model-invocation: true
---

You have been provided a spec. This spec should have tickets associated with it, describing how to implement the spec.

The issue tracker should have been provided to you. If not, tell the user to run `/setup-matt-pocock-skills`.

The goal is the entire spec implemented on a single **integration branch**, with every ticket resolved the way the issue tracker closes work.

The tickets are not a list of steps. They are a **task graph** with blocking relationships between them. This means there is always a **frontier** of tickets which are ready to be grabbed.

Start every subagent with a fresh context window.

Communication to and from subagents should be sparse. Communicate primarily through **context pointers**: to the spec, tickets, research notes, and previous commits. Don't duplicate information already available via pointers.

**Implementer subagents** should be run in the background where possible for maximum concurrency.

## Steps

1. Read the spec and tickets to understand the task graph.

   Before dispatching implementers, find the runner's partial-run commands and the full suite's expected duration from repository guidance or recent CI results. Pass these to implementers and mergers, marking unknown timings as unknown rather than running the full suite to measure it.

2. (optional) Use an **exploration subagent** to conduct any exploration required by the tickets - relevant codebase files or external documentation. Ensure the exploration subagent can save files - it should save its markdown notes in a directory outside the repo, accessible by all future subagents. This lets **implementer subagents** focus on implementation rather than exploration.

3. Create the integration branch. If the issue tracker closes work through PRs, or the user asks for one, open a draft PR after the first merge in step 5 (a branch with no commits ahead of main can't open one), marked as closing the spec and tickets.

4. Use a fresh **implementer subagent** for each ticket, each in its own worktree on its own branch. Each implementer subagent:
   - confirms its worktree is based on the integration branch before starting, and resets onto it if not;
   - calls the Skill tool with `tdd` to build the ticket;
   - merges the integration branch tip into its own branch before reporting done;
   - validates the ticket's **blast radius** (changed behavior and affected callers) on that merged revision, then reports commands, outcomes, durations, and omitted checks. The full-suite gate belongs to the integration branch, not each implementer.

5. Once an **implementer subagent** completes, merge its work to the integration branch with a **merger subagent**. The merger validates the merged ticket's blast radius and reports commands, outcomes, durations, and omitted checks.

6. If this changes the **frontier** of available tickets, kick off more **implementer subagents** to work on the new tickets. This allows for maximum concurrency.

7. Once all tickets are complete, call the Skill tool with `code-review` on the integration branch. Fix all issues raised by the code review in a single fresh **implementer subagent**, using scoped tests while fixing them.

   After merging those fixes, run the full suite at least once on the final integration revision as the **gate**, regardless of its duration. On failure, use failing tests and affected regressions during repairs, then repeat the full gate on the repaired revision. Use duration estimates to plan the run, not to skip it. Honor repository-required checks and explicit user instructions. If missing infrastructure or another execution limit prevents completion, report the gate as blocked and identify what is needed; scoped tests are not a substitute. Report gate commands, outcomes, and durations for the final revision; subsequent changes need validation of their affected scope.

8. Once the gate passes, if a draft PR exists, mark it ready for review. Otherwise, resolve each ticket the way the issue tracker closes work, and report the integration branch. If the gate is blocked or failing, report that status instead of marking the work ready or resolved.

9. Clean up all **implementer subagent** worktrees.
