# Package 05 — LanHttpServer Security Architecture

**Status:** Implementation-ready design  
**Master steps:** 0.27–0.28, 0.33–0.35, 0.40, 0.64, 1.87–1.89  
**Depends on:** Package 04 MeshAuth (hard), Package 03 Event projectors, Package 02 Consent for export  
**Classroom anti-pattern:** `ForgeProfileSyncServer` open routes — **do not port**

---

## 1. FAILURE & SECURITY AUDIT

| ID | Type | Scenario | Severity | Mitigation |
|----|------|----------|----------|------------|
| H-01 | Unauth export | GET /profile/export open | P0 | MeshAuth mandatory |
| H-02 | Unauth mutation | POST link/manifest/messages | P0 | MeshAuth + steward capability where needed |
| H-03 | Info leak ping | activeProfileUid public | P1 | Public ping: schema + port only; no UID |
| H-04 | DoS body | Multi-MB POST | P1 | body max from Index |
| H-05 | Path traversal | studentUid / artifactId | P0 | UUID regex + path containment |
| H-06 | runBlocking | Deadlock under load | P2 | suspend serve via coroutines or bounded executor |
| H-07 | Consent race | Concurrent export | P2 | single pending consent |
| H-08 | Rate flood | Ping storm | P2 | RateLimiter per IP |
| H-09 | Cleartext | LAN sniff | P1 | Document; private Wi‑Fi; TLS ADR |
| H-10 | Bind all ifaces | Cellular exposure | P1 | bind mode Index: paired network / loopback debug |
| H-11 | Weak UUID | 36-char junk | P1 | RFC UUID |
| H-12 | Audit log PII | Log bodies | P1 | Redact; log route+code+deviceId only |
| H-13 | Method abuse | TRACE/DELETE | P2 | Allow GET/POST only |
| H-14 | Version drift | Unknown path | P2 | 404; no stack traces |

### Black swans

- NanoHTTPD thread pool exhaustion → global rate limit + 503  
- Consent UI not foreground → timeout fail closed  
- Token valid but studentUid not linked to peer → 403  

---

## 2. SYSTEM DESIGN

### 2.1 Package tree

```
backbone/network/
  LanHttpServer.kt
  LanApiRoutes.kt
  middleware/
    AuthMiddleware.kt
    RateLimitMiddleware.kt
    BodyLimitMiddleware.kt
    AuditMiddleware.kt
  handlers/
    PingHandler.kt
    PairCompleteHandler.kt
    ProfileExportHandler.kt
    EventsHandler.kt
    MessagesHandler.kt
    ManifestInboundHandler.kt
    LinkStudentHandler.kt
  client/
    LanHttpClient.kt           # directed only
```

### 2.2 Route table (v1)

| Method | Path | Auth | Extra | Handler |
|--------|------|------|-------|---------|
| GET | `/api/v1/ping` | none | public fields only | Ping |
| POST | `/api/v1/pair/complete` | pending pair token | | PairComplete |
| GET | `/api/v1/profile/export` | MeshAuth | ConsentManager | Export |
| GET | `/api/v1/profiles/list` | MeshAuth | | List |
| GET | `/api/v1/events/{uid}` | MeshAuth | uid linked | Events |
| GET | `/api/v1/messages/{uid}` | MeshAuth | | Messages GET |
| POST | `/api/v1/messages/{uid}` | MeshAuth | path=body uid | Messages POST |
| POST | `/api/v1/inbound/manifest` | MeshAuth | | Manifest |
| POST | `/api/v1/link-student` | MeshAuth + steward device | | Link |
| POST | `/api/v1/sync/request` | MeshAuth | Consent | SyncRequest |

All others → 404.

### 2.3 Middleware pipeline

```
Request
  → Audit (start)
  → Method allowlist
  → BodyLimit
  → RateLimit(ip)
  → Auth (unless public ping / pair pending)
  → Handler
  → Audit (status)
```

