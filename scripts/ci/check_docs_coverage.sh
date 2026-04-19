#!/usr/bin/env bash
set -euo pipefail

echo "[docs] Checking docs coverage requirements"

REQUIRED=(
  "README.md"
  "docs/PROJECT_GOVERNANCE.md"
  "docs/STAGE_CATALOG.md"
)

for file in "${REQUIRED[@]}"; do
  if [ ! -f "$file" ]; then
    echo "[docs] Missing required documentation file: $file"
    exit 1
  fi

  if [ ! -s "$file" ]; then
    echo "[docs] Documentation file is empty: $file"
    exit 1
  fi
done

echo "[docs] Base docs exist and are non-empty"

if [ -f "scripts/ci/changed_files.txt" ]; then
  echo "[docs] Verifying documentation update for changed source files"
  if grep -qE "^(src/|app/|ha_fast_ai_bot/)" scripts/ci/changed_files.txt; then
    if ! grep -qE "^(docs/|README.md)" scripts/ci/changed_files.txt; then
      echo "[docs] Source changed without docs update"
      exit 1
    fi
  fi
fi

echo "[docs] Documentation coverage gate passed"
