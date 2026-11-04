#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd -P)"
SKILLS_DIR="$REPO_ROOT/.github/skills"
COPILOT_DIR="${COPILOT_DIR:-$HOME/.copilot}"
LINK_PATH="$COPILOT_DIR/skills"

if [[ ! -d "$SKILLS_DIR" ]]; then
  printf 'Skills directory not found: %s\n' "$SKILLS_DIR" >&2
  exit 1
fi

mkdir -p "$COPILOT_DIR"

if [[ -e "$LINK_PATH" || -L "$LINK_PATH" ]]; then
  if [[ -d "$LINK_PATH" ]] && [[ "$(cd -- "$LINK_PATH" && pwd -P)" == "$SKILLS_DIR" ]]; then
    printf 'Skills are already linked: %s -> %s\n' "$LINK_PATH" "$SKILLS_DIR"
    exit 0
  fi

  printf 'Cannot install skills: destination already exists: %s\n' "$LINK_PATH" >&2
  printf 'Move or merge that directory yourself, then run this script again.\n' >&2
  exit 1
fi

ln -s "$SKILLS_DIR" "$LINK_PATH"
printf 'Linked skills: %s -> %s\n' "$LINK_PATH" "$SKILLS_DIR"