# Phoenix Forge Schooling

**Single dual-interface Android APK** for family schooling: **Steward** (teacher/mentor) and **Child** (student) faces in one app.

| | |
|--|--|
| **App ID** | `phoenixforge_schooling` |
| **Package** | `com.phoenixforge.schooling` |
| **Repo** | `phoenix-forge-schooling` |
| **Path** | `/var/lib/phoenix-ai/workspace/phoenix-forge-schooling` |
| **Status** | Scaffolded (genesis) |

## Why this repo exists

`phoenix-forge-classroom` holds the legacy **three APK** stack and rearchitecture design.  
**Schooling** is the greenfield product home: one APK, kit-aligned, security-first, full master roadmap.

## Modules

```
app/        APK shell — RoleRouter, ChannelService
backbone/   Domain — profile, events, secure mesh, Room
teacher/    Steward UI
student/    Child UI
```

## Platform components

| Component | includeBuild |
|-----------|--------------|
| phoenixforge-kit | foundation + build-logic |
| phoenixforge-theme | theme + theme-compose |
| phoenixforge-data | PF5 data plane |
| phoenixforge-widget | Glance widgets |

## Quick start

```bash
cd /var/lib/phoenix-ai/workspace/phoenix-forge-schooling
# Ensure Android SDK: copy local.properties from another app if needed
cp ../phoenix-forge-omai/local.properties .  # if present
./scripts/cline-essence-drift-check.sh
./gradlew projects
./gradlew :app:assembleDebug
./init.sh
```

## Master roadmap

**Only schedule:** [docs/roadmaps/00_MASTER_ROADMAP.md](docs/roadmaps/00_MASTER_ROADMAP.md)  
Current step: **0.01** (genesis). Security foundation **0.25+** before bulk code port from classroom.

## Cline Essence

[docs/cline_essence/SKILL.md](docs/cline_essence/SKILL.md) — resilience-first agent protocol.

## Requirements source

- `../phoenix-forge-classroom` — implementation + docs  
- Grok multi-pass security audit (LAN, CP, backup) — see `docs/security/GROK_BASELINE.md`
