# Package 06 — Dependency Direction Audit

**Status:** Architecture law (governance lock)  
**Master step:** 0.14  
**Evidence:** `registry/evidence/phoenixforge_schooling/architecture-review/package-06/`

---

## 1. Mission

Prevent architecture erosion by making **allowed and forbidden Gradle/Kotlin dependency edges** explicit before code volume grows.

---

## 2. Module dependency matrix

### 2.1 Allowed edges

```
app        → backbone, teacher, student, foundation, theme, theme-compose, data, widget
teacher    → backbone, theme-compose, foundation (transitive OK via backbone)
student    → backbone, theme-compose, foundation (transitive OK via backbone)
backbone   → foundation, data (optional PF5), AndroidX Room/OkHttp/NanoHTTPD/JmDNS/security-crypto
foundation → (nothing in schooling)
theme      → (nothing in schooling)
data       → (nothing in schooling)
widget     → theme (as kit defines); never teacher/student/backbone
```

### 2.2 Forbidden edges

| From | To | Why |
|------|----|-----|
| foundation | teacher / student / app / backbone | Kit never depends on apps |
| teacher | student | Role isolation |
| student | teacher | Role isolation |
| backbone | teacher / student / app | Domain must not know UI |
| theme | backbone | Theme is pure design system |
| widget | teacher / student | Widget uses app entrypoints / backbone APIs only via app |
| teacher | network.LanHttpServer (direct) | Use repositories / use-cases |
| student | pairing / MeshAuth | Steward-only mesh admin |
| Any schooling module | classroom packages | `com.phoenixforge.profile` / `.student` / `.classroom.teacher` as compile deps |

### 2.3 Package-level (Kotlin) directions inside backbone

```
ui (teacher/student) → domain use-cases → repositories → database
events → security (PermissionMatrix), transport (TransportPort)
network → security (MeshAuth), not reverse for TokenStore crypto
security → util, database (PeerDevice); NOT → teacher UI
sync → transport, database
```

**Forbidden:** `events` → `network.LanHttpServer` (use TransportPort).

---

## 3. Platform component edges (mandatory workspace)

| Workspace path | Coordinate | Schooling may depend | Schooling may NOT |
|----------------|------------|----------------------|-------------------|
| `/var/lib/phoenix-ai/workspace/phoenixforge-kit` | `com.phoenixforge:foundation` | yes | reimplement foundation |
| `/var/lib/phoenix-ai/workspace/phoenixforge-theme` | `theme`, `theme-compose` | yes (UI modules) | put domain logic in theme |
| `/var/lib/phoenix-ai/workspace/phoenixforge-data` | `com.phoenixforge:data` | yes when `schooling.data.pf5.enabled` | store operational events only in PF5 |
| `/var/lib/phoenix-ai/workspace/phoenixforge-widget` | `com.phoenixforge:widget` | yes from **app** | widget → teacher |

Verified in `settings.gradle.kts` includeBuild blocks.

---

## 4. Enforcement (design → later automation)

### 4.1 Manual / CI grep gates

```bash
# No cross-role module deps in Gradle
rg 'project\(":student"\)' teacher/ || true   # must be empty
rg 'project\(":teacher"\)' student/ || true   # must be empty
rg 'project\(":app"\)' backbone/ || true      # must be empty

# No classroom package imports
rg 'com\.phoenixforge\.(profile|student|classroom\.teacher)' \
  app backbone teacher student --glob '*.kt' || true  # must be empty after port
```

### 4.2 Future: Architecture lint script

`scripts/architecture-dep-lint.sh` (roadmap 0.14 / later) exits non-zero on forbidden edges.

---

## 5. FAILURE MATRIX

| Failure | Impact | Detection |
|---------|--------|-----------|
| teacher → student | Child API leaks into steward | gradle dep + rg |
| backbone → app | Circular DI | compile |
| widget → teacher | Unshippable headless host | gradle |
| foundation fork | Dual buses | Package 00 rg |
| PF5 used as event log | PROTECTED in catalog | ADR-008 review |

---

## 6. VERIFICATION

```bash
./gradlew projects
test -f settings.gradle.kts
rg 'includeBuild\("../phoenixforge-(kit|theme|data|widget)"\)' settings.gradle.kts
# Four matches expected
```

| Check | Pass |
|-------|------|
| includeBuild kit | yes |
| includeBuild theme | yes |
| includeBuild data | yes |
| includeBuild widget | yes |
| teacher/build has no :student | yes |
| student/build has no :teacher | yes |
| backbone/build has no :app | yes |

---

## 7. ACCEPTANCE

- [x] Matrix documented  
- [x] Platform paths absolute + coordinates  
- [ ] `scripts/architecture-dep-lint.sh` (optional next)  
- [ ] CI wires lint (when workflow scope available)  

**Status:** `[TESTED]` as documentation law.
