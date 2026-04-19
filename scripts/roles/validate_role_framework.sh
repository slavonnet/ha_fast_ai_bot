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

  agents_file="$dir/AGENTS.${upper}.md"
  labels_file="$dir/ISSUE_LABELS_${upper}.yaml"
  prompt_file="$dir/ROLE_PROMPT.md"
  agents_ref="agents/roles/$role_name/AGENTS.${upper}.md"

  [ -f "$agents_file" ] || { echo "[roles] Missing $agents_file"; exit 1; }
  [ -f "$labels_file" ] || { echo "[roles] Missing $labels_file"; exit 1; }
  [ -f "$prompt_file" ] || { echo "[roles] Missing $prompt_file"; exit 1; }

  if grep -q "## Next step" "$agents_file"; then
    echo "[roles] Next-step section is forbidden in role AGENTS file: $agents_file"
    exit 1
  fi
  if grep -q "^next_roles:" "$labels_file"; then
    echo "[roles] next_roles is forbidden in role labels file: $labels_file"
    exit 1
  fi

  if ! grep -q "Source of truth" "$prompt_file"; then
    echo "[roles] ROLE_PROMPT must declare source-of-truth policy: $prompt_file"
    exit 1
  fi
  if ! grep -q "$agents_ref" "$prompt_file"; then
    echo "[roles] ROLE_PROMPT must reference role AGENTS file: $prompt_file"
    exit 1
  fi

  for key in in_work done accept reject; do
    if ! grep -q "^  ${key}: " "$labels_file"; then
      echo "[roles] Missing status label '${key}' in $labels_file"
      exit 1
    fi
  done

  while IFS= read -r label; do
    [ -z "$label" ] && continue
    case "$label" in
      req_*|in_work_*|done_*|accept_*|reject_*) : ;;
      *)
        echo "[roles] Label prefix is not allowed ($label) in $labels_file"
        exit 1
        ;;
    esac
  done < <(sed -n 's/^  - //p; s/^  in_work: //p; s/^  done: //p; s/^  accept: //p; s/^  reject: //p' "$labels_file")
done

for req in   agents/rules/RULES.ISSUE_WORKFLOW.md   agents/rules/RULES.PR_WORKFLOW.md   agents/rules/RULES.CODE_DEVELOPMENT.md   agents/rules/RULES.TEST_DEVELOPMENT.md   agents/rules/RULES.DOC_DEVELOPMENT.md   agents/rules/RULES.STATE_MACHINE.md   agents/state-machine/STORY_SUBTASK_STATE_MACHINE.md   agents/state-machine/STORY_SUBTASK_STATE_MACHINE.json   agents/state-machine/ROLE_PAIRS.md   agents/state-machine/ROLLBACK_MATRIX.json   agents/WORKERS_AUTOMATION_MAP.yaml   agents/AUTOMATION_SETUP.md
  do
  [ -f "$req" ] || { echo "[roles] Missing required file: $req"; exit 1; }
done


if grep -q '"trigger_label"' agents/state-machine/STORY_SUBTASK_STATE_MACHINE.json   || grep -q '"done_label"' agents/state-machine/STORY_SUBTASK_STATE_MACHINE.json   || grep -q '"accept_label"' agents/state-machine/STORY_SUBTASK_STATE_MACHINE.json   || grep -q '"reject_label"' agents/state-machine/STORY_SUBTASK_STATE_MACHINE.json   || grep -q '"in_work_label"' agents/state-machine/STORY_SUBTASK_STATE_MACHINE.json; then
  echo "[roles] State machine JSON must not duplicate role labels; use ISSUE_LABELS files"
  exit 1
fi

if grep -q '^    trigger_label:' agents/WORKERS_AUTOMATION_MAP.yaml   || grep -q '^    done_label:' agents/WORKERS_AUTOMATION_MAP.yaml   || grep -q '^    accept_label:' agents/WORKERS_AUTOMATION_MAP.yaml   || grep -q '^    reject_label:' agents/WORKERS_AUTOMATION_MAP.yaml   || grep -q '^    in_work_label:' agents/WORKERS_AUTOMATION_MAP.yaml; then
  echo "[roles] WORKERS_AUTOMATION_MAP must not duplicate role labels; use labels_source_file"
  exit 1
fi

echo "[roles] Role framework integrity check passed"
