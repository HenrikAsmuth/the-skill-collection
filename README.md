# The Skill Collection

Reusable agent skills for GitHub Copilot in VS Code. Each skill lives in its own directory under `.github/skills/` and contains a `SKILL.md` file. Supporting references and scripts can live alongside it.

## Install for your user

Clone this repository on each machine where you want to use the skills, then run:

```bash
bash scripts/install-skills.sh
```

The installer links this repository's `.github/skills/` directory to `~/.copilot/skills/`, making the skills available across your VS Code workspaces. Because it is a link, changes pulled into this repository are immediately available. To stop using the collection, remove the link at `~/.copilot/skills/`.

The script leaves an existing `~/.copilot/skills/` path untouched and reports a conflict instead. If you already have personal skills there, merge or move them before installing; do not replace the directory blindly.

Skills in `.github/skills/` are also available when you open this repository directly in VS Code. See the [VS Code Agent Skills documentation](https://code.visualstudio.com/docs/copilot/customization/agent-skills) for skill format and discovery details.