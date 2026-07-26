# Package 00 — PhoenixForge Compliance Audit + Red-Team Architecture

**Status:** Design law (no code)  
**Master steps:** 0.08–0.14, 0.19–0.20, 0.25  
**Evidence:** `registry/evidence/phoenixforge_schooling/architecture-review/package-00/`

---

## 1. Mission

Prove that `phoenixforge_schooling` will behave as a **PhoenixForge application** under kit BLUEPRINT law, and that the master roadmap sequencing does not hide circular dependencies or classroom security regressions.

---

## 2. FAILURE & SECURITY AUDIT

### 2.1 Roadmap / coupling black swans

| ID | Failure | Impact | Guardrail |
|----|---------|--------|-----------|
| R-01 | Implement LanHttpServer before pairing | Unauth LAN returns (classroom P0) | Package 05 **blocked** until Package 04 acceptance tests green |
| R-02 | EventWriter before RoleManager | Child can write PROTECTED | Package 03 injects `PermissionMatrix`; fail closed if null |
| R-03 | RoleRouter before SessionStore | Orphaned STEWARD session after process death | Package 02 ships SessionStore + restore tests first |
| R-04 | Dual Room (PF5 + SchoolingDatabase) without ownership ADR | Silent dual writes / wipe | Package 01 defines: **domain events in SchoolingDatabase**; PF5 catalog optional later (`2.50`) |
| R-05 | Transport logic inside EventWriter | Cannot swap LiveEnvelope | Package 03 writes only to domain ports; Package 04/05 implement `SyncTransport` |
| R-06 | Copy classroom NanoHTTPD routes verbatim | P0 export open | Forbidden; Package 05 is rewrite |
| R-07 | Hardcoded `192.168.*` / Ezra UID | Misroute multi-child | CallableVariableIndex + DeviceRegistry only |
| R-08 | Second EventBus in schooling | Dropped events / dual sources of truth | Only `PhoenixForgeEventBus` for in-process; disk EVT_ for Godot |
| R-09 | Schooling owns AppIdentity | Breaks suite registry | Use `PhoenixForgeAppIdentity` from foundation |
| R-10 | Telemetry via `BuildConfig.DEBUG` | Silent PII in release | `TelemetryConfig` via Index → `telemetryGateFor` |

### 2.2 Compliance checklist (Blueprint)

| Law | Required | Current scaffold | Verdict |
|-----|----------|------------------|---------|
| includeBuild kit/theme/data/widget | yes | settings.gradle.kts | PASS (structure) |
| No foundation reimplementation | yes | No bus/identity yet | PASS (empty) |
| CallableVariableIndex keys | yes | Not wired | **FAIL until 0.45-class** |
| LiveMessageChannel not claimed e2e | yes | stub Service | PASS (honest stub) |
| Registry layout + evidence | yes | present | PASS |
| Naming `com.phoenixforge.schooling` | yes | package | PASS |
| signature permissions only for child data | yes | manifest READ/WRITE signature | PASS (scaffold) |
| allowBackup false | yes | manifest | PASS |
| Frozen Godot contracts | yes | EventScope + docs | PASS (intent) |
| Theme from phoenixforge-theme | yes | dep declared | PARTIAL (not applied) |
| Widget from phoenixforge-widget | yes | dep declared | PARTIAL (not used) |
| PF5 from phoenixforge-data | yes | dep declared | PARTIAL (deferred 2.50) |

### 2.3 Red-team: roadmap refinements

| Finding | Recommendation |
|---------|----------------|
| Role system split across 0.36 and 1.28 | **Pull** SessionStore + RoleManager stubs into `0.52–0.53` with backbone; RoleRouter UI remains `1.28` |
| Event pipeline before mesh | Keep; file_contract works offline without LAN |
| Widget/PF5 late | Correct — do not block 0.50 |
| Classroom port “copy then fix” | **Reject** for network/backup/auth; allow for pure UI |
| Spring stub / dual trees | Out of schooling scope; ignore |

### 2.4 Compile dependency audit (target)

```
app → teacher, student, backbone, foundation, theme-compose, data, widget
teacher → backbone, theme-compose
student → backbone, theme-compose
backbone → foundation, data (optional PF5 later), Room, OkHttp, NanoHTTPD, JmDNS, security-crypto
foundation → (none of schooling)
```

**Illegal edges:** teacher→student, student→teacher, backbone→app, backbone→teacher.

### 2.5 Memory / process audit (design)

| Concern | Law |
|---------|-----|
| Single process dual UI | One Application; role switch does not fork process |
| No second Room open in ContentProvider | Shared DAO singleton via Hilt |
| Index registration only on main Application.onCreate | One writer |

---

## 3. SYSTEM DESIGN — compliance architecture

### 3.1 Ownership matrix

