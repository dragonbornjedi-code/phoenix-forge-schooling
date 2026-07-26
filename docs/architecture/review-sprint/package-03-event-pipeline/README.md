# Package 03 — Event Pipeline Architecture Review

**Status:** Implementation-ready design  
**Master steps:** 0.45, 0.56–0.63, 1.51–1.53, 1.61  
**Depends on:** Package 01 (EventRecordEntity), Package 02 (PermissionMatrix)  
**Blocks:** Projectors, LAN event GET, Godot loop  
**Frozen wire:** classroom `ForgeEventRecord` schemaVersion=1 (Godot)

---

## 1. FAILURE & SECURITY AUDIT

| ID | Type | Scenario | Severity | Mitigation |
|----|------|----------|----------|------------|
| EV-01 | Authz | CHILD writes PROTECTED | P0 | PermissionMatrix + EventScope.childMayWrite |
| EV-02 | Authz | Untrusted FS injects PROTECTED into Room | P0 | Ingester **drops** PROTECTED from disk (classroom behavior keep) |
| EV-03 | Integrity | Malicious EVT_ on shared storage | P1 | Schema validate; quarantine; optional MAC later |
| EV-04 | Race | Dual writers same eventId | P1 | Unique PK; idempotent ingest |
| EV-05 | Clock | Device clock skew | P1 | logicalClock Lamport + epochMs |
| EV-06 | DoS | Huge payload JSON | P1 | Max payload size; reject |
| EV-07 | Godot break | Change field names | P0 | Contract tests golden JSON |
| EV-08 | Path traversal | studentUid `../` | P0 | RFC UUID + PublicSyncWriter jail (Package 05/sync) |
| EV-09 | TOCTOU | Scope check then role changes | P1 | Capture SessionSnapshot at call entry |
| EV-10 | Memory | Load all events | P2 | Paging; projector limits |
| EV-11 | FileObserver miss | MSG vs EVT filter bug (classroom) | P1 | Separate watchers or correct filter |
| EV-12 | Duplicate bus | In-process + disk diverge | P2 | Write path: DB then disk; emit kit event after commit |
| EV-13 | Actor spoof | actorApp forged on disk | P1 | Display provenance; LAN requires pairing (04) |
| EV-14 | Main-thread | Writer on UI | P1 | suspend + IO |

### Black swans

- Half-written EVT_ file observed by watcher → parse fail → quarantine dir  
- Logical clock reset after reinstall → accept with device epoch fence  
- Syncthing conflict copies → both versions; last-writer by logicalClock

---

## 2. SYSTEM DESIGN

### 2.1 Package tree

```
backbone/events/
  EventScope.kt                 # exists; align with wire names
  EventIdFactory.kt
  LogicalClock.kt
  EventWriter.kt
  EventIngester.kt
  ForgeEventWire.kt             # kotlinx serialization = Godot schema
  contract/
    EventContractValidator.kt
  projector/
    StateProjector.kt           # → public_state.json via SyncTransport
    TimelineProjector.kt
  quarantine/
    QuarantineStore.kt
```

### 2.2 Wire format (frozen Godot + per-event version)

```json
{
  "schemaVersion": 1,
  "eventVersion": 1,
  "eventId": "EVT_… or uuid",
  "eventType": "QUEST_COMPLETED",
  "scope": "PUBLIC",
  "actorApp": "phoenixforge_schooling",
  "actorDeviceId": "<device>",
  "studentUid": "<uuid>",
  "logicalClock": 42,
  "epochMs": 1710000000000,
  "payload": { }
}
```

| Field | Rule |
|-------|------|
| `schemaVersion` | Global envelope; **frozen at 1** for Godot (ADR-005). Bump only with World lockstep. |
| `eventVersion` | **Per eventType** evolution. Changing QUEST_COMPLETED payload shape → bump `eventVersion` for that type only. Unknown eventVersion → quarantine or ignore-forward-compatible fields. |

**actorApp** from Index `schooling.sync.actor_app_id`, never hardcoded package string in call sites.

**Transport:** EventWriter depends on **`TransportPort`** only (ADR-003), never `File`/`LanHttpServer`/`LiveMessageChannel` concrete types.

### 2.3 EventWriter algorithm

