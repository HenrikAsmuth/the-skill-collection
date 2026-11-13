#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: install-skills.sh [--claude]

Without options, links ~/.copilot/skills to this repository's .github/skills
(override the parent directory with COPILOT_DIR).

--claude  Install for Claude Code instead: links every skill individually into
          ~/.claude/skills/<skill-name>, because Claude Code only discovers
          skills one level deep. Override the parent directory with CLAUDE_DIR,
          e.g. CLAUDE_DIR=/path/to/project/.claude to install for one project.
EOF
}

TARGET=copilot
for arg in "$@"; do
  case "$arg" in
    --claude) TARGET=claude ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n\n' "$arg" >&2
      usage >&2
      exit 1
      ;;
  esac
done

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd -P)"
SKILLS_DIR="$REPO_ROOT/.github/skills"

if [[ ! -d "$SKILLS_DIR" ]]; then
  printf 'Skills directory not found: %s\n' "$SKILLS_DIR" >&2
  exit 1
fi

install_copilot() {
  local copilot_dir="${COPILOT_DIR:-$HOME/.copilot}"
  local link_path="$copilot_dir/skills"

  mkdir -p "$copilot_dir"

  if [[ -e "$link_path" || -L "$link_path" ]]; then
    if [[ -d "$link_path" ]] && [[ "$(cd -- "$link_path" && pwd -P)" == "$SKILLS_DIR" ]]; then
      printf 'Skills are already linked: %s -> %s\n' "$link_path" "$SKILLS_DIR"
      exit 0
    fi

    printf 'Cannot install skills: destination already exists: %s\n' "$link_path" >&2
    printf 'Move or merge that directory yourself, then run this script again.\n' >&2
    exit 1
  fi

  ln -s "$SKILLS_DIR" "$link_path"
  printf 'Linked skills: %s -> %s\n' "$link_path" "$SKILLS_DIR"
}

# Claude Code looks for <skills-dir>/<name>/SKILL.md, so the category folders
# (engineering/, productivity/, ...) are flattened into one link per skill.
install_claude() {
  local claude_dir="${CLAUDE_DIR:-$HOME/.claude}"
  local dest_dir="$claude_dir/skills"
  local linked=0 present=0 conflicts=0
  local -A seen=()

  mkdir -p "$dest_dir"

  local skill_file skill_dir name link_path
  while IFS= read -r skill_file; do
    skill_dir="$(dirname -- "$skill_file")"
    name="$(basename -- "$skill_dir")"
    link_path="$dest_dir/$name"

    if [[ -n "${seen[$name]:-}" ]]; then
      printf 'Conflict: skill name "%s" is used by both %s and %s\n' \
        "$name" "${seen[$name]}" "$skill_dir" >&2
      conflicts=$((conflicts + 1))
      continue
    fi
    seen[$name]="$skill_dir"

    if [[ -e "$link_path" || -L "$link_path" ]]; then
      if [[ -d "$link_path" ]] && [[ "$(cd -- "$link_path" && pwd -P)" == "$skill_dir" ]]; then
        present=$((present + 1))
        continue
      fi
      printf 'Conflict: destination already exists: %s\n' "$link_path" >&2
      conflicts=$((conflicts + 1))
      continue
    fi

    ln -s "$skill_dir" "$link_path"
    printf 'Linked skill: %s -> %s\n' "$link_path" "$skill_dir"
    linked=$((linked + 1))
  done < <(find "$SKILLS_DIR" -mindepth 2 -name SKILL.md -type f | sort)

  printf 'Claude skills in %s: %d linked, %d already linked, %d conflicts.\n' \
    "$dest_dir" "$linked" "$present" "$conflicts"

  if ((conflicts > 0)); then
    printf 'Move, rename or merge the conflicting entries yourself, then run this script again.\n' >&2
    exit 1
  fi
}

if [[ "$TARGET" == claude ]]; then
  install_claude
else
  install_copilot
fi
