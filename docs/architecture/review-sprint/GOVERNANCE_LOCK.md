# Architecture Governance Lock

**Roadmap step:** `0.14`  
**Purpose:** Stable architectural contract before subsystem implementation (Packages 01–05 code).

## Deliverables

| Artifact | Path |
|----------|------|
| CallableVariableIndex policy (canonical) | [../CALLABLE_VARIABLE_INDEX_POLICY.md](../CALLABLE_VARIABLE_INDEX_POLICY.md) |
| Registry pointer | [registry/callable-variable-policy.md](../../../registry/callable-variable-policy.md) |
| Dependency direction (standalone law) | [../DEPENDENCY_DIRECTION.md](../DEPENDENCY_DIRECTION.md) |
| Dependency direction (Package 06) | [package-06-dependency-direction/README.md](package-06-dependency-direction/README.md) |
| ADR registry | [../adr/000_INDEX.md](../adr/000_INDEX.md) (001–010) |
| Package ownership | below |
| Security ownership | below |
| TransportPort policy | [ADR-003](../adr/ADR-003-transport-port.md) |
| SchoolingDatabase vs PF5 | [ADR-008](../adr/ADR-008-schooling-db-vs-pf5.md) |
| Security bounded context | [ADR-009](../adr/ADR-009-security-bounded-context.md) |
| Index sole lookup | [ADR-010](../adr/ADR-010-callable-variable-index.md) |

**Lock status:** Architecture / Blueprint / Governance **`[VERIFIED]`** (docs + drift).

## Package ownership table

| Package / area | Owns | Does not own |
|----------------|------|--------------|
| app | Application, RoleRouter shell, ChannelService host, DI root | Domain business rules |
| backbone/database | schooling.db operational state | PF5 catalog/vectors |
| backbone/auth + security | roles, sessions, MeshAuth, tokens, backup cipher | Kit AppIdentity |
| backbone/events | EventWriter/Ingester, scope, projectors | Godot binary / second EventBus |
| backbone/network | LAN server, mDNS, discovery clients | Token crypto primitives (security/) |
| backbone/sync | File paths, watchers, FileContractTransport | LiveMessageChannel impl (kit) |
| teacher | Steward UI + steward-only use cases | Child progression DB schema ownership |
| student | Child UI + PUBLIC writes | PROTECTED data |
| phoenixforge-kit | foundation APIs | schooling domain |
| phoenixforge-theme | design tokens | DB |
| phoenixforge-data | PF5 | schooling operational event log |
| phoenixforge-widget | Glance infra | teacher module |

## Security ownership table

| Concern | Owner package |
|---------|----------------|
| PermissionMatrix | backbone/security or auth |
| StewardGate / PIN / biometric | backbone/security + auth |
| Pairing token lifecycle | backbone/security + pairing |
| MeshAuth | backbone/security |
| Rate limit / body limit | network middleware + security config |
| Backup encryption | backbone/security + backup |
| Path containment | sync util (used by network + sync) |
| Signature permissions (manifest) | app |

## TransportPort policy (summary)

Domain → **TransportPort** only.  
Implementations: FileContractTransport, LiveEnvelopeTransport.  
No EventWriter → LanHttpServer direct dependency.

## Platform components (absolute paths)

| Path | Wired |
|------|-------|
| `/var/lib/phoenix-ai/workspace/phoenixforge-kit` | settings.gradle.kts includeBuild |
| `/var/lib/phoenix-ai/workspace/phoenixforge-theme` | includeBuild |
| `/var/lib/phoenix-ai/workspace/phoenixforge-data` | includeBuild |
| `/var/lib/phoenix-ai/workspace/phoenixforge-widget` | includeBuild |

Roadmap deep work: **2.50–2.74** (widget + PF5 features).  
Scaffold wiring: **0.03**, **0.14**.

## Verification

```bash
./scripts/cline-essence-drift-check.sh
test -f registry/callable-variable-policy.md
test -f docs/architecture/adr/000_INDEX.md
test -f docs/architecture/review-sprint/package-06-dependency-direction/README.md
rg 'includeBuild\("../phoenixforge-(kit|theme|data|widget)"\)' settings.gradle.kts | wc -l  # expect 4
```

Evidence: `registry/evidence/phoenixforge_schooling/architecture-review/governance-lock/`
