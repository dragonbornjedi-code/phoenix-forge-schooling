#!/usr/bin/env bash
# Drift check: Tier 0 files and roadmap numbering hygiene
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

required=(
  docs/cline_essence/SKILL.md
  docs/cline_essence/MASTER_PROTOCOL.md
  docs/roadmaps/00_MASTER_ROADMAP.md
  docs/CONSTITUTION.md
  docs/ARCHITECTURE.md
  docs/architecture/review-sprint/00_INDEX.md
  docs/architecture/review-sprint/GOVERNANCE_LOCK.md
  docs/architecture/review-sprint/package-06-dependency-direction/README.md
  docs/architecture/adr/000_INDEX.md
  registry/phoenix-forge-schooling.yaml
  registry/callable-variable-policy.md
  AGENTS.md
  README.md
  settings.gradle.kts
)

missing=0
for f in "${required[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "MISSING: $f"
    missing=1
  fi
done

# Letter IDs forbidden in master roadmap
if grep -E '^\| [0-9]+\.[0-9]+-[A-Za-z]' docs/roadmaps/00_MASTER_ROADMAP.md >/dev/null 2>&1; then
  echo "FAIL: letter-suffix step IDs found in master roadmap"
  missing=1
fi

# Naming law
if ! grep -q 'phoenixforge_schooling' registry/phoenix-forge-schooling.yaml; then
  echo "FAIL: app_id not found in registry"
  missing=1
fi

# Platform includeBuild: kit + theme + data + widget
for lib in kit theme data widget; do
  if ! grep -q "phoenixforge-${lib}" settings.gradle.kts; then
    echo "FAIL: missing includeBuild phoenixforge-${lib}"
    missing=1
  fi
done

if [[ "$missing" -ne 0 ]]; then
  echo "DRIFT: FAIL"
  exit 1
fi
echo "DRIFT: PASS"
exit 0
