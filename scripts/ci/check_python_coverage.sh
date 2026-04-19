#!/usr/bin/env bash
set -euo pipefail

echo "[coverage] Running tests with strict 100% threshold"

if [ -f "scripts/ci/changed_files.txt" ]; then
  if ! grep -qE "^(src/|app/|ha_fast_ai_bot/|tests/)" scripts/ci/changed_files.txt; then
    echo "[coverage] No source/test changes detected, skipping coverage gate"
    exit 0
  fi
elif [ ! -d "src" ] && [ ! -d "app" ] && [ ! -d "tests" ] && [ ! -d "ha_fast_ai_bot" ]; then
  echo "[coverage] No source layout detected in repository, skipping coverage gate"
  exit 0
fi

if [ ! -f "pyproject.toml" ] && [ ! -f "requirements.txt" ]; then
  echo "[coverage] Source/test changes detected, but Python project files not found."
  echo "[coverage] Add pyproject.toml/requirements.txt and tests before merging code changes."
  exit 1
fi

python3 -m pip install --upgrade pip
python3 -m pip install pytest pytest-cov

pytest --cov=. --cov-report=term-missing --cov-fail-under=100
