#!/usr/bin/env bash
# Drift check: Tier 0 files, platform composite builds, architecture law
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

missing=0

required=(
  docs/cline_essence/SKILL.md
  docs/cline_essence/MASTER_PROTOCOL.md
  docs/roadmaps/00_MASTER_ROADMAP.md
  docs/CONSTITUTION.md
  docs/ARCHITECTURE.md
  docs/architecture/DEPENDENCY_DIRECTION.md
  docs/architecture/CALLABLE_VARIABLE_INDEX_POLICY.md
  docs/architecture/review-sprint/00_INDEX.md
  docs/architecture/review-sprint/GOVERNANCE_LOCK.md
  docs/architecture/review-sprint/package-06-dependency-direction/README.md
  docs/architecture/adr/000_INDEX.md
  docs/architecture/adr/ADR-010-callable-variable-index.md
  registry/phoenix-forge-schooling.yaml
  registry/callable-variable-policy.md
  AGENTS.md
  README.md
  settings.gradle.kts
)

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

if ! grep -q 'phoenixforge_schooling' registry/phoenix-forge-schooling.yaml; then
  echo "FAIL: app_id not found in registry"
  missing=1
fi

# Platform includeBuild: kit + theme + data + widget
for lib in kit theme data widget; do
  if ! grep -q "includeBuild(\"../phoenixforge-${lib}" settings.gradle.kts; then
    echo "FAIL: missing includeBuild phoenixforge-${lib}"
    missing=1
  fi
done

# Dependency substitution targets (includeBuild alone is insufficient)
declare -A SUBS=(
  ["com.phoenixforge:foundation"]=":foundation"
  ["com.phoenixforge:theme"]=":theme"
  ["com.phoenixforge:theme-compose"]=":theme-compose"
  ["com.phoenixforge:data"]=":data"
  ["com.phoenixforge:widget"]=":widget"
)

settings="$(cat settings.gradle.kts)"
for mod in "${!SUBS[@]}"; do
  proj="${SUBS[$mod]}"
  if ! grep -qF "substitute(module(\"${mod}\"))" settings.gradle.kts; then
    echo "FAIL: missing substitute for ${mod}"
    missing=1
    continue
  fi
  # Ensure the using(project(...)) appears in the same file (order-independent enough)
  if ! grep -qF "using(project(\"${proj}\"))" settings.gradle.kts; then
    echo "FAIL: missing using(project(\"${proj}\")) for ${mod}"
    missing=1
  fi
done

# Cross-module forbidden gradle edges (coarse)
if grep -q 'project(":student")' teacher/build.gradle.kts 2>/dev/null; then
  echo "FAIL: teacher must not depend on :student"
  missing=1
fi
if grep -q 'project(":teacher")' student/build.gradle.kts 2>/dev/null; then
  echo "FAIL: student must not depend on :teacher"
  missing=1
fi
if grep -q 'project(":app")' backbone/build.gradle.kts 2>/dev/null; then
  echo "FAIL: backbone must not depend on :app"
  missing=1
fi

# Registry pointer must not be empty and should mention canonical path
if ! grep -q 'CALLABLE_VARIABLE_INDEX_POLICY.md' registry/callable-variable-policy.md; then
  echo "FAIL: registry/callable-variable-policy.md must point at canonical policy"
  missing=1
fi

if [[ "$missing" -ne 0 ]]; then
  echo "DRIFT: FAIL"
  exit 1
fi
echo "DRIFT: PASS"
exit 0