```
write(type, scope, studentUid, payload, session: SessionSnapshot):
  1. require PermissionMatrix.canWrite(session.role, scope)
  2. require UUID(studentUid)
  3. eventId = EventIdFactory.next()
  4. logicalClock = LogicalClock.tick()
  5. record = wire(...)
  6. EventRepository.insert(record)          // transaction
  7. SyncTransport.publishEvent(record)      // file and/or live
  8. PhoenixForgeEventBus.emit(domainEvent)
  9. return eventId
```

### 2.4 EventIngester algorithm

```
onFile(path):
  1. read ≤ maxBytes
  2. parse JSON; on fail → quarantine
  3. validate schemaVersion==1, UUID studentUid, known scope
  4. if scope==PROTECTED → drop (do not ingest from FS)
  5. upsert by eventId (idempotent)
  6. TimelineProjector.apply if needed
  7. StateProjector.maybeRewritePublicState(studentUid)
```

### 2.5 Scope law (aligned classroom + schooling roles)

| Scope | Child write | Child read | Steward write | Disk ingest |
|-------|-------------|------------|---------------|-------------|
| PUBLIC | yes | yes | yes | yes |
| LESSON | no* | yes | yes | yes |
| PROTECTED | no | no | yes (unlocked) | **no** |

\*Classroom studentMayWrite allowed LESSON for some actors; **Schooling CHILD write PUBLIC only** (stricter, Constitution). Steward may write LESSON.

### 2.6 Sequence: quest complete (child)

```
UI → QuestEngine.complete
  → EventWriter(scope=PUBLIC, type=QUEST_COMPLETED)
  → DB + FileContractTransport
  → StateProjector updates public_state.json
  → Godot reads file
```

### 2.7 Thread ownership (no sync cross-boundary calls)

```
FileObserver / NIO watch (callback thread)
        │ enqueue only (never call DB here)
        ▼
Ingest Queue  (CoroutineScope IO, limitedParallelism=2)
        │
        ▼
EventIngester → EventRepository (Room)
        │ enqueue projector job
        ▼
Projector Queue (IO, limitedParallelism=1 per studentUid)
        │
        ▼
State Writer (public_state / timeline) via TransportPort
```

| Component | Thread / queue | May call |
|-----------|----------------|----------|
| EventWriter | caller suspend → IO | Repository, TransportPort, Bus.emit |
| FileObserver | platform callback | **Only** offer to Ingest Queue |
| Ingest Queue | IO limited | Ingester, Repository |
| Projector Queue | IO single-flight | StateProjector, TransportPort |
| UI | Main | EventWriter suspend only |

**Forbidden:** FileObserver → Room on observer thread; Projector → network on Main; bidirectional sync waits between queues.

### 2.8 Race condition audit

| Race | Resolution |
|------|------------|
| Writer + Ingester same id | Unique constraint; second is no-op |
| Projector mid-write | Transaction snapshot read |
| Watcher storm | Debounce 100–250ms coalesce |

### 2.9 Class diagram

```
EventWriter ── PermissionMatrix
     │
     ├── EventIdFactory
     ├── LogicalClock
     ├── EventRepository
     └── TransportPort ── FileContractTransport
                      └── LiveEnvelopeTransport (optional)

EventIngester ── EventContractValidator
     │
     ├── QuarantineStore
     ├── EventRepository
     └── StateProjector / TimelineProjector
```

### 2.10 Kit boundary

- **Do not** replace `PhoenixForgeEventBus`.  
- Domain events implement `PhoenixForgeEvent` for in-app observers.  
- Disk format remains ForgeEventRecord-compatible for Godot.

---

## 3. VERIFICATION

```bash
./gradlew :backbone:testDebugUnitTest --tests '*events*'
# Golden:
# fixtures/evt_quest_completed.json parses + roundtrips
```

| Test | Assert |
|------|--------|
| Child cannot write PROTECTED | throws |
| Child cannot write LESSON | throws |
| Ingest PROTECTED dropped | not in DB |
| Idempotent ingest | count=1 |
| Path UUID reject | fail |
| Payload oversize | fail |
| Golden Godot sample | equals fields |

Evidence → `…/package-03/`

---

## 4. IMPLEMENTATION PROMPT

See [prompts/IMPLEMENT.md](prompts/IMPLEMENT.md).

---

## 5. ACCEPTANCE CRITERIA

- [ ] Wire format schemaVersion=1 compatible  
- [ ] Scope matrix unit tests  
- [ ] SyncTransport used (no direct File in Writer)  
- [ ] Quarantine on corrupt  
- [ ] No git ops by implementer  
