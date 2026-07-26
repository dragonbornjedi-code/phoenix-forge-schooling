# Package 02 — RoleRouter + Session Architecture

**Status:** Implementation-ready design  
**Master steps:** 0.36, 0.52–0.53, 1.26–1.32, 1.37–1.40  
**Depends on:** Package 01 (profiles), Package 00 (Index keys)  
**Blocks:** UI faces, EventWriter authz, LanHttpServer “who is active”

---

## 1. FAILURE & SECURITY AUDIT

| ID | Type | Scenario | Severity | Mitigation |
|----|------|----------|----------|------------|
| RL-01 | Privilege escalation | CHILD UI invokes steward ViewModel | P0 | Separate nav graphs; Hilt role-scoped modules; no shared VM for protected |
| RL-02 | Orphan session | Process death loses role | P0 | DataStore SessionStore durable restore |
| RL-03 | Boolean auth | Classroom LocalSecureAuthProvider | P0 | StewardGate biometric/PIN session TTL |
| RL-04 | Race | Concurrent switch role + write event | P1 | Mutex on role transition; cancel steward jobs |
| RL-05 | TOCTOU | Role checked then UI composes other graph | P1 | Single source `StateFlow<SessionSnapshot>` |
| RL-06 | Stale cache | Active profile UID stale after switch | P1 | SessionSnapshot includes profileUid + role + generation |
| RL-07 | Biometric unavailable | Device without biometrics | P1 | PIN fallback EncryptedSharedPreferences |
| RL-08 | First-run confusion | No role chosen | P2 | FirstRunWizard mandatory |
| RL-09 | Intent injection | Extra forces steward route | P2 | Allowlisted routes; ignore unknown extras |
| RL-10 | Memory | Both nav graphs retained | P2 | Dispose inactive graph |
| RL-11 | Compile | teacher/student circular | P0 design | app depends both; peers never cross |

### Black swans

- Accessibility overlay steals PIN → rate limit + lockout  
- Multi-user Android secondary user → isolate DB per user (platform)  
- Steward leaves device unlocked → short session TTL (15m default via Index)

---

## 2. SYSTEM DESIGN

### 2.1 Package tree

```
backbone/auth/
  SchoolingRole.kt              # exists
  SessionSnapshot.kt
  SessionStore.kt
  RoleManager.kt
  PermissionMatrix.kt
  StewardGate.kt
  AuthResult.kt

app/navigation/
  RoleRouter.kt
  FirstRunWizard.kt
  SchoolingNavHost.kt

app/di/
  RoleModule.kt
```

### 2.2 State machine

```
[UNINITIALIZED]
    │ restore SessionStore
    ▼
[NEEDS_FIRST_RUN] ──complete──► [ACTIVE]
    │                             │
    │                             ├── role=CHILD ──► StudentNavGraph
    │                             └── role=STEWARD ─► requires StewardGate
    │                                      │ grant
    │                                      ▼
    │                                   TeacherNavGraph
    │                                      │
    └── switch_role ◄──────────────────────┘
           │
           ▼
     [TRANSITIONING] (mutex) → [ACTIVE]
```

### 2.3 SessionSnapshot

```kotlin
data class SessionSnapshot(
  val generation: Long,           // increments every switch
  val role: SchoolingRole,
  val activeProfileUid: String,
  val stewardUnlockedUntilEpochMs: Long?, // null if CHILD or locked
  val rememberDevice: Boolean,
)
```

### 2.4 PermissionMatrix

| Action | CHILD | STEWARD locked | STEWARD unlocked |
|--------|-------|----------------|------------------|
| Read PUBLIC/LESSON events | ✓ | ✓ | ✓ |
| Write PUBLIC events | ✓ | ✓ | ✓ |
| Write LESSON events | ✗ | ✓ | ✓ |
| Write/read PROTECTED | ✗ | ✗ | ✓ |
| Mesh admin / pair | ✗ | ✗ | ✓ |
| Export full profile | ✗ | ✗ | ✓ + consent |
| Sage API key | ✗ | ✗ | ✓ |

### 2.5 Sequence: switch to steward

```
User → RoleRouter.switchToSteward()
  → StewardGate.requestUnlock()  // biometric/PIN
  → SessionStore.update { role=STEWARD, unlockedUntil=now+TTL }
  → cancel child-scoped coroutines
  → SchoolingNavHost recomposes TeacherNavGraph
```

### 2.6 Thread model

| Component | Thread |
|-----------|--------|
| SessionStore | single-thread + DataStore |
| StewardGate | Main for prompt; crypto on Default |
| RoleRouter | Main Compose |

### 2.7 Class diagram

```
RoleRouter
  ├── SessionStore ── DataStore ("schooling_session")
  ├── RoleManager ── PermissionMatrix
  ├── StewardGate ── EncryptedSharedPreferences (PIN hash) + BiometricPrompt
  └── SchoolingNavHost
        ├── TeacherNavGraph (teacher module)
        └── StudentNavGraph (student module)
```

### 2.8 Isolation rules

1. Student module **must not** depend on teacher package.  
2. No `content://` export of PROTECTED to third apps.  
3. ViewModels that touch PROTECTED live only under teacher + require `RoleManager.requireStewardUnlocked()`.  
4. `activeProfileUid` for child face must be student_self profile only.

### 2.9 Recovery

| Failure | Recovery |
|---------|----------|
| Corrupt DataStore | Reset to first-run |
| Biometric error | PIN path |
| Unlock expired mid-screen | Navigate lock wall; discard pending protected edits |

---

## 3. VERIFICATION

```bash
./gradlew :backbone:testDebugUnitTest --tests '*auth*'
./gradlew :app:compileDebugKotlin
# Manual:
# - kill process, relaunch → same role
# - switch child→steward requires gate
# - steward TTL expiry locks protected routes
```

| Test | Assert |
|------|--------|
| PermissionMatrix child cannot PROTECTED | false |
| Session restore | generation stable |
| Switch increments generation | +1 |
| Concurrent switch | serialized |

Evidence → `…/package-02/`

---

## 4. IMPLEMENTATION PROMPT

See [prompts/IMPLEMENT.md](prompts/IMPLEMENT.md).

---

## 5. ACCEPTANCE CRITERIA

- [ ] SessionStore durable  
- [ ] StewardGate not boolean flag  
- [ ] RoleRouter only entry to faces  
- [ ] PermissionMatrix unit-tested  
- [ ] No git ops by implementer  
