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
│   ├── auth/     RoleManager, SessionStore, StewardGate
│   ├── security/ MeshAuth, TokenStore, RateLimiter, BackupCipher, PermissionMatrix
│   ├── database/ SchoolingDatabase (operational only — ADR-008)
│   ├── events/   EventWriter → TransportPort; Ingester; queues
│   ├── sync/     PublicSyncWriter (jailed), watchers
│   ├── network/  LanHttpServer, pairing, DeviceRegistry, transport/
│   ├── backup/   uses security.BackupCipher
│   └── config/   Index bootstrap
├── teacher/      steward UI
└── student/      child UI
```

## Architecture Review Sprint

| Package | Topic | Path |
|---------|-------|------|
| 00 | Compliance + red-team | [package-00-compliance](architecture/review-sprint/package-00-compliance/README.md) |
| 06 | Dependency direction | [package-06-dependency-direction](architecture/review-sprint/package-06-dependency-direction/README.md) |
| — | Governance lock | [GOVERNANCE_LOCK.md](architecture/review-sprint/GOVERNANCE_LOCK.md) |
| 01–05 | DB, roles, events, mesh, LAN | [00_INDEX.md](architecture/review-sprint/00_INDEX.md) |
| ADR | Decisions 001–009 | [adr/000_INDEX.md](architecture/adr/000_INDEX.md) |
| Index | Key governance | [registry/callable-variable-policy.md](../registry/callable-variable-policy.md) |

**Implementation rule:** **0.14 Governance Lock** first; then design packages; **Package 05 blocked on Package 04 tests**.

## Source mapping

Classroom 3-APK tree maps per  
`../phoenix-forge-classroom/docs/REARCHITECTURE_PHASE4_OWNERSHIP.md`  
with **security rewrites** for network/backup/auth (never verbatim port of open LAN server).
