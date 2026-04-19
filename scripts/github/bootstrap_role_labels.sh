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

for file in agents/roles/*/ISSUE_LABELS_*.yaml; do
  [ -f "$file" ] || continue
  role_id="$(sed -n 's/^role_id: //p' "$file" | head -n 1)"
  [ -n "$role_id" ] || continue

  ensure_label "req_start_${role_id}" "1d76db" "Request to start role"
  ensure_label "in_work_${role_id}" "fbca04" "Role is currently processing (lock label)"
  ensure_label "done_${role_id}" "5319e7" "Role finished execution"
  ensure_label "accept_${role_id}" "0e8a16" "Role result accepted"
  ensure_label "reject_${role_id}" "b60205" "Role result rejected"
done

echo "Role labels bootstrap complete"
