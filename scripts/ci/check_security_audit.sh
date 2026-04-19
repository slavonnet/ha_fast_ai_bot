#!/usr/bin/env bash
set -euo pipefail

echo "[security] Running dependency vulnerability audit"

if [ -f "scripts/ci/changed_files.txt" ]; then
  if ! grep -qE "^(requirements.txt|pyproject.toml|package.json|package-lock.json|poetry.lock)" scripts/ci/changed_files.txt; then
    echo "[security] No dependency manifest changes detected, skipping audit gate"
    exit 0
  fi
elif [ ! -f "requirements.txt" ] && [ ! -f "pyproject.toml" ] && [ ! -f "package.json" ]; then
  echo "[security] No dependency manifests found in repository, skipping audit gate"
  exit 0
fi

if [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
  python3 -m pip install --upgrade pip
  python3 -m pip install pip-audit
  pip-audit
  echo "[security] pip-audit passed"
  exit 0
fi

if [ -f "package.json" ]; then
  npm audit --audit-level=high
  echo "[security] npm audit passed"
  exit 0
fi

echo "[security] No supported dependency manifest found (requirements.txt/pyproject.toml/package.json)"
exit 1
