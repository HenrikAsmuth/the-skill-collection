# The Skill Collection

Reusable agent skills for GitHub Copilot in VS Code. Each skill lives in its own directory under `.github/skills/` and contains a `SKILL.md` file. Supporting references and scripts can live alongside it.

## Spec review

Use `/review-spec` to review the latest spec written by a previous agent, or provide a spec file or issue explicitly. It checks comprehension, design soundness, behavioral completeness, and implementation readiness, then returns one prioritized report and a readiness verdict. It leaves the spec unchanged and runs no remediation or re-review loops. 
Inspired by the review concerns in Google's [EGM review workflow](https://github.com/google/elephant-goldfish-model/blob/main/skills/egm-review/SKILL.md). This skill uses its own condensed review instructions and requires no EGM installation, reviewer personas, or pipeline state.


See the [review-spec skill](.github/skills/engineering/review-spec/SKILL.md) for the full review criteria. It is standalone and requires no EGM installation.

## Install for your user

Clone this repository on each machine where you want to use the skills, then use the installer for your shell.

### Windows PowerShell

From the repository folder, run:

```powershell
.\scripts\install-skills.ps1
```

This creates a directory junction from `%USERPROFILE%\.copilot\skills\` to this repository's `.github/skills/` directory.

### Bash

If Bash is installed through Git for Windows (Git Bash) or WSL, run:

```bash
bash scripts/install-skills.sh
```

This creates a symlink from `~/.copilot/skills/` to this repository's `.github/skills/` directory. 

Both installers leave an existing destination untouched and report a conflict. If you already have personal skills at the destination, merge or move them before installing; do not replace the directory blindly. Since the destination is a link, changes pulled into this repository are immediately available. To stop using the collection, remove the link at the destination path.

Skills in `.github/skills/` are also available when you open this repository directly in VS Code. See the [VS Code Agent Skills documentation](https://code.visualstudio.com/docs/copilot/customization/agent-skills) for skill format and discovery details.