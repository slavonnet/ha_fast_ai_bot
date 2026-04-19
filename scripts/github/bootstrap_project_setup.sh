#!/usr/bin/env bash
set -euo pipefail

echo "Bootstrap commands for GitHub setup"
echo "Run in environment where gh has write permissions."
echo

echo "# Milestones"
for s in {0..8}; do
  echo "gh api repos/:owner/:repo/milestones -f title='Stage ${s}' -f state='open'"
done

echo
echo "# Labels"
echo "gh label create stage --color 0e8a16 --description 'Stage-related issue'"
echo "gh label create meta --color 5319e7 --description 'Stage meta issue'"
echo "gh label create subtask --color 1d76db --description 'Stage subtask issue'"
echo "gh label create tech-debt --color d93f0b --description 'Technical debt'"
echo "gh label create blocked --color b60205 --description 'Blocked by dependency'"
echo "gh label create risk --color fbca04 --description 'Risk requires mitigation'"
echo "gh label create track:h1-contracts --color c5def5 --description 'Contracts & Schemas'"
echo "gh label create track:h2-runtime --color c2e0c6 --description 'Runtime & Execution'"
echo "gh label create track:h3-integration --color f9d0c4 --description 'Integration & Reliability'"
echo "gh label create track:h4-qa-docs-release --color fef2c0 --description 'QA, Docs & Release'"
echo
echo "# Seed issues (prints commands)"
echo "./scripts/github/create_issues_from_seed.sh"
