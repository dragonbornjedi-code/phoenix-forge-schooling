# Cline Essence — Master Protocol (Schooling)

**Tier 0 advisory overlay** for `phoenixforge_schooling`.

## Timeline

- Product ledger: `docs/roadmaps/00_MASTER_ROADMAP.md` decimals `0.00` … `5.00`
- Never invent letter suffixes (`0.00-A` forbidden)

## Architecture law

- **One APK**, two faces: STEWARD (teacher) + CHILD (student)
- Modules: `app/` → `teacher/` | `student/` → `backbone/` → phoenixforge-kit / theme / data / widget
- Source reference for capabilities: `../phoenix-forge-classroom` (archived 3-APK + rearchitecture docs)

## Forbidden

- Copying unauthenticated LAN code from classroom without pairing auth
- Cleartext child PII on public storage
- `protectionLevel="normal"` custom permissions for child data
- Claiming LiveMessageChannel e2e without device evidence
- Building old `phoenix-forge-classroom-forge-profile` for new features

## Verify entry

```bash
./scripts/schooling-verify-all.sh
./scripts/cline-essence-drift-check.sh
```
