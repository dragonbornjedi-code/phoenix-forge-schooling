# Package 01 — SchoolingDatabase Architecture Review

**Status:** Implementation-ready design  
**Master steps:** 0.51–0.55, 0.73, 3.06–3.07  
**Depends on:** Package 00 ownership  
**Blocks:** Packages 02 (profiles), 03 (events), repositories  

---

## 1. FAILURE & SECURITY AUDIT

| ID | Type | Scenario | Severity | Mitigation |
|----|------|----------|----------|------------|
| DB-01 | Migration wipe | `fallbackToDestructiveMigration` loses childhood data | P0 | Versioned migrations; exportSchema=true; no destructive in release |
| DB-02 | Dual DB open | ContentProvider builds second Room | P0 | Single Hilt `@Singleton` SchoolingDatabase |
| DB-03 | Cleartext backup | Classroom wrote Room JSON to /sdcard | P0 | BackupCoordinator private encrypted only (Package 04/backup) |
| DB-04 | PROTECTED leak via DAO | Child UI queries teacher notes | P0 | Repository filters by Role; no raw DAO in student UI |
| DB-05 | TOCTOU role check | Role changes mid-query | P1 | Pass `SchoolingRole` into every write; SessionStore snapshot |
| DB-06 | Schema explosion | Merge 3 classroom DBs without plan | P1 | Single v1 schema; phased entities |
| DB-07 | Threading | Main-thread queries | P1 | Room `Dispatchers.IO`; disallow main queries in debug |
| DB-08 | ID collision | Non-UUID primary keys | P2 | RFC UUID for profile/event IDs |
| DB-09 | Orphan FKs | Delete profile leaves events | P2 | Cascade policy documented |
| DB-10 | Compile dep | Room + kapt version skew | P2 | Kit-aligned versions |
| DB-11 | Memory | Loading full event history | P2 | Paged queries; limits on projectors |
| DB-12 | Encryption at rest | Device unlock dump | P3 | SQLCipher future ADR; not v1 required if backup private |

### Black swans

- Disk full mid-transaction → incomplete public_state; use transactions + fsync patterns carefully.  
- Multi-process (unlikely) → disable multi-instance; one process only.  
- Restoring encrypted backup with wrong key → fail closed, never partial apply.

---

## 2. SYSTEM DESIGN

### 2.1 Package tree

```
com.phoenixforge.schooling.backbone.database
  SchoolingDatabase.kt
  Converters.kt
  entity/
    ProfileEntity.kt
    AvatarEntity.kt
    TimelineEventEntity.kt
    MemoryArtifactEntity.kt
    AboutMeEntity.kt
    DreamEntity.kt
    LinkedStudentEntity.kt
    EventRecordEntity.kt
    MessageEntity.kt
    PeerDeviceEntity.kt          # mesh pairing
    SessionMetaEntity.kt         # optional
  dao/
    ProfileDao.kt
    EventRecordDao.kt
    MessageDao.kt
    PeerDeviceDao.kt
    LinkedStudentDao.kt
  migration/
    MIGRATION_1_2.kt …
  repository/
    ProfileRepository.kt
    EventRepository.kt
    MessageRepository.kt
    PeerDeviceRepository.kt
```

### 2.2 Schema v1 (logical)

| Table | Key columns | Owner face | Notes |
|-------|-------------|------------|-------|
| profiles | uid PK UUID, forge_name, role, age_years, … | both | role: STEWARD/CHILD/STUDENT_SELF |
| avatars | id, profile_uid FK, config_json | both | |
| timeline_events | id, profile_uid, type, epoch_ms | both | derived + manual |
| memory_artifacts | id, profile_uid, type, path, checksum | steward primary | app-private paths only |
| about_me / dreams / favorites | profile_uid | steward | |
| linked_students | profile_uid, display_name | steward | |
| event_records | event_id PK, student_uid, scope, type, logical_clock, payload_json, actor_* | pipeline | disk mirror of EVT_ |
| messages | message_id PK, to_student_uid, body, direction | both | |
| peer_devices | device_id PK, token_hash, last_seen, allowed | mesh | **no plaintext tokens** |

**DB name:** `schooling.db` (app-private).  

### SchoolingDatabase ownership boundary (ADR-008)

```
SchoolingDatabase
        │ owns
        ▼
Operational state (profiles, events, messages, peers, local timeline)

NOT Global catalog
NOT Shared vectors
NOT Cross-app search
NOT Phone-wide PF5 ContentProvider corpus
```

**PF5** (`phoenixforge-data`, path `/var/lib/phoenix-ai/workspace/phoenixforge-data`, coord `com.phoenixforge:data`):  
`pf5_schooling.db` only when Index `schooling.data.pf5.enabled=true` (roadmap **2.50+**). No PROTECTED rows in catalog.

### 2.3 Class diagram (text)

```
SchoolingDatabase
  ├── ProfileDao ──► ProfileRepository ──► RoleManager (read role)
  ├── EventRecordDao ──► EventRepository ──► EventWriter / EventIngester
  ├── MessageDao ──► MessageRepository
  └── PeerDeviceDao ──► DeviceRegistry (Package 04)
```

### 2.4 Thread model

| Work | Dispatcher |
|------|------------|
| DAO suspend | Room default IO |
| Migrations | Room open (blocking once) — Application startup, not Activity |
| Backup | IO + single-flight mutex |

### 2.5 Lifecycle

```
App start → Hilt provides SchoolingDatabase
  → if empty && private backup exists → BackupCoordinator.restore (encrypted)
  → ProfileRepository.ensureBootstrapProfiles()
```

### 2.6 Recovery strategy

| Failure | Recovery |
|---------|----------|
| Corrupt DB | Room open fails → operator wipe + encrypted restore |
| Migration fail | Abort open; log; do not destructive-fallback in release |
| Partial write | Transactions on multi-table mutations |

### 2.7 Entity ownership vs classroom

Port from `ProfileDatabase` v10 entities, **rename packages**, drop `exportSchema=false` → **true**.  
Do not open teacher-app / student-app separate DBs.

### 2.8 Security of repositories

```kotlin
// Pseudocode law
suspend fun listProtectedNotes(role: SchoolingRole): List<…> {
  require(role == SchoolingRole.STEWARD) { "PROTECTED" }
  …
}
```

---

## 3. VERIFICATION

```bash
./gradlew :backbone:kaptDebugKotlin
./gradlew :backbone:testDebugUnitTest --tests '*database*'
# Schema export present:
test -d backbone/schemas || test -d backbone/src/main/schemas
```

| Test | Asserts |
|------|---------|
| Migration smoke | 1→1 empty OK |
| Profile CRUD | insert/get |
| Event unique event_id | conflict ignored / upsert policy |
| Steward-only query | throws or empty for CHILD |
| No main-thread | StrictMode in debug |

Evidence: compile log, test log → `…/package-01/`

---

## 4. IMPLEMENTATION PROMPT

See [prompts/IMPLEMENT.md](prompts/IMPLEMENT.md).

---

## 5. ACCEPTANCE CRITERIA

- [ ] Single `SchoolingDatabase` Hilt singleton  
- [ ] exportSchema true  
- [ ] No `fallbackToDestructiveMigration()` in release build type  
- [ ] Peer tokens stored hashed only  
- [ ] Unit tests green  
- [ ] No git operations by implementer  