### 2.4 ACL

| Route | Peer must |
|-------|-----------|
| events/messages for uid | DeviceRegistry.peerLinkedTo(uid) OR steward peer role |
| link-student | peer.role == STEWARD_DEVICE |
| export | any paired + human consent |

### 2.5 Path containment (shared util)

```kotlin
fun requireUuid(s: String): String {
  require(RFC_UUID.matches(s))
  return s
}
fun safeJoin(root: File, relative: String): File {
  // reject .. and absolute; canonical under root
}
```

### 2.6 Sequence: POST message

```
Client POST /api/v1/messages/{uid} Bearer+DeviceId
  → Auth OK
  → requireUuid(uid)
  → parse body ≤ max
  → uid == body.toStudentUid
  → MessageRepository + SyncTransport
  → 201 { status }
```

### 2.7 Thread model

| Piece | Model |
|-------|-------|
| NanoHTTPD | dedicated threads; handlers call `runBlocking` **forbidden** if can use suspend bridge |
| Preferred | Queue work to CoroutineScope(IO).limitedParallelism(4) |
| Consent | suspend with timeout from Index |

### 2.8 Class diagram

```
LanHttpServer
  ├── MeshAuth
  ├── RateLimiter
  ├── ConsentManager
  ├── handlers → EventRepository / ProfileExporter / ProfileFanout
  └── AuditLogger
```

### 2.9 Lifecycle

```
Session STEWARD unlocked + mesh enabled
  → LanHttpServer.start(port from Index)
  → NsdRegistrar.start
App background optional stop
Pairing revoke does not require restart
```

### 2.10 Client law

`LanHttpClient` only accepts host from DeviceRegistry (or loopback). No free-form host from UI without confirmation.

### 2.11 Recovery

| Failure | Behavior |
|---------|----------|
| Port in use | Log; retry alternate from Index list |
| Auth fail | 401; increment rate |
| Handler exception | 500 generic; audit error id |

---

## 3. VERIFICATION

```bash
./gradlew :backbone:testDebugUnitTest --tests '*LanHttp*' --tests '*MeshAuth*'
# Manual smoke (paired lab only):
# curl -H "Authorization: Bearer $T" -H "X-Device-Id: $D" http://127.0.0.1:7433/api/v1/ping
# unauth export must 401
```

| Test | Assert |
|------|--------|
| Unauth export | 401 |
| Auth export | 200 or consent path |
| Body oversize | 413/400 |
| Bad UUID | 400 |
| Rate limit | 429 |
| Public ping no uid field | json absent |
| Path traversal uid | 400 |

Security regression checklist file in evidence.

Evidence → `…/package-05/`

---

## 4. IMPLEMENTATION PROMPT

See [prompts/IMPLEMENT.md](prompts/IMPLEMENT.md).

---

## 5. ACCEPTANCE CRITERIA

- [ ] Default-deny: every sensitive route uses MeshAuth  
- [ ] Public ping does not leak activeProfileUid  
- [ ] Body limit + rate limit  
- [ ] UUID + path containment  
- [ ] Unit tests for unauth 401  
- [ ] No classroom open-server copy  
- [ ] No git ops by implementer  

---

## 6. SECURITY REGRESSION CHECKLIST (copy to evidence)

```
[ ] Unauthenticated GET /api/v1/profile/export → 401
[ ] Unauthenticated POST /api/v1/link-student → 401
[ ] Unauthenticated POST /api/v1/inbound/manifest → 401
[ ] Unauthenticated GET /api/v1/events/{uuid} → 401
[ ] Valid token + wrong deviceId → 401
[ ] Revoked token → 401
[ ] Body > schooling.security.body_max_bytes → reject
[ ] studentUid with .. → 400
[ ] GET /api/v1/ping has no activeProfileUid
[ ] No fan-out client helper in codebase (rg discoverPeers)
[ ] Tokens not present in Logcat during pair (manual)
```
