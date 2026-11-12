---
name: analyze-runs
description: "Analyse finished training runs and propose evidence-backed next experiments."
disable-model-invocation: true
---

You are analysing finished training runs to decide **what to train next**. The deliverable is a short, ranked set of next experiments, each backed by a number you computed in this session. Every claim is a **ledger** entry: number, denominator, script that produced it.

## Steps

1. **Pin the question.** Restate in one or two lines: the runs or study, the exact comparison(s) (named outputs, cases, splits; "metric X on output A vs output B", not a family name), and the decision the analysis feeds. Settle the output folder now, next to the study's results: `analysis/` with `scripts/`, `tables/`, `figures/`, and the report. Ask the user (`ask_user`, one form) only when the comparison or decision has two plausible readings, or the results location or experiment log is unknown.
   _Done when_ the comparison names concrete outputs/cases/splits and the output folder exists.

2. **Ask for prior findings.** Ask for the project's experiment log (training log, study notes) if it isn't provided and whether it should be incorporated. If it is provided, grep its headings, then read only the entries for this study and its predecessor. List the open hypotheses and any entries that invalidate earlier results (data fixes, target redefinitions, pipeline bugs).
   _Done when_ you can name which earlier findings still hold and which are void.

3. **Validity gate.** Before interpreting any metric, establish that the numbers mean what they claim. Each item gets a one-line verdict with evidence:
   - **Target**: trace how the target is derived from the raw data, and check its distribution (class balance, value range, moments) against the data contract. Look for parts that are identical by construction (one source value copied onto several outputs), inherited by derived outputs, or fixed by deterministic rules (thresholds, clipping, fill values) that are trivially predictable and inflate metrics.
   - **Comparability**: same evaluation rows, same scored outputs, same metric path across the cases you compare. A split defined by fixed ids can still gain rows between data versions. Pooled metrics over different outputs or row sets are not comparisons; restrict to the shared subset or report per output.
   - **Path parity**: when a second scoring path exists (deployment inference, export, re-validation), score both on identical rows. A gap means train/serve skew, and that path's metrics are void until it is explained.
   - **Metric fit**: the metric reflects the decision the model serves. Aggregates hide what matters: report per output, check how the loss shapes the prediction distribution (weighted or robust losses shift scores and bias), and prefer metrics that don't hinge on an arbitrary cut-off or scale (per-output thresholds or threshold-free scores; normalised errors, bias and error quantiles).
   - **Noise band**: spread across seeds, for best and smoothed metrics, and per group for small groups. Use smoothed or late-epoch-mean metrics; a single best epoch selects noise.
   _Done when_ every item has a verdict. A failed item becomes finding #1; continue only on what survives.

4. **Stratify.** Break performance down by the axes that plausibly drive it: data owner or source, site/group, output, how and at what granularity the target was produced, target magnitude (rare or extreme values), extent of the pattern, operating regime, availability of context inputs, and whether a feature is measured or derived. Before attributing an effect to one axis, check it within strata of the others (a per-source effect may be a per-output rule). Keep each analysis a script in `scripts/` that writes a table; quote numbers from those tables only.
   _Done when_ each candidate explanation has a stratified number with its denominator, and each **confound** you can name has been checked or listed as unchecked, including metadata too sparse to stratify on.

5. **Propose next experiments.** Rank by expected gain over cost. Each proposal states:
   - the hypothesis and the ledger entry supporting it;
   - the single change versus the reference config;
   - the expected effect relative to the noise band, and the result that would change your mind;
   - implementation effort required.
   - expected wall-clock time to completion.
   Drop arms whose plausible effect sits inside the noise band unless seeds are added. When the gap is generalisation to held-out groups, weigh new groups above more rows from known groups. Flag proposals that need code changes.
   _Done when_ every proposal has all five fields.

6. **Report and log.** Write the report in `analysis/`: findings first (most decision-relevant at the top), then validity verdicts, stratified evidence with figures, proposals. Re-run the numbers you quote and correct mismatches. Append a dated entry to the experiment log in its existing style: key findings, decisions, link to the report.
   _Done when_ the report's numbers match the tables, links resolve, and the log entry exists.

## Working rules

- Run analysis scripts with the project's environment (e.g. `uv run --project <repo> python`), not the system interpreter.
- Analysis scripts are disposable evidence: keep them runnable and in `scripts/`; skip linting and unit tests for them.
- Use `multiprocessing.get_context("spawn")` for pools that touch zarr, dask, polars or other threaded libraries; `fork` deadlocks.
- Delegate only bounded side tasks (code walkthrough, raw-data census) to subagents, and hand them the verified facts they need so they skip rediscovery.
- Name things as precisely as the data identifies them ("export record", not "physical device"; "candidate share", not a validated error rate, unless checked against ground truth).
