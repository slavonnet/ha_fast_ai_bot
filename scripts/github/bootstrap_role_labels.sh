#!/usr/bin/env bash
set -euo pipefail

echo "Bootstrapping role state labels"

if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI is required"
  exit 1
fi

ensure_label() {
  local name="$1"
  local color="$2"
  local desc="$3"
  local exists
  exists="$(gh label list --limit 1000 --json name --jq '.[].name' | grep -Fx "$name" || true)"
  if [ -n "$exists" ]; then
    gh label edit "$name" --color "$color" --description "$desc" >/dev/null
    echo "updated: $name"
  else
    gh label create "$name" --color "$color" --description "$desc" >/dev/null
    echo "created: $name"
  fi
}

collect_labels_from_role_files() {
  local file
  for file in agents/roles/*/ISSUE_LABELS_*.yaml; do
    [ -f "$file" ] || continue
    sed -n 's/^  in_work: //p; s/^  done: //p; s/^  accept: //p; s/^  reject: //p' "$file"
    sed -n 's/^  - //p' "$file"
  done | sort -u
}

while IFS= read -r label; do
  [ -z "$label" ] && continue
  case "$label" in
    req_start_*) ensure_label "$label" "1d76db" "Request to start role" ;;
    in_work_*) ensure_label "$label" "fbca04" "Role is currently processing (lock label)" ;;
    done_*) ensure_label "$label" "5319e7" "Role finished execution" ;;
    accept_*) ensure_label "$label" "0e8a16" "Role result accepted" ;;
    reject_*) ensure_label "$label" "b60205" "Role result rejected" ;;
  esac
done < <(collect_labels_from_role_files)

echo "Role labels bootstrap complete"
