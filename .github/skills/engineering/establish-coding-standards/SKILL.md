---
name: establish-coding-standards
description: "Establish repo-wide coding standards for an existing codebase. Use when reconciling inconsistent conventions across packages or repositories, auditing competing styles, or grilling the user to agree on a coding standard and incremental adoption plan."
---

# Establish Coding Standards

Turn an existing repository's competing conventions into an explicitly agreed standard. Discover the facts yourself; grill the user on the decisions. Existing practice is evidence, not automatic endorsement.

## 1. Build the Evidence

Start read-only. Read repository instructions, contribution and standards documents, formatter/linter/typechecker configuration, build scripts, and CI. Identify nested overrides, language boundaries, and which checks actually run. Treat conflicting documented rules as findings, not permission to silently choose one.

- **Ownership:** Establish which code this repository owns. Separately published workspace members carry their own compatibility contracts. Submodules, git-sourced dependencies, and copied code owned elsewhere stay outside the standard unless the user brings them into scope.
- **Existing standards:** Treat standards documents and agent instructions as prior decisions open to review, not settled rules. Audit each against tool configuration and sampled code; record rules that are stale, unenforced, or contradicted. Instructions that discourage exploration are evidence for this task, not limits on it.
- **Checks:** Determine what runs from CI, hooks, and scripts. Label a check configured but unverified when none of them runs it, or when you cannot execute it. Run a check only in non-mutating mode (no fix or write flags), and note that it may still write caches.

Sample representative production code and nearby tests from each materially different package or subsystem. Include maintained code and legacy areas where distinguishable; exclude generated, vendored, and third-party code from convention counts. State the sampling coverage and gaps. Expand the sample when a candidate rule has conflicting evidence; never present sample counts as repository-wide statistics.

Look for differences in naming, formatting, imports, module organization, public interfaces, types, error handling, logging, testing, dependency usage, and documentation. Investigate only categories relevant to this repository. Separate stylistic preferences from correctness, compatibility, security, and architectural constraints. Report incidental bugs in a separate list; they are not standards decisions.

Present a compact **convention map**:

| Topic | Observed variants and code references | Scope and existing authority | Conflict or cost | Open question |
| --- | --- | --- | --- | --- |

Below the map, show short contrasting snippets for each material disagreement. Every file:line reference carries the cited line quoted verbatim from your read; a reference you cannot quote is unverified, so re-read or drop it. Verify absence claims such as "unused dependency" by search. Label each observation as documented, tool-enforced, configured but unverified, repeated in the sample, or isolated. Note unknown intent rather than inventing a historical rationale. If evidence supports one convention, say so; do not manufacture a conflict.

**Complete when:** every owned language/subsystem is sampled or listed as a gap, and each material conflict has traceable examples. Present the map before asking the user to select standards.

**Multiple repositories:** Build a separate map per repository. Sharing a baseline is a round-1 decision, including where the shared standard lives and how each repository enforces it. Similar configuration is evidence, not consent; record repository-specific differences as scoped rules.

## 2. Grill in Decision Rounds

Map unresolved decisions and their dependencies. Round 1 covers only foundations: ownership and scope, authority of existing documents versus tool configuration, compatibility targets, and the adoption boundary. Tool choice, formatting, naming, docstrings, and other style decisions depend on these, so they start in round 2 at the earliest. A repo-wide standard can contain explicit scoped rules; it need not impose one syntax or idiom across different languages.

Ask the **frontier** each round: only decisions whose prerequisites are settled. Batch independent questions; defer dependent ones until the next round. Keep rounds manageable by taking the highest-impact independent topics first and listing remaining topics as pending. Then wait for answers.

Use the available question tool when suitable, or numbered questions in chat. For every question provide:

- The concrete conflict, with contrasting repository examples.
- Plausible alternatives, including retaining a justified scoped difference.
- Your recommendation and its maintenance, tooling, compatibility, and migration tradeoffs. Mark it **breaking** when it changes public import paths, serialized names, or supported versions.
- A precise decision the user can accept, reject, or amend. Word yes/no questions so "yes" accepts the recommendation.

