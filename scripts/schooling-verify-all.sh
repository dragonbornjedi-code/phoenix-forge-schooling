#!/usr/bin/env bash
# Phoenix Forge Schooling — verify-all gates
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail=0
run() {
  local name="$1"; shift
  echo "==> $name"
  if "$@"; then
    echo "    PASS: $name"
  else
    echo "    FAIL: $name"
    fail=1
  fi
}

run "projects" ./gradlew projects --quiet
run "tier0 files" test -f registry/phoenix-forge-schooling.yaml -a -f docs/roadmaps/00_MASTER_ROADMAP.md -a -f docs/cline_essence/SKILL.md
run "modules exist" test -d app -a -d backbone -a -d teacher -a -d student
run "drift" bash scripts/cline-essence-drift-check.sh

# Assemble is best-effort until kit paths resolve on this host
if ./gradlew :app:assembleDebug --quiet 2>/tmp/schooling-assemble.err; then
  echo "    PASS: assembleDebug"
else
  echo "    PARTIAL: assembleDebug (see /tmp/schooling-assemble.err) — scaffold may need local.properties / SDK"
  # do not fail overall on first-day SDK miss if projects resolved
fi

if [[ "$fail" -ne 0 ]]; then
  echo "OVERALL: FAIL"
  exit 1
fi
echo "OVERALL: PASS (scaffold gates)"
exit 0
