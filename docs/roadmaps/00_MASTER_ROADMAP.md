# Master Roadmap — Phoenix Forge Schooling

**The only repo-wide todo list.** Every feature, fix, doc, script, and enforcement step lives here as a decimal `X.XX`. Nothing else schedules work.

| Field | Value |
|-------|--------|
| **App ID** | `phoenixforge_schooling` |
| **Package** | `com.phoenixforge.schooling` |
| **Repo** | `phoenix-forge-schooling` |
| **Finish line** | `5.00` |
| **Current step** | `0.01` — next: `0.02` |
| **Requirements source** | `../phoenix-forge-classroom` (3-APK archive + rearchitecture + Grok audit) |
| **Protocol** | [cline_essence/SKILL.md](../cline_essence/SKILL.md) |

Current step: **0.01**

**Architecture Review Sprint (design law):**  
[docs/architecture/review-sprint/00_INDEX.md](../architecture/review-sprint/00_INDEX.md)  
Packages 00–06 + [GOVERNANCE_LOCK.md](../architecture/review-sprint/GOVERNANCE_LOCK.md) before coding backbone security surfaces.

---

## Mission

Ship **one offline-first dual-interface schooling APK** that absorbs every beneficial classroom capability (profile identity, steward teaching, child experience, sync, mesh, curriculum, quests, memories, chariot, agency tooling) into `phoenixforge_schooling`, hardened with Grok P0 security and fully wired to **phoenixforge-kit, theme, data, and widget**.

---

## Platform components — mandatory (absolute paths)

All four PhoenixForge shared libraries are **in scope** for this product. They are wired via composite `includeBuild` in `settings.gradle.kts` and scheduled on this roadmap.

| Workspace path | Coordinate(s) | Scaffold wiring | Feature depth on roadmap |
|----------------|---------------|-----------------|---------------------------|
| `/var/lib/phoenix-ai/workspace/phoenixforge-kit` | `com.phoenixforge:foundation` + build-logic | **0.03**, continuous | Identity, Index, Event bus, TelemetryGate, LiveMessageChannel — **every phase** |
| `/var/lib/phoenix-ai/workspace/phoenixforge-theme` | `theme`, `theme-compose` | **0.03**, app/teacher/student deps | Steward/Child themes — **0.92, 1.18, 2.56** |
| `/var/lib/phoenix-ai/workspace/phoenixforge-data` | `com.phoenixforge:data` | **0.03** includeBuild; flag off | PF5 catalog/vectors — **2.50–2.74** (ADR-008: not operational event log) |
| `/var/lib/phoenix-ai/workspace/phoenixforge-widget` | `com.phoenixforge:widget` | **0.03** includeBuild; flag off | Glance widgets — **2.50–2.74** |

**Verification:** `./gradlew projects` lists included builds `:phoenixforge-kit`, `:phoenixforge-theme`, `:phoenixforge-data`, `:phoenixforge-widget`.

**Governance:** [registry/callable-variable-policy.md](../../registry/callable-variable-policy.md) · [Package 06](../architecture/review-sprint/package-06-dependency-direction/README.md) · [ADRs](../architecture/adr/000_INDEX.md)

---

## Threat model (top risks)

| # | Risk | Impact | Guardrail |
|---|------|--------|-----------|
| 1 | Unauthenticated LAN control plane | Child PII / curriculum injection | Pairing tokens; default-deny NanoHTTPD; directed push only |
| 2 | Weak ContentProvider permissions | Any app reads child data | `signature` only; no third-party export of child progress |
| 3 | Cleartext backups on `/sdcard` | Full childhood corpus leak | Encrypted app-private backup; never public PII dumps |
| 4 | Fan-out mDNS push | Messages to wrong devices | `_phoenixforge._tcp` + linked-host only |
| 5 | Dual Room / destructive migrations | Silent data wipe | Single `SchoolingDatabase`; versioned migrations |
| 6 | LiveMessageChannel false green | Broken suite IPC | Evidence required under `registry/evidence/` |
| 7 | Copying insecure classroom code | P0s return | Security steps 1.xx before bulk port |
| 8 | Scope leakage child→PROTECTED | Boundary violation | `EventScope` + RoleManager enforcement tests |
| 9 | LLM audit note egress | Family privacy | Sage prompt minimization + opt-in |
| 10 | Agent builds wrong tree | Wasted work | AGENTS.md + registry gradle_root only this repo |

---

### Sibling product references (not includeBuild)

| Path | Role |
|------|------|
| `/var/lib/phoenix-ai/workspace/phoenix-forge-world` | Frozen file contracts (EVT_, public_state, manifests) |
| `/var/lib/phoenix-ai/workspace/phoenix-forge-classroom` | Capability inventory + code archive to port |

---

## Numbering rules

| Rule | Meaning |
|------|---------|
| Format | `X.XX` only — no letter suffixes |
| Range | `0.00` … `5.00` |
| Forward only | Never renumber; insert next free decimal before `5.00` |
| Done | `[VERIFIED]` or `[TESTED]` then bump `current_step` + registry |
| Verify tags | Cline Essence: VERIFIED / TESTED / PARTIAL / UNTESTED |

---

## Milestone ladder

