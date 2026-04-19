#!/usr/bin/env bash
set -euo pipefail

echo "[roles] Validating role framework integrity"

if [ ! -f "AGENTS.md" ]; then
  echo "[roles] Missing AGENTS.md"
  exit 1
fi

if [ ! -d "agents/roles" ] || [ ! -d "agents/rules" ] || [ ! -d "agents/state-machine" ]; then
  echo "[roles] Missing agents framework directories"
  exit 1
fi

role_dirs=(agents/roles/*)
if [ ${#role_dirs[@]} -lt 10 ]; then
  echo "[roles] Expected >= 10 role directories, got ${#role_dirs[@]}"
  exit 1
fi

for dir in "${role_dirs[@]}"; do
  [ -d "$dir" ] || continue
  role_name="$(basename "$dir")"
  upper="$(printf '%s' "$role_name" | tr '[:lower:]' '[:upper:]')"

  if [ ! -f "$dir/AGENTS.${upper}.md" ]; then
    echo "[roles] Missing AGENTS file for role $role_name"
    exit 1
  fi
  if [ ! -f "$dir/ISSUE_LABELS_${upper}.yaml" ]; then
    echo "[roles] Missing labels yaml for role $role_name"
    exit 1
  fi
  if [ ! -f "$dir/ROLE_PROMPT.md" ]; then
    echo "[roles] Missing ROLE_PROMPT.md for role $role_name"
    exit 1
  fi

done

for req in   agents/rules/RULES.ISSUE_WORKFLOW.md   agents/rules/RULES.PR_WORKFLOW.md   agents/rules/RULES.CODE_DEVELOPMENT.md   agents/rules/RULES.TEST_DEVELOPMENT.md   agents/rules/RULES.DOC_DEVELOPMENT.md   agents/rules/RULES.STATE_MACHINE.md   agents/state-machine/STORY_SUBTASK_STATE_MACHINE.md   agents/state-machine/STORY_SUBTASK_STATE_MACHINE.json
  do
  if [ ! -f "$req" ]; then
    echo "[roles] Missing required framework file: $req"
    exit 1
  fi
done


for req in   agents/state-machine/ROLE_PAIRS.md   agents/state-machine/ROLLBACK_MATRIX.json   agents/state-machine/LABEL_REGISTRY.yaml   agents/WORKERS_AUTOMATION_MAP.yaml   agents/AUTOMATION_SETUP.md
  do
  if [ ! -f "$req" ]; then
    echo "[roles] Missing required automation/state file: $req"
    exit 1
  fi
done

echo "[roles] Role framework integrity check passed"
