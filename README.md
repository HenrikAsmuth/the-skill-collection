# The Skill Collection

Reusable agent skills for GitHub Copilot in VS Code. Each skill lives in its own directory under `.github/skills/` and contains a `SKILL.md` file. Supporting references and scripts can live alongside it.

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