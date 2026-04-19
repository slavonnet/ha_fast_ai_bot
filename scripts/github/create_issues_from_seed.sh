#!/usr/bin/env bash
set -euo pipefail

echo "Issue seed import helper"
echo "Этот скрипт показывает команды для ручного импорта issues через gh."
echo "Проверьте milestone/labels перед запуском."

for f in docs/issues/meta/*.md; do
  title="$(sed -n 's/^# //p' "$f" | head -n 1)"
  echo "gh issue create --title \"$title\" --body-file \"$f\" --label stage --label meta"
done
for f in docs/issues/subtasks/*.md; do
  title="$(sed -n 's/^# //p' "$f" | head -n 1)"
  echo "gh issue create --title \"$title\" --body-file \"$f\" --label subtask"
done
