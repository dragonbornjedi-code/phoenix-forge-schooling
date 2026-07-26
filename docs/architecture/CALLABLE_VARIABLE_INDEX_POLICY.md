# CallableVariableIndex Policy — phoenixforge_schooling

**Status:** Architecture law (canonical)  
**Also linked from:** `registry/callable-variable-policy.md` (pointer only)  
**ADR:** [ADR-010](adr/ADR-010-callable-variable-index.md)  
**Blueprint:** kit §3 — every runtime lookup through the Index  

---

## 1. Ownership

| Role | Responsibility |
|------|----------------|
| **phoenixforge-kit foundation** | `CallableVariableIndex` interface, `RegistryBackedIndex`, key regex |
| **Schooling Architecture (docs)** | Catalog of `schooling.*` keys, immutability class, deprecation |
| **Schooling implementers** | Register defaults at `SchoolingApp` startup; **never invent** keys outside this policy without ADR |
| **Operator** | Edit operator-editable YAML under `registry/`; never edit immutable keys in production APKs |

**Who creates new keys?**

1. Propose in ADR or PR description with namespace + class (immutable / operator / runtime).  
2. Add to this file’s catalog **before** code lands.  
3. Register provider in `SchoolingIndexBootstrap` (or registry YAML loader).  
4. Evidence: unit test that key resolves.

**Forbidden:** ad-hoc `register("foo.bar")` in feature code without catalog entry.

---

## 2. Namespace rules

| Rule | Example |
|------|---------|
| Pattern | `^[a-z0-9_]+(\.[a-z0-9_]+)+$` (kit enforced) |
| App prefix | All schooling keys start with `schooling.` |
| No peer packages | Never `com.phoenixforge.world` as a key value literal in code — resolve peer via Index |
| No role string keys as free text | Use enums; Index may expose `schooling.role.active` as enum/string consistently |

---

## 3. Lifecycle classes

| Class | Meaning | When changes | Persistence |
|-------|---------|--------------|-------------|
| **IMMUTABLE** | Build/identity constants | App release only | Compiled defaults / BuildConfig via Index wrapper |
| **OPERATOR** | Site policy | Operator YAML / DataStore settings UI | `registry/` or encrypted prefs |
| **RUNTIME** | Session / device state | Process lifetime or session | DataStore / memory; may not survive process death unless documented |
| **DERIVED** | Computed from others | Always | Not stored; recompute |

### Deprecation

1. Mark key `deprecated: true` + `successor` in catalog.  
2. Keep registration ≥ **2 minor releases** or until successor proven.  
3. `resolve(old)` may log breadcrumb (TelemetryGate) once per process.  
4. Remove only after ADR “Deprecate key X”.

### Versioning

- Catalog has `policy_version` (this file).  
- Breaking key renames require policy_version bump + ADR.  
- Values may carry their own schema (e.g. transport enum v1).

---

## 4. Catalog (v1)

`policy_version: 1`

| Key | Class | Type | Default | Owner notes |
|-----|-------|------|---------|-------------|
| `schooling.app.id` | IMMUTABLE | String | `phoenixforge_schooling` | AppIdentity |
| `schooling.app.package` | IMMUTABLE | String | `com.phoenixforge.schooling` | applicationId |
| `schooling.role.active` | RUNTIME | enum | from SessionStore | SessionStore writes |
| `schooling.role.default_first_run` | OPERATOR | enum | unset | First-run wizard |
| `schooling.network.mesh.port` | OPERATOR | Int | `7433` | LanHttpServer |
| `schooling.network.mesh.service_type` | IMMUTABLE | String | `_phoenixforge._tcp.local.` | NsdRegistrar |
| `schooling.network.mesh.service_name` | IMMUTABLE | String | `phoenixforge_schooling` | NsdRegistrar |
| `schooling.network.mesh.bind_mode` | OPERATOR | enum | `paired_only` | `paired_only` \| `loopback_debug` |
| `schooling.sync.public_roots` | OPERATOR | List | documented roots | FileContractTransport |
| `schooling.sync.actor_app_id` | IMMUTABLE | String | `phoenixforge_schooling` | EventWriter wire |
| `schooling.transport.primary` | OPERATOR | enum | `file_contract` | `file_contract` \| `live_envelope` |
| `schooling.telemetry.enabled` | OPERATOR | Boolean | `false` | TelemetryGate |
| `schooling.telemetry.provider` | OPERATOR | String | `noop` | |
| `schooling.theme.steward` | OPERATOR | String | kit token id | theme-compose |
| `schooling.theme.child` | OPERATOR | String | kit token id | theme-compose |
| `schooling.provider.authority` | IMMUTABLE | String | `com.phoenixforge.schooling.provider` | if CP exported |
| `schooling.backup.mode` | OPERATOR | enum | `private_encrypted` | never `public_cleartext` |
| `schooling.security.body_max_bytes` | OPERATOR | Int | `262144` | LAN body limit |
| `schooling.security.pairing_ttl_ms` | OPERATOR | Long | `120000` | Pending pair window |
| `schooling.security.steward_session_ttl_ms` | OPERATOR | Long | `900000` | 15 min |
| `schooling.data.pf5.enabled` | OPERATOR | Boolean | `false` | until roadmap 2.50 |
| `schooling.widget.enabled` | OPERATOR | Boolean | `false` | until 2.50 |

---

## 5. Compatibility guarantees

- IMMUTABLE keys do not rename without major app version.  
- OPERATOR keys may gain new enum values with default fallback.  
- Removing a value without successor is a **breaking** change.  
- Tests must pin critical IMMUTABLE keys.

---

## 6. Verification

```bash
# After bootstrap implemented:
./gradlew :backbone:testDebugUnitTest --tests '*Index*'
# Catalog present:
test -f registry/callable-variable-policy.md
```

Evidence: `registry/evidence/phoenixforge_schooling/architecture-review/package-00/index-policy.md`
