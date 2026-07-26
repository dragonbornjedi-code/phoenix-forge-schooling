# Architecture — Phoenix Forge Schooling

**Law hierarchy:** Constitution → Kit BLUEPRINT → [Architecture Review Sprint](architecture/review-sprint/00_INDEX.md) → Master Roadmap.

## Module graph

```
phoenixforge-kit:foundation
phoenixforge-theme / theme-compose
phoenixforge-data
phoenixforge-widget
        ↑
    backbone/   (domain: profile, events, sync, secure LAN, DB)
   ↗         ↖
teacher/    student/   (UI libraries by role)
   ↘         ↙
       app/   (APK: RoleRouter, ChannelService, Application)
```

**Illegal edges:** teacher↔student, backbone→app/teacher/student.

## Roles

| Role | Face | Scopes |
|------|------|--------|
| STEWARD | teacher module | PUBLIC + LESSON + PROTECTED (unlocked) |
| CHILD | student module | PUBLIC + LESSON read; PUBLIC write only |

## Ownership (Blueprint)

| Concern | Owner |
|---------|-------|
| CallableVariableIndex, PhoenixForgeEvent, AppIdentity, DeviceProfile, TelemetryGate, LiveMessageChannel | **phoenixforge-kit foundation** |
| Theme tokens / Compose | **phoenixforge-theme** |
| PF5 catalog | **phoenixforge-data** (post-2.50) |
| Glance widgets | **phoenixforge-widget** |
| Schooling domain, Room, roles, pairing, LAN authz, EVT_ wire persistence | **schooling** |

## Transports

| Transport | Use |
|-----------|-----|
| `FileContractTransport` | Godot EVT_, public_state, manifests |
| `LiveEnvelopeTransport` | kit LiveMessageChannel (suite peers) |
| Secure LAN :7433 | **Paired devices only** — Package 04+05 |

Resolved via Index key `schooling.transport.primary`.

## CallableVariableIndex keys (initial)

See Package 00 catalog: `schooling.app.*`, `schooling.role.*`, `schooling.network.mesh.*`, `schooling.sync.*`, `schooling.transport.*`, `schooling.telemetry.*`, `schooling.theme.*`, `schooling.security.*`.

**No hardcoded** peer packages, LAN IPs, ports, or role strings in production call sites.

## Package tree (target)

```
com.phoenixforge.schooling
├── app/          SchoolingApp, MainActivity, RoleRouter, SchoolingChannelService
├── backbone/
│   ├── auth/     RoleManager, SessionStore, StewardGate, PermissionMatrix
│   ├── database/ SchoolingDatabase, entity, dao, repository
│   ├── events/   EventWriter, EventIngester, EventScope, LogicalClock, projectors
│   ├── sync/     PublicSyncWriter (jailed), watchers, SyncCoordinator
│   ├── network/  LanHttpServer, pairing, DeviceRegistry, MeshAuth, transport/
│   ├── backup/   encrypted private only
│   └── config/   Index bootstrap
├── teacher/      steward UI
└── student/      child UI
```

## Architecture Review Sprint

| Package | Topic | Path |
|---------|-------|------|
| 00 | Compliance + red-team | [architecture/review-sprint/package-00-compliance](architecture/review-sprint/package-00-compliance/README.md) |
| 01 | SchoolingDatabase | [package-01-database](architecture/review-sprint/package-01-database/README.md) |
| 02 | Role / Session / Router | [package-02-role-system](architecture/review-sprint/package-02-role-system/README.md) |
| 03 | Event pipeline | [package-03-event-pipeline](architecture/review-sprint/package-03-event-pipeline/README.md) |
| 04 | Mesh pairing | [package-04-mesh](architecture/review-sprint/package-04-mesh/README.md) |
| 05 | LanHttpServer | [package-05-lan-http](architecture/review-sprint/package-05-lan-http/README.md) |

**Implementation rule:** design packages first; code in roadmap order; **Package 05 blocked on Package 04 tests**.

## Source mapping

Classroom 3-APK tree maps per  
`../phoenix-forge-classroom/docs/REARCHITECTURE_PHASE4_OWNERSHIP.md`  
with **security rewrites** for network/backup/auth (never verbatim port of open LAN server).
