# Package 04 — Mesh Pairing Security Review

**Status:** Implementation-ready design (trust anchor)  
**Master steps:** 0.26–0.30, 0.43, 1.76–1.93  
**Depends on:** Package 01 PeerDeviceEntity, Package 02 StewardGate  
**Blocks:** Package 05 LanHttpServer (all authenticated routes)

---

## 1. FAILURE & SECURITY AUDIT

| ID | Type | Scenario | Severity | Mitigation |
|----|------|----------|----------|------------|
| M-01 | Missing auth | Any LAN client hits export | P0 | No route without Bearer pairing token (Package 05) |
| M-02 | Fan-out | Push to all mDNS peers | P0 | Directed delivery to linked DeviceRegistry hosts only |
| M-03 | mDNS spoof | Fake `_http._tcp` service | P0 | Service type `_phoenixforge._tcp` + TXT token challenge |
| M-04 | Replay | Capture Bearer, reuse | P0 | Token + deviceId bind; optional nonce window; rotate TTL |
| M-05 | Token theft | Logcat / backup | P0 | Store **hash** only; show secret once at pair |
| M-06 | MITM cleartext | HTTP on Wi‑Fi | P1 | Pairing on local only; prefer Tailscale; TLS future ADR |
| M-07 | Token brute force | Guess Bearer | P1 | 256-bit random; rate limit 429 |
| M-08 | Stale peer | Device leaves, token remains | P1 | Revoke API; last_seen expiry |
| M-09 | Stewardless pair | Child initiates mesh admin | P0 | Pairing requires StewardGate unlocked |
| M-10 | Race dual pair | Two stewards pair same time | P2 | Mutex on TokenStore |
| M-11 | DoS pair UX | Flood pair requests | P2 | Rate limit + single pending consent |
| M-12 | Hardcoded UID/IP | Classroom Ezra + 192.168.1.19 | P0 design | Forbidden in release |
| M-13 | Discovery noise | Scan /24 | P2 | Optional, rate-limited, Index flag |
| M-14 | Live channel confusion | Claim e2e early | P1 | LiveEnvelopeTransport separate status |

### Black swans

- Guest joins home Wi‑Fi during pair window → short QR TTL (120s)  
- Token written to Syncthing folder → never write tokens to public FS  
- Clock rollback extends TTL → use monotonic elapsedRealtime for local TTL

---

## 2. SYSTEM DESIGN

### 2.1 Trust model

```
Paired peer ⇔ holds bearer secret S
Server stores H = SHA-256(S || deviceId || salt)
Request: Authorization: Bearer S + X-Device-Id: D
Accept iff H matches row for D and not revoked and not expired
```

Optional v2: mutual challenge nonce (HMAC).

### 2.2 Package tree

```
backbone/network/
  pairing/
    PairingManager.kt
    PairingSession.kt          # pending QR/code
    TokenStore.kt              # encrypted prefs or DB hashes
  DeviceRegistry.kt
  NsdRegistrar.kt
  discovery/
    PeerDiscovery.kt
  transport/
    SyncTransport.kt           # interface
    FileContractTransport.kt
    LiveEnvelopeTransport.kt
  security/
    MeshAuth.kt
    RateLimiter.kt
```

### 2.3 Pairing protocol (v1)

```
Steward (unlocked):
  1. PairingManager.beginPairing()
  2. Generate S = 32 random bytes (base64url)
  3. Display QR: { appId, deviceId, port, token:S, exp }
  4. Wait peer POST /api/v1/pair/complete { deviceId, displayName } with Bearer S
  5. On success: TokenStore.save(hash), DeviceRegistry.upsert(host later)
  6. Clear S from memory; never log S

Peer device:
  1. Scan QR
  2. Store S in peer TokenStore (encrypted)
  3. Call complete; then use S for all LAN calls
```

### 2.4 DeviceRegistry

| Field | Meaning |
|-------|---------|
| deviceId | stable UUID |
| displayName | human |
| tokenHash | verify |
| lanHosts | last known IPs |
| linkedStudentUids | directed push targets |
| revoked | bool |
| pairedAt / lastSeen | epoch |

### 2.5 mDNS

| Parameter | Value (Index) |
|-----------|----------------|
| service type | `_phoenixforge._tcp.local.` |
| service name | `phoenixforge_schooling` |
| TXT | `deviceId`, `appId`, `v=1` — **no token in TXT** |

### 2.6 Directed push law

```
pushManifest(studentUid):
  hosts = DeviceRegistry.hostsForStudent(studentUid)
  if hosts empty → FileContractTransport only
  else for host in hosts: LanClient.post(host, bearer)
  NEVER forEach discoverPeers()
```

### 2.7 State machine: pairing

```
IDLE → PENDING (show secret, TTL) → PAIRED
         │ timeout/cancel
         ▼
       IDLE
PAIRED → REVOKED
```

### 2.8 Sequence: authenticated export

```
Client → GET /api/v1/profile/export
  Headers: Authorization Bearer S, X-Device-Id D
Server MeshAuth.authenticate
  → if fail 401
  → if ok and consent required → ConsentManager
  → ProfileExporter
```

### 2.9 Thread model

| Component | Thread |
|-----------|--------|
| TokenStore | IO |
| PairingManager | Main for UI; crypto Default |
| NsdRegistrar | IO |
| RateLimiter | concurrent map |

### 2.10 Transport resolution

```
index("schooling.transport.primary")
  file_contract → FileContractTransport (always available offline)
  live_envelope → LiveEnvelopeTransport (kit LiveMessageChannel; may be DEGRADED)
```

LAN HTTP is **not** the primary offline path; it is paired multi-device only.

### 2.11 Backup security (related)

Room backup: app-private AES-GCM (Android Keystore).  
**Never** write full Room JSON to PublicSyncWriter (classroom P0).

---

## 3. VERIFICATION

```bash
./gradlew :backbone:testDebugUnitTest --tests '*pairing*' --tests '*MeshAuth*' --tests '*DeviceRegistry*'
```

| Test | Assert |
|------|--------|
| Valid token OK | true |
| Wrong deviceId | false |
| Revoked | false |
| Expired pending pair | false |
| Directed hosts only | list size |
| No token in logs | redaction unit |
| mDNS type constant | equals Index |

Evidence → `…/package-04/`  
Threat review checklist signed in evidence.

---

## 4. IMPLEMENTATION PROMPT

See [prompts/IMPLEMENT.md](prompts/IMPLEMENT.md).

---

## 5. ACCEPTANCE CRITERIA

- [ ] Pairing requires steward unlock  
- [ ] Token secret shown once; only hash stored server-side  
- [ ] No fan-out discovery push  
- [ ] mDNS type not `_http._tcp` alone  
- [ ] Unit tests for MeshAuth  
- [ ] No git ops by implementer  

**Hard gate:** Package 05 implementation **must not start** until Package 04 MeshAuth unit tests are green (or stubs with forced fail-closed).
