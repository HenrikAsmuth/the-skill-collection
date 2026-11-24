# Issue tracker: Azure DevOps Boards

Issues and specs for this repo live as Azure DevOps work items. Use the Azure CLI (`az boards` / `az repos`) for all operations.

- **Organization**: `<org-url>` (e.g. `https://dev.azure.com/<org>`)
- **Project**: `<project>`
- **Board hierarchy** (Scrum process): `Epic` → `Feature` → `Product Backlog Item` (plus `Bug` and `Task`)
- **Active/terminal states**: `New`, `Approved`, `Committed`, `Done`, `Removed` _(adjust if the project uses Agile/Basic states)_
- **Labels / triage state**: stored in `System.Tags` (semicolon-separated strings; see `triage-labels.md`)

Always pass `--org <org-url>` (and `--project <project>` where applicable) so commands work regardless of local `az devops configure` defaults.

## Conventions

- **Create a work item**: `az boards work-item create --org <org-url> --project <project> --type "Product Backlog Item" --title "..." --description "..."`. Use `Epic`, `Feature`, `Product Backlog Item`, `Bug`, or `Task` as appropriate.
- **Read a work item**: `az boards work-item show --org <org-url> --id <id> --output json`.
- **List / query work items**: `az boards query --org <org-url> --project <project> --wiql "SELECT [System.Id], [System.Title], [System.State], [System.Tags] FROM WorkItems WHERE [System.TeamProject] = '<project>' AND [System.State] <> 'Done' AND [System.State] <> 'Removed'" --output json`. Filter tags with `AND [System.Tags] CONTAINS '<tag>'`.
- **Make a work item a child of a parent** (e.g. PBI → Feature, Feature → Epic): `az boards work-item relation add --org <org-url> --id <child-id> --relation-type parent --target-id <parent-id>`.
- **Blocking**: use native predecessor/successor links: `az boards work-item relation add --org <org-url> --id <child-id> --relation-type predecessor --target-id <blocker-id>`. Where relations aren't practical, fall back to a `Blocked by: #<id>, #<id>` line at the top of the description. A ticket is unblocked when every blocker is `Done` or `Removed`.
- **Comment on a work item**: `az boards work-item update --org <org-url> --id <id> --discussion "..."`.
- **Apply / remove tags**: `az boards work-item update --org <org-url> --id <id> --fields "System.Tags=<tag1>; <tag2>"`. Because `System.Tags` overwrites the whole field, read current tags first (`az boards work-item show --id <id> --query "fields.\"System.Tags\""`) and preserve unrelated tags. New tags are created automatically when first applied.
- **Close / complete**: post the explanation with `--discussion "..."` and set `--state Done` (or `--state Removed` for `wontfix`/cancelled items).
- **Branches & commits**: start new ticket branch names with `<id>_` (e.g. `9118_add_model_maker_toolbox`) and trail commit subject lines with `#<id>` so Azure DevOps automatically links commits to the work item.
- **Pull requests**: use `az repos pr create`, `az repos pr show --id <id>`, `az repos pr list`, etc.

Infer `<org-url>` and `<project>` from `git remote -v` (`https://<org>@dev.azure.com/<org>/<project>/_git/<repo>`).

## Pull requests as a triage surface

**PRs as a request surface: no.** _(Set to `yes` if this repo treats external PRs as feature requests; `/triage` reads this flag.)_

When set to `yes`, inspect open PRs with `az repos pr list --org <org-url> --project <project> --status active --output json` and `az repos pr show --org <org-url> --id <id>`.

## When a skill says "publish to the issue tracker"

Create the appropriate Azure DevOps work item (`Epic`, `Feature`, `Product Backlog Item`, or `Bug`), link it to its parent work item if one exists, and apply any relevant triage tag in `System.Tags`.

## When a skill says "fetch the relevant ticket"

Run `az boards work-item show --org <org-url> --id <id> --output json` (and inspect parent/child relations when context from the parent Feature or Epic is needed).

## Wayfinding operations

Used by `/wayfinder`. The **map** is a single work item (e.g. a `Feature` or `Product Backlog Item`) with **child** work items as tickets.

- **Map**: a single work item tagged `wayfinder:map` in `System.Tags`, holding the Notes / Decisions-so-far / Fog body.
- **Child ticket**: a work item linked to the map via `--relation-type parent --target-id <map-id>`, tagged `wayfinder:<type>` (`research`/`prototype`/`grilling`/`task`) in `System.Tags`. Once claimed, assign it to the driving dev.
- **Blocking**: see **Blocking** under Conventions.
- **Frontier query**: inspect the map's child relations (`az boards work-item show --id <map-id> --expand relations`), fetch each child that is not `Done`/`Removed`, drop any with an open predecessor (or open item in `Blocked by`) or an assignee (`System.AssignedTo`); first in map order wins.
- **Claim**: `az boards work-item update --org <org-url> --id <id> --assigned-to "$(az ad signed-in-user show --query userPrincipalName -o tsv)"`, the session's first write.
- **Resolve**: `az boards work-item update --org <org-url> --id <id> --discussion "<answer>" --state Done`, then append a context pointer (gist + link) to the map's Decisions-so-far.
