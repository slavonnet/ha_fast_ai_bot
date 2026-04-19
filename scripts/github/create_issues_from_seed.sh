#!/usr/bin/env bash
set -euo pipefail

echo "Issue seed import helper" >&2
echo "Этот скрипт печатает команды для создания issues через gh." >&2
echo "Проверьте milestone/labels перед запуском." >&2

declare -A TRACK_LABELS=(
  ["H1 Contracts & Schemas"]="track:h1-contracts"
  ["H2 Runtime & Execution"]="track:h2-runtime"
  ["H3 Integration & Reliability"]="track:h3-integration"
  ["H4 QA, Docs & Release"]="track:h4-qa-docs-release"
)

for f in docs/issues/meta/*.md; do
  title="$(sed -n 's/^# //p' "$f" | head -n 1)"
  stage="$(sed -n 's/^- Milestone: //p' "$f" | head -n 1)"
  printf 'gh issue create --title %q --body-file %q --milestone %q --label stage --label meta\n' "$title" "$f" "$stage"
done

for f in docs/issues/subtasks/*.md; do
  title="$(sed -n 's/^# //p' "$f" | head -n 1)"
  stage_id="$(sed -n 's/^- Stage: STG\([0-9][0-9]*\).*/\1/p' "$f" | head -n 1)"
  stage="Stage ${stage_id}"
  track="$(sed -n 's/^- Track: //p' "$f" | head -n 1)"
  track_label="${TRACK_LABELS[$track]:-}"

  if [ -n "$track_label" ]; then
    printf 'gh issue create --title %q --body-file %q --milestone %q --label subtask --label %q\n' "$title" "$f" "$stage" "$track_label"
  else
    printf 'gh issue create --title %q --body-file %q --milestone %q --label subtask\n' "$title" "$f" "$stage"
  fi
done
