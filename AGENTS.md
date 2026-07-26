# AI Agents — Phoenix Forge Schooling

## Phoenix Forge Agency

- **Home contract:** `../phoenix-forge-home/registry/phoenix_forge_agency.yaml`
- **Lane:** schooling (new product). Classroom remains archive/source only.

## Read first

1. `docs/CONSTITUTION.md`
2. `registry/phoenix-forge-schooling.yaml`
3. `docs/roadmaps/00_MASTER_ROADMAP.md`
4. `docs/cline_essence/SKILL.md`
5. `docs/security/GROK_BASELINE.md`

## Product

| Field | Value |
|-------|--------|
| App | `phoenixforge_schooling` |
| Package | `com.phoenixforge.schooling` |
| Modules | app, backbone, teacher, student |
| Platform | kit + theme + data + widget |

## Forbidden

- New features in `../phoenix-forge-classroom/phoenix-forge-classroom-forge-profile/`
- Unauthenticated LAN routes
- Cleartext child PII on public storage
- `protectionLevel=normal` for child data
- Commit without explicit operator request
- Claiming LiveMessageChannel e2e without `registry/evidence/`

## Verify

```bash
./init.sh
./scripts/cline-essence-drift-check.sh
./gradlew :app:assembleDebug
```

## Requirements source

Capability and UX requirements: `../phoenix-forge-classroom`  
(rearchitecture docs + Grok audit + old 3-APK implementation).
