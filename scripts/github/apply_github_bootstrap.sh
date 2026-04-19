#!/usr/bin/env bash
set -euo pipefail

echo "Applying GitHub bootstrap (milestones, labels, issues)"

if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI is required"
  exit 1
fi

issue_exists_by_title() {
  local title="$1"
  local count
  count="$(
    gh issue list --state all --search "\"${title}\" in:title" --limit 200 --json title --jq 'length'
  )"
  [ "$count" -gt 0 ]
}

echo "[1/4] Ensuring milestones Stage 0..9"
for s in {0..9}; do
  title="Stage ${s}"
  exists="$(gh api repos/:owner/:repo/milestones --paginate --jq '.[].title' | grep -Fx "$title" || true)"
  if [ -n "$exists" ]; then
    echo "  - exists: ${title}"
  else
    gh api repos/:owner/:repo/milestones -f title="${title}" -f state="open" >/dev/null
    echo "  - created: ${title}"
  fi
done

echo "[2/4] Ensuring labels"
ensure_label() {
  local name="$1"
  local color="$2"
  local desc="$3"
  local exists
  exists="$(gh label list --limit 500 --json name --jq '.[].name' | grep -Fx "$name" || true)"
  if [ -n "$exists" ]; then
    gh label edit "$name" --color "$color" --description "$desc" >/dev/null
    echo "  - updated: $name"
  else
    gh label create "$name" --color "$color" --description "$desc" >/dev/null
    echo "  - created: $name"
  fi
}

ensure_label "stage" "0e8a16" "Stage-related issue"
ensure_label "meta" "5319e7" "Stage meta issue"
ensure_label "subtask" "1d76db" "Stage subtask issue"
ensure_label "tech-debt" "d93f0b" "Technical debt"
ensure_label "blocked" "b60205" "Blocked by dependency"
ensure_label "risk" "fbca04" "Risk requires mitigation"
ensure_label "track:h1-contracts" "c5def5" "Contracts & Schemas"
ensure_label "track:h2-runtime" "c2e0c6" "Runtime & Execution"
ensure_label "track:h3-integration" "f9d0c4" "Integration & Reliability"
ensure_label "track:h4-qa-docs-release" "fef2c0" "QA, Docs & Release"

echo "[3/4] Creating meta issues"
for f in docs/issues/meta/*.md; do
  title="$(sed -n 's/^# //p' "$f" | head -n 1)"
  stage="$(sed -n 's/^- Milestone: //p' "$f" | head -n 1)"
  if issue_exists_by_title "$title"; then
    echo "  - exists: $title"
    continue
  fi
  gh issue create --title "$title" --body-file "$f" --milestone "$stage" --label stage --label meta >/dev/null
  echo "  - created: $title"
done

echo "[4/4] Creating subtask issues"
for f in docs/issues/subtasks/*.md; do
  title="$(sed -n 's/^# //p' "$f" | head -n 1)"
  stage_id="$(sed -n 's/^- Stage: STG\([0-9][0-9]*\).*/\1/p' "$f" | head -n 1)"
  stage="Stage ${stage_id}"
  track="$(sed -n 's/^- Track: //p' "$f" | head -n 1)"
  track_label=""
  case "$track" in
    "H1 Contracts & Schemas") track_label="track:h1-contracts" ;;
    "H2 Runtime & Execution") track_label="track:h2-runtime" ;;
    "H3 Integration & Reliability") track_label="track:h3-integration" ;;
    "H4 QA, Docs & Release") track_label="track:h4-qa-docs-release" ;;
  esac

  if issue_exists_by_title "$title"; then
    echo "  - exists: $title"
    continue
  fi

  if [ -n "$track_label" ]; then
    gh issue create --title "$title" --body-file "$f" --milestone "$stage" --label subtask --label "$track_label" >/dev/null
  else
    gh issue create --title "$title" --body-file "$f" --milestone "$stage" --label subtask >/dev/null
  fi
  echo "  - created: $title"
done

echo "Summary by milestone:"
for s in {0..9}; do
  total="$(gh issue list --state all --search "milestone:\"Stage $s\"" --json number --jq 'length')"
  open="$(gh issue list --state open --search "milestone:\"Stage $s\"" --json number --jq 'length')"
  closed=$((total - open))
  echo "  Stage $s => total:$total open:$open closed:$closed"
done

echo "Done"