| Concern | Owner | Schooling may |
|---------|-------|---------------|
| `CallableVariableIndex` | foundation | register `schooling.*` keys |
| `PhoenixForgeEvent` / bus | foundation | implement domain events |
| `PhoenixForgeAppIdentity` | foundation | construct once at startup |
| `DeviceProfile` | foundation | read |
| `TelemetryGate` / `NoOpTelemetryGate` | foundation | resolve via Index |
| `LiveMessageChannel` / `PhoenixForgeChannelService` | foundation | extend service; wrap as transport |
| Material3 theme | theme-compose | apply steward/child schemes |
| PF5 catalog | data | consume later |
| Glance widgets | widget | host later |
| School profiles, lessons, quests | schooling | own |
| Room domain DB | schooling | own `SchoolingDatabase` |
| Pairing / LAN auth | schooling | own (not kit) |
| EVT_ file wire format | contract (Godot) | preserve schemaVersion=1 |

### 3.2 CallableVariableIndex key catalog (initial)

```
schooling.app.id
schooling.app.package
schooling.role.active
schooling.role.default_first_run
schooling.network.mesh.port
schooling.network.mesh.service_type
schooling.network.mesh.service_name
schooling.network.mesh.bind_mode          # paired_only | loopback_debug
schooling.sync.public_roots
schooling.sync.actor_app_id
schooling.transport.primary              # file_contract | live_envelope
schooling.telemetry.enabled
schooling.telemetry.provider
schooling.theme.steward
schooling.theme.child
schooling.provider.authority
schooling.backup.mode                    # private_encrypted | disabled
schooling.security.body_max_bytes
schooling.security.pairing_ttl_ms
```

**Forbidden literals in production code:** package names of peers, LAN IPs, role strings in conditionals without enum, ContentProvider authorities, ports.

### 3.3 Transport abstraction (Blueprint §6)

```
SyncTransport (schooling port)
  ├── FileContractTransport   → PublicSyncWriter / watchers
  └── LiveEnvelopeTransport   → LiveMessageChannel (kit)

Resolved by: index.resolve("schooling.transport.primary")
```

EventWriter / ManifestWriter / MessageRelay depend on **SyncTransport**, never on NanoHTTPD or File APIs directly.

### 3.4 Event inheritance

```
PhoenixForgeEvent (kit)
  └── SchoolingDomainEvent (schooling interface)
        ├── QuestDomainEvent
        ├── LessonDomainEvent
        ├── ProfileDomainEvent
        └── ProgressDomainEvent

Disk wire (Godot frozen):
  ForgeEventRecord-compatible JSON (schemaVersion=1) — NOT a second bus
```

In-process bus emits kit events for UI; **disk** remains EVT_ JSON for World.

### 3.5 Text diagrams

**Dependency**

```
[kit foundation] ← backbone ← teacher
                ← backbone ← student
                ← app ← teacher, student, backbone
[theme] ← app, teacher, student
[data]  ← backbone (optional PF5)
[widget]← app (later)
```

**Startup sequence**

```
SchoolingApp.onCreate
  → build PhoenixForgeAppIdentity
  → RegistryBackedIndex + register schooling.* keys
  → telemetryGateFor(config from index)
  → open SchoolingDatabase (Hilt)
  → SessionStore.restore()
  → if mesh enabled: PairingManager.start()
  → MainActivity → RoleRouter(session)
```

---

## 4. VERIFICATION

| Check | Command / method | Pass |
|-------|------------------|------|
| Drift | `./scripts/cline-essence-drift-check.sh` | exit 0 |
| Projects | `./gradlew projects` | 4 modules + kit includes |
| No foundation fork | `rg 'class PhoenixForgeEventBus' app backbone teacher student` | no hits |
| Index keys doc | this package key catalog committed | yes |
| Evidence folder | `mkdir -p registry/evidence/.../package-00` | exists |

### Unit / integration (when implementing compliance wiring)

- Index rejects illegal keys  
- Telemetry disabled → NoOp  
- Identity appId == registry  

---

## 5. CURSOR / GROK CLI IMPLEMENTATION PROMPT

See [prompts/IMPLEMENT.md](prompts/IMPLEMENT.md).

---

## 6. ACCEPTANCE CRITERIA (Package 00) — locked

Governance elevated to standalone architecture law (roadmap **0.14**):

- [x] ARCHITECTURE.md ownership + Index keys + transports  
- [x] [CALLABLE_VARIABLE_INDEX_POLICY.md](../../CALLABLE_VARIABLE_INDEX_POLICY.md) (canonical) + registry pointer  
- [x] [DEPENDENCY_DIRECTION.md](../../DEPENDENCY_DIRECTION.md)  
- [x] ADR registry [000_INDEX.md](../../adr/000_INDEX.md) — **001–010**  
- [x] Package 06 + [GOVERNANCE_LOCK.md](../GOVERNANCE_LOCK.md)  
- [x] Platform kit/theme/data/widget includeBuild **and** substitution targets in drift  
- [x] Architecture / Blueprint / Governance classified **[VERIFIED]** as documentation law  

**Index bootstrap application code** remains **[UNTESTED]** until Package 00 implement prompt is run — that is implementation, not architecture lock.

**Architecture status: `[VERIFIED]`**  
**Blueprint alignment: `[VERIFIED]`**  
**Governance: `[VERIFIED]`**