```text
0.00 Genesis              0.01 ── 0.24
0.25 Security foundation  0.26 ── 0.49
0.50 Backbone domain      0.51 ── 0.74
0.75 Steward face         0.76 ── 0.99
1.00 Child face           1.01 ── 1.24
1.25 App shell / roles    1.25 ── 1.49
1.50 Sync & contracts     1.50 ── 1.74
1.75 Mesh & messaging     1.75 ── 1.99
2.00 Suite integration    2.01 ── 2.24
2.25 Agency & scripts     2.25 ── 2.49
2.50 Widget & data PF5    2.50 ── 2.74
2.75 Content & curriculum 2.75 ── 2.99
3.00 Memory & identity    3.01 ── 3.24
3.25 Chariot & car        3.25 ── 3.49
3.50 Reliability          3.50 ── 3.74
3.75 Observability        3.75 ── 3.99
4.00 Hardening            4.01 ── 4.49
4.50 Cutover & decommission 4.50 ── 4.91
5.00 Repo complete
```

---

## Master todo ledger

### 0.00 Genesis — workspace & law

| Step | Area | Deliverable | Verification | Status |
|------|------|-------------|--------------|--------|
| **0.00** | — | **MILESTONE: Genesis** | — | [VERIFIED] |
| 0.01 | Cross | Repo at `/var/lib/phoenix-ai/workspace/phoenix-forge-schooling` + git | dir + `.git` | [TESTED] |
| 0.02 | Cross | GitHub remote `phoenix-forge-schooling` | `gh repo view` | pending |
| 0.03 | Cross | Gradle modules app/backbone/teacher/student + kit/theme/data/widget includeBuild | `./gradlew projects` | pending |
| 0.04 | Cross | Tier 0: CONSTITUTION, ARCHITECTURE, registry YAML, AGENTS, README | drift check | pending |
| 0.05 | Cross | Cline Essence SKILL + MASTER_PROTOCOL | files | [TESTED] |
| 0.06 | Cross | This master roadmap 0.00–5.00 skeleton complete | file exists | [TESTED] |
| 0.07 | Cross | `scripts/schooling-verify-all.sh` + drift-check + `init.sh` | exit 0 scaffold | pending |
| 0.08 | Cross | Kit app registry entry `phoenixforge_schooling` | kit YAML | pending |
| 0.09 | Cross | LiveMessageChannel registry row for schooling | live_message_channel.yaml | pending |
| 0.10 | Cross | Suite workspace file includes schooling folder | code-workspace | pending |
| 0.11 | Cross | `.cursor/rules` + AGENTS turn-zero handoffs paths | files | pending |
| 0.12 | Cross | Capability inventory map from classroom (Phase 4 ownership) | docs/architecture/CAPABILITY_MAP.md | pending |
| 0.13 | Cross | Security baseline + Architecture Review Sprint Packages 00–05 | docs/security/GROK_BASELINE.md + docs/architecture/review-sprint/00_INDEX.md | [TESTED] |
| 0.14 | Cross | **Architecture Governance Lock** — standalone DEPENDENCY_DIRECTION + CALLABLE_VARIABLE_INDEX_POLICY, ADRs 001–010, Package 06, substitution drift, ownership tables | drift PASS + docs/architecture/* | [VERIFIED] |
| 0.15 | Cross | local.properties / SDK note for Crucible builds | README | pending |
| 0.16 | Cross | Scaffold Kotlin compiles or documented PARTIAL | assemble or evidence | pending |
| 0.17 | Cross | Evidence dir `registry/evidence/phoenixforge_schooling/` | exists | pending |
| 0.18 | Cross | Handoffs dir + session template | registry/handoffs | pending |
| 0.19 | Cross | Naming law: package `com.phoenixforge.schooling` only | grep | pending |
| 0.20 | Cross | Document relationship: classroom = archive/source; schooling = product | README | pending |
| 0.21 | Cross | CI workflow assembleDebug (best-effort) | .github/workflows | pending |
| 0.22 | Cross | License / private repo policy | GitHub settings | pending |
| 0.23 | Cross | Operator boot prompt for agents | BOOT.md | pending |
| **0.24** | — | **Genesis closed** | 0.01–0.23 | pending |

### 0.25 Security foundation (before bulk code port)

| Step | Area | Deliverable | Verification | Status |
|------|------|-------------|--------------|--------|
| **0.25** | — | **MILESTONE: Security foundation** | — | pending |
| 0.26 | Sec | Mesh pairing store design (token, deviceId, allowedIps, studentUid map) | ADR | pending |
| 0.27 | Sec | LAN default-deny: Bearer required on export/events/messages/link/manifest | unit tests | pending |
| 0.28 | Sec | Public ping without activeProfileUid leak | unit | pending |
| 0.29 | Sec | Directed push only (no all-peers fan-out) | unit | pending |
| 0.30 | Sec | mDNS `_phoenixforge._tcp` + service name filter | unit | pending |
| 0.31 | Sec | Encrypted private backup only | unit + path assert | pending |
| 0.32 | Sec | All custom permissions `signature` | manifest lint | pending |
| 0.33 | Sec | Path containment on PublicSyncWriter / openFile | unit `../` | pending |
| 0.34 | Sec | RFC UUID validation | unit | pending |
| 0.35 | Sec | HTTP body size limits | unit | pending |
| 0.36 | Sec | Steward biometric/PIN session (no boolean auth) | unit + fake | pending |
| 0.37 | Sec | `allowBackup=false` + extraction rules | manifest | pending |
| 0.38 | Sec | TelemetryGate + consent (no always GRANTED RUM) | code + log | pending |
| 0.39 | Sec | Sage prompt DLP: audit notes opt-in | unit | pending |
| 0.40 | Sec | Cleartext traffic networkSecurityConfig (private ranges only if needed) | xml | pending |
| 0.41 | Sec | Release minify plan | build.gradle | pending |
| 0.42 | Sec | Shell scripts: no `python -c` with free-text inject | script audit | pending |
| 0.43 | Sec | ContentProvider callingPackage allowlist (same-suite) | unit | pending |
| 0.44 | Sec | Message write ACL by role/actor | unit | pending |
| 0.45 | Sec | Event scope enforcement matrix tests | unit | pending |
| 0.46 | Sec | Threat model review sign-off | doc | pending |
| 0.47 | Sec | Security regression suite in CI | gradle test | pending |
| 0.48 | Sec | Red-team checklist for mesh | docs/security | pending |
| **0.49** | — | **Security foundation closed** | 0.26–0.48 | pending |

### 0.50 Backbone domain

| Step | Area | Deliverable | Verification | Status |
|------|------|-------------|--------------|--------|
| **0.50** | — | **MILESTONE: Backbone domain** | — | pending |
| 0.51 | BB | Single `SchoolingDatabase` Room schema v1 | kapt | pending |
| 0.52 | BB | ProfileRepository + RoleManager + SessionStore | unit | pending |
| 0.53 | BB | ProfileBootstrap (create steward/child profiles) | unit | pending |
| 0.54 | BB | Avatar model + storage + export for Godot | unit | pending |
| 0.55 | BB | Timeline repository + projectors | unit | pending |
| 0.56 | BB | EventContract + EventIdFactory + LogicalClock | unit | pending |
| 0.57 | BB | EventWriter (PUBLIC/LESSON/PROTECTED by role) | unit | pending |
| 0.58 | BB | EventIngester + quarantine invalid JSON | unit | pending |
| 0.59 | BB | EventFileWatcher / coordinator | unit | pending |
| 0.60 | BB | StateProjector + public_state.json writer | unit | pending |
| 0.61 | BB | Message models + disk writer + ingester | unit | pending |
| 0.62 | BB | Manifest reader/validator (LESSON) | unit | pending |
| 0.63 | BB | SyncPaths + PublicSyncWriter (hardened) | unit | pending |
| 0.64 | BB | LanHttpServer secure routes | unit | pending |
| 0.65 | BB | NsdRegistrar + discovery client | unit | pending |
| 0.66 | BB | ConsentManager for bulk export | unit | pending |
| 0.67 | BB | BackupCoordinator encrypted | unit | pending |
| 0.68 | BB | DeviceRegistry / peer link table | unit | pending |
| 0.69 | BB | ContentProvider DTO-safe export | unit | pending |
| 0.70 | BB | Foreground sync service | compile | pending |
| 0.71 | BB | Hilt BackboneModule | kapt | pending |
| 0.72 | BB | Port unit tests from classroom core/sync | test | pending |
| 0.73 | BB | Memory artifact storage (app-private + checksum) | unit | pending |
| **0.74** | — | **Backbone closed** | `:backbone:check` | pending |

### 0.75 Steward face (teacher)

| Step | Area | Deliverable | Verification | Status |
|------|------|-------------|--------------|--------|
| **0.75** | — | **MILESTONE: Steward face** | — | pending |
| 0.76 | STEW | Expedition Board (tiles, reorder, filter, sections) | compile + unit | pending |
| 0.77 | STEW | Tile detail + status lifecycle | unit | pending |
| 0.78 | STEW | Start Day export + morning ritual | unit | pending |
| 0.79 | STEW | Lesson planner engine + quest draft generator | unit | pending |
| 0.80 | STEW | Curriculum domain/subdomain catalogs + weekly audit | compile | pending |
| 0.81 | STEW | Plan tab + domain coverage | compile | pending |
| 0.82 | STEW | Quest library seed + tags | unit | pending |
| 0.83 | STEW | ManifestWriter + directed mesh push | unit | pending |
| 0.84 | STEW | Sage Advisor + EncryptedSharedPreferences keys | unit | pending |
| 0.85 | STEW | Sage expedition apply (human-gated) | unit | pending |
| 0.86 | STEW | Student snapshot / roster bridge | compile | pending |
| 0.87 | STEW | ChildStudentUidResolver (no hardcode in release) | unit | pending |
| 0.88 | STEW | Teacher notes (local encrypted or private prefs) | compile | pending |
| 0.89 | STEW | Protected event writers (behavioral notes) | unit | pending |
| 0.90 | STEW | Message relay to child (directed) | unit | pending |
| 0.91 | STEW | Chariot export from steward | unit | pending |
| 0.92 | STEW | Theme: steward Material3 (kit theme-compose) | UI | pending |
| 0.93 | STEW | TeacherNavGraph complete | UI | pending |
| 0.94 | STEW | Port teacher unit tests | test | pending |
| 0.95 | STEW | Steward field guide defaults / starter pack 01 | content | pending |
| 0.96 | STEW | NetworkGate for Sage only | unit | pending |
| 0.97 | STEW | Steward reflection models | unit | pending |
| 0.98 | STEW | Accessibility & large text pass | manual | pending |
| **0.99** | — | **Steward face closed** | `:teacher:check` | pending |

### 1.00 Child face (student)

| Step | Area | Deliverable | Verification | Status |
|------|------|-------------|--------------|--------|
| **1.00** | — | **MILESTONE: Child face** | — | pending |
| 1.01 | CHILD | Hearth / digital home hub | UI | pending |
| 1.02 | CHILD | QuestEngine lifecycle (seed/start/complete/claim) | unit | pending |
| 1.03 | CHILD | Quests UI + manifest-driven today list | UI | pending |
| 1.04 | CHILD | Unified ProgressionEngine (XP formula + rewards) | unit | pending |
| 1.05 | CHILD | Garden merchant / unlocks | unit | pending |
| 1.06 | CHILD | Gallery + vault import | UI | pending |
| 1.07 | CHILD | Memory event import (schema-gated + quarantine) | unit | pending |
| 1.08 | CHILD | NPC / companions / Spark | UI | pending |
| 1.09 | CHILD | Dreams board | UI | pending |
| 1.10 | CHILD | Story fragments / archive | UI | pending |
| 1.11 | CHILD | Inbox (read steward messages + reply PUBLIC) | UI | pending |
| 1.12 | CHILD | WorldOrchestrator + life events | unit | pending |
| 1.13 | CHILD | Behavior signals (local only) | unit | pending |
| 1.14 | CHILD | Profile import policy (student_self only) | unit | pending |
| 1.15 | CHILD | Session store + sign-in child profile | UI | pending |
| 1.16 | CHILD | Settings offline-first copy | strings | pending |
| 1.17 | CHILD | StudentNavGraph complete | UI | pending |
| 1.18 | CHILD | Theme: child Material3 | UI | pending |
| 1.19 | CHILD | Port student unit tests | test | pending |
| 1.20 | CHILD | Scope guard: no PROTECTED write/read | unit | pending |
| 1.21 | CHILD | public_state write on progression | unit | pending |
| 1.22 | CHILD | Chariot deep link activity (hardened) | UI | pending |
| 1.23 | CHILD | Accessibility child face | manual | pending |
| **1.24** | — | **Child face closed** | `:student:check` | pending |

### 1.25 App shell & role router

| Step | Area | Deliverable | Verification | Status |
|------|------|-------------|--------------|--------|
| **1.25** | — | **MILESTONE: App shell** | — | pending |
| 1.26 | APP | SchoolingApp Hilt + backbone init | assemble | pending |
| 1.27 | APP | MainActivity Compose host | assemble | pending |
| 1.28 | APP | RoleRouter STEWARD/CHILD DataStore | unit + UI | pending |
| 1.29 | APP | First-run role setup wizard | UI | pending |
| 1.30 | APP | PIN/biometric gate to switch roles | UI | pending |
| 1.31 | APP | FeatureGate per role | unit | pending |
| 1.32 | APP | AppModule + RoleModule Hilt | kapt | pending |
| 1.33 | APP | SchoolingChannelService → real kit base class | compile | pending |
| 1.34 | APP | Merged manifest audit (permissions, providers) | script | pending |
| 1.35 | APP | `:app:assembleDebug` green | gradle | pending |
| 1.36 | APP | Install on device side-by-side with classroom APKs | adb | pending |
| 1.37 | APP | Role switch smoke | manual | pending |
| 1.38 | APP | Crash-free cold start both roles | logcat | pending |
| 1.39 | APP | Deep link routing allowlist | unit | pending |
| 1.40 | APP | Process death restore role | manual | pending |
| 1.41 | APP | Notification channels (manifest delivery) | UI | pending |
| 1.42 | APP | App shortcuts / widgets entry | optional | pending |
| 1.43 | APP | Proguard keep rules draft | file | pending |
| 1.44 | APP | BuildConfig APP_ID matches registry | unit | pending |
| 1.45 | APP | CallableVariableIndex keys `schooling.*` | unit | pending |
| 1.46 | APP | AppIdentity registration with kit | unit | pending |
| 1.47 | APP | DeviceProfile integration | unit | pending |
| 1.48 | APP | Shell closed checklist | doc | pending |
| **1.49** | — | **App shell closed** | assemble + smoke | pending |

### 1.50 Sync & file contracts (Godot-compatible)

| Step | Area | Deliverable | Verification | Status |
|------|------|-------------|--------------|--------|
| **1.50** | — | **MILESTONE: Sync contracts** | — | pending |
| 1.51 | SYNC | Document frozen EVT_ schema (classroom parity) | docs/contracts | pending |
| 1.52 | SYNC | public_state.json parity with World | golden JSON test | pending |
| 1.53 | SYNC | lesson_manifest_*.json parity | golden | pending |
| 1.54 | SYNC | Multi-root path list documented | docs | pending |
| 1.55 | SYNC | MANAGE_EXTERNAL_STORAGE strategy (minimize / SAF) | ADR | pending |
| 1.56 | SYNC | Storage access helper + settings intent | UI | pending |
| 1.57 | SYNC | Syncthing path probe script | scripts | pending |
| 1.58 | SYNC | Godot read smoke checklist | manual | pending |
| 1.59 | SYNC | Event compaction WorkManager | unit | pending |
| 1.60 | SYNC | Snapshot writer integrity | unit | pending |
| 1.61 | SYNC | Idempotent ingest | unit | pending |
| 1.62 | SYNC | Clock skew handling | unit | pending |
| 1.63 | SYNC | Offline-only mode (no network required for core loop) | manual | pending |
| 1.64 | SYNC | Contract version field enforcement | unit | pending |
| 1.65 | SYNC | Migration guide from classroom package paths | docs | pending |
| 1.66 | SYNC | Shared schemas copied/adapted under shared/ | files | pending |
| 1.67 | SYNC | Quest ledger CLI port or link | scripts | pending |
| 1.68 | SYNC | NDJSON memory events path policy | docs | pending |
| 1.69 | SYNC | Fail-closed on corrupt files | unit | pending |
| 1.70 | SYNC | Operator runbook: adb push manifests | docs | pending |
| 1.71 | SYNC | Verify file_contract round-trip | evidence | pending |
| 1.72 | SYNC | Backup/restore dry run | manual | pending |
| 1.73 | SYNC | Contract freeze sign-off | doc | pending |
| **1.74** | — | **Sync contracts closed** | 1.51–1.73 | pending |

### 1.75 Mesh & LiveMessageChannel

| Step | Area | Deliverable | Verification | Status |
|------|------|-------------|--------------|--------|
| **1.75** | — | **MILESTONE: Mesh & messaging** | — | pending |
| 1.76 | MESH | Pairing UX (generate/display/enter token) | UI | pending |
| 1.77 | MESH | Secure LAN client shared OkHttp | unit | pending |
| 1.78 | MESH | Tailscale discovery optional (rate-limited) | unit | pending |
| 1.79 | MESH | LiveMessageChannelImpl using kit | compile | pending |
| 1.80 | MESH | Bind SchoolingChannelService properly | device | pending |
| 1.81 | MESH | Same-device message to omai/omide (when ready) | evidence | pending |
| 1.82 | MESH | WAL rotation for channel logs | unit | pending |
| 1.83 | MESH | Mesh delivery notifications | UI | pending |
| 1.84 | MESH | Consent dialog for bulk profile export | UI | pending |
| 1.85 | MESH | Link student API authz | unit | pending |
| 1.86 | MESH | Replay-safe message IDs | unit | pending |
| 1.87 | MESH | Rate limit LAN POSTs | unit | pending |
| 1.88 | MESH | Logging redaction (no tokens in logcat) | unit | pending |
| 1.89 | MESH | Disable open :7433 in release unless paired | build | pending |
| 1.90 | MESH | Mesh integration test harness | scripts | pending |
| 1.91 | MESH | Document mesh threat model | docs | pending |
| 1.92 | MESH | Failover to file_contract when LAN down | manual | pending |
| 1.93 | MESH | Peer revoke / unpair | UI | pending |
| 1.94 | MESH | Clock sync note in ping | unit | pending |
| 1.95 | MESH | Certificate/pinning future ADR | docs | pending |
| 1.96 | MESH | Multi-child household routing | unit | pending |
| 1.97 | MESH | Mesh closed checklist | doc | pending |
| 1.98 | MESH | Evidence pack for mesh smoke | registry/evidence | pending |
| **1.99** | — | **Mesh closed** | 1.76–1.98 | pending |

### 2.00 Suite integration

| Step | Area | Deliverable | Verification | Status |
|------|------|-------------|--------------|--------|
| **2.00** | — | **MILESTONE: Suite integration** | — | pending |
| 2.01 | SUITE | Interop with phoenix-forge-world file paths | manual | pending |
| 2.02 | SUITE | Interop with phoenix-forge-omai (health or channel) | evidence | pending |
| 2.03 | SUITE | Interop with phoenix-forge-omide tools if needed | evidence | pending |
| 2.04 | SUITE | Dashboard scripts allowlist entry (home) | home registry | pending |
| 2.05 | SUITE | Agency lane entry for schooling | home AGENTS | pending |
| 2.06 | SUITE | Turn state / continuation handoff paths | handoffs | pending |
| 2.07 | SUITE | Cross-app magic layer note | docs | pending |
| 2.08 | SUITE | PCAS / curriculum OS schema alignment | docs/contracts | pending |
| 2.09 | SUITE | Childhood compass / significance hooks (read-only first) | docs | pending |
| 2.10 | SUITE | Identity continuity notes | docs | pending |
| 2.11 | SUITE | Primary device authority policy | docs | pending |
| 2.12 | SUITE | Offline data & sync design adapted | docs | pending |
| 2.13 | SUITE | Chariot product paths | docs | pending |
| 2.14 | SUITE | Voice playback policy reference | shared | pending |
| 2.15 | SUITE | Emotion palette / visual language | shared | pending |
| 2.16 | SUITE | Suite map update in world docs (if allowed) | cross-repo | pending |
| 2.17 | SUITE | No collision with classroom package names | adb pm list | pending |
| 2.18 | SUITE | Install script multi-device | scripts | pending |
| 2.19 | SUITE | Smoke: steward push → child receive | manual | pending |
| 2.20 | SUITE | Smoke: child event → steward timeline | manual | pending |
| 2.21 | SUITE | Smoke: World public_state read | manual | pending |
| 2.22 | SUITE | Integration evidence JSONL | evidence | pending |
| 2.23 | SUITE | Suite milestone sign-off | doc | pending |
| **2.24** | — | **Suite integration closed** | 2.01–2.23 | pending |

### 2.25 Agency, scripts, enforcement

| Step | Area | Deliverable | Verification | Status |
|------|------|-------------|--------------|--------|
| **2.25** | — | **MILESTONE: Agency & scripts** | — | pending |
| 2.26 | OPS | `schooling-context-pack.sh` | script | pending |
| 2.27 | OPS | `schooling-route-classify.py` (leaf agents) | script | pending |
| 2.28 | OPS | `schooling-delegation-verify.py` | script | pending |
| 2.29 | OPS | Agent manifest YAML (leaf owns/verify) | registry | pending |
| 2.30 | OPS | Context budget YAML | registry | pending |
| 2.31 | OPS | Dishonesty / scoring framework (optional port) | registry | pending |
| 2.32 | OPS | Turn score recorder (safe env, no injection) | script | pending |
| 2.33 | OPS | Session start/finish scripts | script | pending |
| 2.34 | OPS | Memory graph seed | script | pending |
| 2.35 | OPS | Quest ledger tool adapted | script | pending |
| 2.36 | OPS | Chariot adb helper | script | pending |
| 2.37 | OPS | Install APK script (single APK) | script | pending |
| 2.38 | OPS | Device wire / bridge scripts (optional port) | script | pending |
| 2.39 | OPS | systemd drift timer optional | docs | pending |
| 2.40 | OPS | Cursor hooks (session bootstrap, stop guard) | .cursor | pending |
| 2.41 | OPS | Gemini / Copilot entry points | files | pending |
| 2.42 | OPS | Enforcement: lane_preflight note for home | home | pending |
| 2.43 | OPS | Forbidden cross-lane edits list | AGENTS | pending |
| 2.44 | OPS | verify-all includes security unit tests | script | pending |
| 2.45 | OPS | Burn-in bootstrap | script | pending |
| 2.46 | OPS | Handoff update script | script | pending |
| 2.47 | OPS | Agency milestone checklist | doc | pending |
| 2.48 | OPS | Operator training one-pager | docs | pending |
| **2.49** | — | **Agency closed** | 2.26–2.48 | pending |

### 2.50 Widget & phoenixforge-data PF5

| Step | Area | Deliverable | Verification | Status |
|------|------|-------------|--------------|--------|
| **2.50** | — | **MILESTONE: Widget & data** | — | pending |
| 2.51 | DATA | PF5 db name `pf5_schooling.db` via data module | code | pending |
| 2.52 | DATA | Catalog provider registration policy | docs | pending |
| 2.53 | DATA | Vector/blob hooks for curriculum search (optional) | ADR | pending |
| 2.54 | WIDGET | Today’s quest widget (Glance) | UI | pending |
| 2.55 | WIDGET | Steward day summary widget | UI | pending |
| 2.56 | WIDGET | Theme tokens from phoenixforge-theme | UI | pending |
| 2.57 | DATA | Migration from Room backbone ↔ PF5 catalog | ADR | pending |
| 2.58 | DATA | Privacy: catalog excludes PROTECTED | unit | pending |
| 2.59 | WIDGET | Widget update on event ingest | manual | pending |
| 2.60 | DATA | Content hash policy registry file | registry | pending |
| 2.61 | DATA | Evidence for data module wiring | evidence | pending |
| 2.62 | WIDGET | Widget permissions/docs | docs | pending |
| 2.63 | DATA | Offline-first data path documented | docs | pending |
| 2.64 | DATA | Backup interaction with PF5 | docs | pending |
| 2.65 | DATA | Performance baseline queries | test | pending |
| 2.66 | WIDGET | Multi-profile widget config | UI | pending |
| 2.67 | DATA | Index keys for CallableVariableIndex | yaml | pending |
| 2.68 | DATA | Failure modes: catalog unavailable | unit | pending |
| 2.69 | DATA | Milestone checklist | doc | pending |
| 2.70 | DATA | Optional: omide hub catalog consume | evidence | pending |
| 2.71 | WIDGET | Optional: pin widget tutorial | docs | pending |
| 2.72 | DATA | Schema export | file | pending |
| 2.73 | DATA | Closed | tests | pending |
| **2.74** | — | **Widget & data closed** | 2.51–2.73 | pending |

### 2.75 Content & curriculum depth

| Step | Area | Deliverable | Verification | Status |
|------|------|-------------|--------------|--------|
| **2.75** | — | **MILESTONE: Content** | — | pending |
| 2.76 | CUR | Port curriculum domain catalog | unit | pending |
| 2.77 | CUR | Port subdomain catalog | unit | pending |
| 2.78 | CUR | Starter lessons pack 01 | content | pending |
| 2.79 | CUR | Field guide defaults | content | pending |
| 2.80 | CUR | Master reminder library | content | pending |
| 2.81 | CUR | Quest tag catalog | unit | pending |
| 2.82 | CUR | Gold-standard quests import path | script | pending |
| 2.83 | CUR | Intent tile contract compliance | unit | pending |
| 2.84 | CUR | Memory event contract compliance | unit | pending |
| 2.85 | CUR | Tile–event mapping docs | docs | pending |
| 2.86 | CUR | Inclusive learning supports notes | docs | pending |
| 2.87 | CUR | Childhood compass read-model | docs | pending |
| 2.88 | CUR | Pack coverage map | docs | pending |
| 2.89 | CUR | Sage persona + knowledge base | unit | pending |
| 2.90 | CUR | Content versioning | yaml | pending |
| 2.91 | CUR | Content validation script | script | pending |
| 2.92 | CUR | Localization hooks (future) | docs | pending |
| 2.93 | CUR | Content closed checklist | doc | pending |
| **2.99** | — | **Content closed** | 2.76–2.93 | pending |

### 3.00 Memory & identity depth

| Step | Area | Deliverable | Verification | Status |
|------|------|-------------|--------------|--------|
| **3.00** | — | **MILESTONE: Memory & identity** | — | pending |
| 3.01 | ID | Avatar studio UI (steward + child scoped) | UI | pending |
| 3.02 | ID | Identity card / about-me | UI | pending |
| 3.03 | ID | Childhood timeline UI | UI | pending |
| 3.04 | ID | Memory capsule capture (photo/audio) | UI | pending |
| 3.05 | ID | Dreams board steward+child | UI | pending |
| 3.06 | ID | Identity snapshots / history | unit | pending |
| 3.07 | ID | Linked students list (steward) | UI | pending |
| 3.08 | ID | Export push bundle for World | unit | pending |
| 3.09 | ID | Import policies by role | unit | pending |
| 3.10 | ID | Artifact checksum verification | unit | pending |
| 3.11 | ID | Camera/mic permission UX | UI | pending |
| 3.12 | ID | FileProvider paths (export only, not memories public) | manifest | pending |
| 3.13 | ID | Human memory preservation docs adapted | docs | pending |
| 3.14 | ID | Time capsule hooks (spec only if not built) | docs | pending |
| 3.15 | ID | Age-25 backcast design reference | docs | pending |
| 3.16 | ID | Family legacy system reference | docs | pending |
| 3.17 | ID | Closed | checklist | pending |
| **3.24** | — | **Memory & identity closed** | 3.01–3.17 | pending |

### 3.25 Chariot & car

| Step | Area | Deliverable | Verification | Status |
|------|------|-------------|--------------|--------|
| **3.25** | — | **MILESTONE: Chariot** | — | pending |
| 3.26 | CAR | Chariot models + stack loader | unit | pending |
| 3.27 | CAR | Deep link hardening | unit | pending |
| 3.28 | CAR | Display activity UI | UI | pending |
| 3.29 | CAR | Export from steward board | unit | pending |
| 3.30 | CAR | adb helper script | script | pending |
| 3.31 | CAR | Audio path map reference | shared | pending |
| 3.32 | CAR | Sessions salvage validation | script | pending |
| 3.33 | CAR | Closed | checklist | pending |
| **3.49** | — | **Chariot closed** | 3.26–3.33 | pending |

### 3.50 Reliability & performance

| Step | Area | Deliverable | Verification | Status |
|------|------|-------------|--------------|--------|
| **3.50** | — | **MILESTONE: Reliability** | — | pending |
| 3.51 | REL | Remove runBlocking from binder/HTTP where possible | code review | pending |
| 3.52 | REL | Explicit timeouts on all OkHttp clients | code | pending |
| 3.53 | REL | Circuit breaker for Sage | unit | pending |
| 3.54 | REL | FileObserver reliability (message vs EVT filters) | unit | pending |
| 3.55 | REL | WorkManager for compaction | unit | pending |
| 3.56 | REL | DB migration tests | unit | pending |
| 3.57 | REL | ANR watch: main-thread policy | docs | pending |
| 3.58 | REL | Backpressure on ingest | unit | pending |
| 3.59 | REL | Degrade mode offline UI banners | UI | pending |
| 3.60 | REL | Idempotent push/pull | unit | pending |
| 3.61 | REL | Crash reporting gated by consent | code | pending |
| 3.62 | REL | Load test synthetic events | script | pending |
| 3.63 | REL | Closed | checklist | pending |
| **3.74** | — | **Reliability closed** | 3.51–3.63 | pending |

### 3.75 Observability

| Step | Area | Deliverable | Verification | Status |
|------|------|-------------|--------------|--------|
| **3.75** | — | **MILESTONE: Observability** | — | pending |
| 3.76 | OBS | TelemetryGate integration | unit | pending |
| 3.77 | OBS | Structured logs (no PII) | code | pending |
| 3.78 | OBS | Health endpoints (local) optional | code | pending |
| 3.79 | OBS | Evidence JSONL for critical smokes | evidence | pending |
| 3.80 | OBS | Agency turn scores | scripts | pending |
| 3.81 | OBS | Datadog optional behind env + consent | code | pending |
| 3.82 | OBS | Debug screen (steward only) | UI | pending |
| 3.83 | OBS | Closed | checklist | pending |
| **3.99** | — | **Observability closed** | 3.76–3.83 | pending |

### 4.00 Hardening

| Step | Area | Deliverable | Verification | Status |
|------|------|-------------|--------------|--------|
| **4.00** | — | **MILESTONE: Hardening** | — | pending |
| 4.01 | HARD | Full security regression suite | test | pending |
| 4.02 | HARD | Minify release build | assembleRelease | pending |
| 4.03 | HARD | Backup rules final | manifest | pending |
| 4.04 | HARD | Permission minimalism review | doc | pending |
| 4.05 | HARD | Red-team mesh exercise | evidence | pending |
| 4.06 | HARD | Accessibility WCAG-ish pass | manual | pending |
| 4.07 | HARD | Large font / landscape | manual | pending |
| 4.08 | HARD | Low storage behavior | manual | pending |
| 4.09 | HARD | Airplane mode full loop | manual | pending |
| 4.10 | HARD | Multi-user Android edge cases | doc | pending |
| 4.11 | HARD | Play integrity optional | ADR | pending |
| 4.12 | HARD | Dependency CVE scan note | docs | pending |
| 4.13 | HARD | Secrets never in repo | grep | pending |
| 4.14 | HARD | Closed | checklist | pending |
| **4.49** | — | **Hardening closed** | 4.01–4.14 | pending |

### 4.50 Cutover & decommission

| Step | Area | Deliverable | Verification | Status |
|------|------|-------------|--------------|--------|
| **4.50** | — | **MILESTONE: Cutover** | — | pending |
| 4.51 | CUT | Data import from old classroom packages (optional tool) | script | pending |
| 4.52 | CUT | Install schooling on Ezra tablet both roles | adb | pending |
| 4.53 | CUT | Install on steward phone | adb | pending |
| 4.54 | CUT | Parallel run week with classroom APKs | operator | pending |
| 4.55 | CUT | Switch default install scripts to schooling | scripts | pending |
| 4.56 | CUT | Update home suite_manifest + workspace | home | pending |
| 4.57 | CUT | Kit registry: schooling active; classroom superseded | kit | pending |
| 4.58 | CUT | Document decommission of 3 classroom APKs | docs | pending |
| 4.59 | CUT | Keep classroom git archive read-only | note | pending |
| 4.60 | CUT | Final verify-all PASS | script | pending |
| 4.61 | CUT | Operator sign-off | evidence | pending |
| 4.62 | CUT | Celebrate dual-interface ship | — | pending |
| 4.91 | Cross | *(gap)* | — | reserved |
| 4.92 | Cross | *(gap)* | — | reserved |
| **5.00** | — | **MILESTONE: Repo 100% complete** | census + drift + device | pending |

---

## Capability absorption matrix (from classroom)

| Classroom capability domain | Schooling target | Priority |
|----------------------------|------------------|----------|
| Forge Profile identity / avatar / timeline / memories | backbone + UI both faces | P0 |
| Event pipeline EVT_ / public_state | backbone | P0 |
| LAN :7433 + mDNS (secure redesign) | backbone/network | P0 |
| Teacher expedition / plan / curriculum / sage | teacher/ | P0 |
| Student hearth / quests / vault / companions | student/ | P0 |
| forge-sync-client | backbone/sync | P0 |
| Chariot | student + steward export | P1 |
| Agency scripts / verify / routing | scripts + registry | P1 |
| Quest ledger | scripts | P1 |
| LiveMessageChannel | app channel service | P1 |
| Widget / PF5 data | widget + data modules | P2 |
| World embed Godot | future (not this finish) | P3 |

Full class map: port ownership tables from  
`../phoenix-forge-classroom/docs/REARCHITECTURE_PHASE4_OWNERSHIP.md` into `docs/architecture/CAPABILITY_MAP.md` (step 0.12).

---

## Enforcement surface

| Mechanism | Location |
|-----------|----------|
| Cline Essence | `docs/cline_essence/*` |
| Drift check | `scripts/cline-essence-drift-check.sh` |
| Verify-all | `scripts/schooling-verify-all.sh` |
| Tier 0 registry | `registry/phoenix-forge-schooling.yaml` |
| Signature permissions | app manifest |
| EventScope role matrix | backbone |
| Mesh pairing required | backbone/network |
| Agent forbidden actions | AGENTS.md + registry |
| Evidence-only PASS claims | `registry/evidence/` |

---

## Tradeoff scorecard (workspace choice)

| Option | Intent | Evidence | Risk | Cost | Reversibility | Decision |
|--------|--------|----------|------|------|---------------|----------|
| New `phoenix-forge-schooling` repo | 5 | 5 | 2 | 3 | 5 | **Chosen** — clean greenfield, classroom remains archive |
| Continue only in classroom `phoenixforge_classroom/` | 4 | 5 | 3 | 4 | 3 | Parallel plan retained as source; product home is schooling |
| Keep 3 APKs forever | 1 | 5 | 4 | 2 | 2 | Rejected |

---

## Residual risks

| Residual | Mitigation |
|----------|------------|
| Shared FS still unauthenticated for Godot | Trusted devices; later MAC |
| Assemble may need SDK/local.properties on first day | Document; PARTIAL allowed for scaffold |
| Large port surface (~340 Kotlin files) | Security-first backbone; incremental modules |
| Suite peers LiveMessageChannel not wired | File contract remains |

---

## At `5.00`

- All required steps `[VERIFIED]` or `[TESTED]`
- Single APK dual-interface in daily use
- Classroom 3-APK decommissioned from devices
- Kit registry shows schooling `active`
- Security regression suite green
- Agency verify-all PASS without false greens
