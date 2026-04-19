#!/usr/bin/env bash
set -euo pipefail

echo "[roles] Validating role framework integrity"

[ -f "AGENTS.md" ] || { echo "[roles] Missing AGENTS.md"; exit 1; }
[ -d "agents/roles" ] || { echo "[roles] Missing agents/roles"; exit 1; }
[ -d "agents/rules" ] || { echo "[roles] Missing agents/rules"; exit 1; }
[ -d "agents/state-machine" ] || { echo "[roles] Missing agents/state-machine"; exit 1; }

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

  if ! grep -q "Source of truth" "$prompt_file"; then
    echo "[roles] ROLE_PROMPT must declare source-of-truth policy: $prompt_file"
    exit 1
  fi
  if ! grep -q "$agents_ref" "$prompt_file"; then
    echo "[roles] ROLE_PROMPT must reference role AGENTS file: $prompt_file"
    exit 1
  fi

  rid="$(sed -n 's/^role_id: //p' "$labels_file" | head -n 1)"
  suffix="$(sed -n 's/^state_suffix: //p' "$labels_file" | head -n 1)"
  model="$(sed -n 's/^state_model: //p' "$labels_file" | head -n 1)"

  [ "$rid" = "$role_name" ] || { echo "[roles] role_id mismatch in $labels_file"; exit 1; }
  [ "$suffix" = "$role_name" ] || { echo "[roles] state_suffix mismatch in $labels_file"; exit 1; }
  [ "$model" = "prefix_plus_role_id" ] || { echo "[roles] state_model invalid in $labels_file"; exit 1; }

  # Prefix policy allowed only
  while IFS= read -r prefix; do
    [ -z "$prefix" ] && continue
    case "$prefix" in
      req_|in_work_|done_|accept_|reject_) : ;;
      *)
        echo "[roles] Disallowed prefix '$prefix' in $labels_file"
        exit 1
        ;;
    esac
  done < <(sed -n 's/^  - //p' "$labels_file")
done

for req in   agents/rules/RULES.ISSUE_WORKFLOW.md   agents/rules/RULES.PR_WORKFLOW.md   agents/rules/RULES.CODE_DEVELOPMENT.md   agents/rules/RULES.TEST_DEVELOPMENT.md   agents/rules/RULES.DOC_DEVELOPMENT.md   agents/rules/RULES.STATE_MACHINE.md   agents/state-machine/STORY_SUBTASK_STATE_MACHINE.md   agents/state-machine/STORY_SUBTASK_STATE_MACHINE.json   agents/state-machine/ROLE_PAIRS.md   agents/state-machine/ROLLBACK_MATRIX.json   agents/WORKERS_AUTOMATION_MAP.yaml   agents/AUTOMATION_SETUP.md   agents/roles/orchestrator_story/ORCHESTRATION_STATE_MACHINE.json   agents/roles/orchestrator_story/ROLLBACK_MATRIX.json
  do
  [ -f "$req" ] || { echo "[roles] Missing required file: $req"; exit 1; }
done

# No label duplication in generated map/state-machine pointers
if grep -q '^  - role_id:' agents/WORKERS_AUTOMATION_MAP.yaml; then
  echo "[roles] WORKERS_AUTOMATION_MAP must be autodiscovery config without hardcoded role list"
  exit 1
fi

if grep -q '"role_state_sources"' agents/state-machine/STORY_SUBTASK_STATE_MACHINE.json   || grep -q '"roles_order"' agents/state-machine/STORY_SUBTASK_STATE_MACHINE.json; then
  echo "[roles] Global state-machine JSON must be pointer-only"
  exit 1
fi

echo "[roles] Role framework integrity check passed"
