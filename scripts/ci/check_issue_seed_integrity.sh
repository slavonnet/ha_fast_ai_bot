#!/usr/bin/env bash
set -euo pipefail

echo "[process] Checking issue seed integrity"

if [ ! -d "docs/issues/meta" ] || [ ! -d "docs/issues/subtasks" ]; then
  echo "[process] Missing docs/issues directories"
  exit 1
fi

shopt -s nullglob
meta_files=(docs/issues/meta/*.md)
subtask_files=(docs/issues/subtasks/*.md)

if [ ${#meta_files[@]} -ne 9 ]; then
  echo "[process] Expected 9 meta files, got ${#meta_files[@]}"
  exit 1
fi

if [ ${#subtask_files[@]} -ne 36 ]; then
  echo "[process] Expected 36 subtask files, got ${#subtask_files[@]}"
  exit 1
fi

for s in {0..8}; do
  meta="docs/issues/meta/stg${s}-meta.md"
  if [ ! -f "$meta" ]; then
    echo "[process] Missing meta file: $meta"
    exit 1
  fi

  for t in {1..4}; do
    matches=(docs/issues/subtasks/stg${s}-0${t}-*.md)
    if [ ${#matches[@]} -ne 1 ]; then
      echo "[process] Expected exactly 1 subtask file for STG${s}-0${t}, got ${#matches[@]}"
      exit 1
    fi
  done
done

for f in "${subtask_files[@]}"; do
  if ! grep -qE "^## TDD UserStory \(5\)" "$f"; then
    echo "[process] Missing TDD UserStory section in $f"
    exit 1
  fi

  stories_count="$(grep -cE "^[1-5]\. As " "$f")"
  if [ "$stories_count" -lt 5 ]; then
    echo "[process] Expected at least 5 user stories in $f, got $stories_count"
    exit 1
  fi

  if ! grep -qE "^## Acceptance criteria" "$f"; then
    echo "[process] Missing Acceptance criteria section in $f"
    exit 1
  fi
done

if [ ! -f "docs/ISSUE_BACKLOG.md" ]; then
  echo "[process] Missing docs/ISSUE_BACKLOG.md"
  exit 1
fi

for s in {0..8}; do
  if ! grep -q "STG${s}-META" "docs/ISSUE_BACKLOG.md"; then
    echo "[process] ISSUE_BACKLOG does not reference STG${s}-META"
    exit 1
  fi
  for t in {1..4}; do
    if ! grep -q "STG${s}-0${t}" "docs/ISSUE_BACKLOG.md"; then
      echo "[process] ISSUE_BACKLOG does not reference STG${s}-0${t}"
      exit 1
    fi
  done
done

echo "[process] Issue seed integrity check passed"