Challenge vague answers such as "be consistent" with a concrete case. Stress-test a proposed rule against an existing counterexample: does it improve that code, require an exception, or suggest the rule is wrong? Prefer repository examples; label any hypothetical example. Surface incompatible answers and return to the prerequisite decision instead of silently resolving them.

Look up answers in the repository or tool documentation; ask the user only about intent, priorities, and tradeoffs. If a fact is inaccessible, mark the dependent decision blocked and explain what evidence is missing. A recommendation, silence, or an unanswered question is not agreement.

Once the user answers, keep a visible **decision ledger**, updating it after each round:

| ID | Topic | Chosen rule and rationale | Scope or exception | Enforcement | Adoption | Status |
| --- | --- | --- | --- | --- | --- | --- |

Use proposed, agreed, deferred, or blocked status. Track rejected alternatives where their rationale matters. Reopen an agreed decision when later evidence contradicts its assumptions and ask the user to reconfirm it. Explicit deferral is valid, but identify its scope and consequence; never label a deferred topic standardized.

**Complete when:** every material conflict is agreed, explicitly deferred, or blocked; no dependent choice rests on an unanswered assumption. Continue rounds until this is true, or the user pauses.

## 3. Agree on Enforcement and Adoption

For each agreed rule, choose its enforcement and rollout with the user:

- **Mechanical rules:** reuse formatter, linter, compiler/typechecker, or other existing checks. Prefer configuring the current toolchain to adding another tool. Verify rule support rather than promising enforcement the tool cannot provide.
- **Judgment calls:** document the rule, rationale, scope, and concrete good/bad examples for human and agent review. Use examples from the repository where practical, and label proposed rewrites.
- **Legacy violations:** choose new/changed-code enforcement, package-by-package migration, or a separately approved cleanup. Define what "changed code" means for the chosen check; do not promise diff-only enforcement for a tool that checks whole files or the whole repository.
- **Exceptions:** require an explicit path/language/context scope, rationale, and a review trigger or expiry when appropriate. Generated and vendored code should have explicit exclusions.

Agree on how new violations are prevented in local development and CI. Establish the existing violation baseline using read-only checks when available, distinguishing pre-existing failures from proposed-rule failures. Avoid auto-fix modes during discovery. If a proposed check cannot run without edits or installation, describe the limitation and make its verification an approved implementation task.

**Complete when:** every agreed rule has a feasible enforcement method or explicit manual review, and an agreed adoption policy that accounts for existing violations and legitimate exceptions.

## 4. Confirm Before Writing

Present the full proposed standard and adoption plan in chat. Include:

- Coverage and remaining discovery gaps.
- Agreed rules, rationales, scopes, examples, and precedence between the baseline and scoped exceptions.
- Rejected alternatives worth remembering, plus deferred or blocked decisions.
- Enforcement changes, existing violations, migration stages, and validation commands.
- The exact documentation and configuration files you propose to create or update.

Ask for explicit approval of the standard and the proposed edits. Discovery and discussion authorize no repository changes: write documentation, change tooling, install dependencies, or migrate code only after approval for those actions. Approval of a standard alone does not authorize mass reformatting or refactoring. If the user wants discussion only, finish with the agreed proposal and leave files unchanged.

Prefer the repository's existing standards document. Otherwise propose `CODING_STANDARDS.md` for judgment-based rules and links to authoritative tool configuration; avoid duplicating every formatter setting in prose. Propose only a short navigation pointer in existing contributor/agent instructions where necessary. Resolve contradictory authoritative documentation as part of the approved edit list.

## 5. Implement Only the Approved Scope

Apply approved documentation and enforcement changes without unrelated cleanup. Keep legacy migration separate unless explicitly included. Validate each touched configuration with its own tool and run the relevant repository checks. Compare failures with the baseline; report remaining violations and unavailable checks honestly.

Check that every agreed rule is represented by documentation or enforcement, every exception has an explicit scope, and deferred decisions are visible. Summarize the agreed standard, changed files, validation results, and remaining adoption work. Where available, `code-review` can consume the standards document to review future changes, and `retro` can propose later refinements; neither is required to run this skill.