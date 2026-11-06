---
name: review-spec
description: "Review a specification or design document written by a previous agent for clarity, soundness, and implementation readiness. Return one prioritized report without editing the spec or running a remediation loop."
disable-model-invocation: true
---

# Review a spec

Assess whether another agent could implement the spec without inventing consequential requirements or design decisions. Review the artifact on its merits, treating the previous agent's conclusions as claims to verify.

Run one review in the current context and deliver one report. Keep the spec and code unchanged; fixes, implementation, and another review require a separate request. This is a standalone review, not a fresh-context Goldfish review or an EGM pipeline.

## 1. Identify the target

Use the spec the user names: a file, an issue, or text in the conversation. If no target is named,ask for the target and stop.

Read the complete spec, including any implementation plan. Record its source and version when available. Identify the intended outcome, scope boundaries, constraints, and acceptance criteria.

## 2. Test comprehension before filling gaps

From the spec alone, write a brief account of who needs what, the proposed behavior, and how success will be demonstrated.

Identify contradictions, undefined terms, missing behavior, and decisions that admit materially different implementations. Prior conversation can explain the author's intent, but cannot repair an omission in a handoff document. Distinguish an explicit decision from an inference.

Complete this step when you can either explain the intended behavior unambiguously or name the gaps that prevent it.

## 3. Check the design against evidence

Read the original request or issue, relevant linked material, and the repository's applicable conventions, glossary, and architecture decisions when available. Inspect only the code, interfaces, schemas, and tests needed to check the spec's concrete claims. Record unavailable evidence as a limitation rather than assuming it agrees.

Apply every lens below, marking genuinely inapplicable lenses as such:

| Lens | Review questions |
|---|---|
| Problem fit | Does the proposal solve the user's actual problem? Are success criteria observable? Does it respect explicit constraints and exclusions? |
| Comprehension | Can an implementer understand the document without the author's conversation? Are terms, examples, requirements, and sections consistent? |
| Design soundness | Are responsibilities, interfaces, dependencies, and data ownership coherent? Do repository facts support the proposed approach? Would a simpler existing mechanism meet the same requirements? |
| Behavioral completeness | Are important edge cases, failure paths, state transitions, compatibility, and relevant security or privacy requirements specified? |
| Verification | Can each acceptance criterion be tested through observable behavior? Are expected outcomes and relevant regression checks clear? |
| Delivery readiness | Are consequential decisions settled? Where relevant, are migration, rollout, rollback, and operational needs addressed? If an implementation plan exists, does it cover the requirements in a feasible dependency order? |

Review detail in proportion to the feature's risk. A feature spec need not contain a detailed implementation plan, file paths, or code snippets; flag only missing information that would force consequential guessing. Suggest alternatives only when they resolve a concrete problem.

Complete this step when every lens and explicit acceptance criterion has been checked or has a stated evidence limitation.

## 4. Deliver one report

Consolidate duplicate observations by root cause. Include only actionable findings supported by the spec, the original requirements, or inspected evidence. Separate confirmed defects from unresolved questions; do not turn an unverified assumption into a fact.

Assign each finding a stable ID and priority:

- **Blocker**: A contradiction, infeasible requirement, or missing consequential decision prevents safe implementation.
- **Major**: A material gap or design risk is likely to cause incorrect behavior or substantial rework.
- **Minor**: A localized clarity or consistency issue has a straightforward resolution.

Use this output structure:

### Verdict

Choose **Ready**, **Needs revision**, or **Cannot assess**. Ready means no Blocker or Major findings and sufficient evidence to assess the consequential claims. Use Cannot assess when missing target content or essential baseline evidence prevents a meaningful readiness judgment. Otherwise use Needs revision. State the reason in one sentence.

### Understanding

Summarize the intended behavior in a few sentences, then identify the reviewed source and context consulted.

### Findings

List findings in priority order. For each, provide:

- ID, priority, and a concise title.
- A precise location: file and line, issue section, or short quote from conversation text.
- The evidence and the concrete implementation consequence.
- The smallest recommended spec change, or the decision question needed to resolve it.

If there are no actionable findings, say so explicitly.

### Coverage and limitations

Briefly account for all six lenses and the acceptance criteria, including any not applicable or unverified. List unresolved questions and unavailable evidence that could change the verdict. Do not claim validation beyond what was inspected.

Return the report in chat unless the user requests a saved report. Stop after delivery; do not launch remediation, implementation, or an automatic re-review.