# Dependency Direction — Architecture Law

**Status:** Accepted / immutable without ADR  
**Related:** [Package 06](review-sprint/package-06-dependency-direction/README.md) · [ADR-002](adr/ADR-002-foundation-ownership.md) · [ADR-009](adr/ADR-009-security-bounded-context.md)  
**Enforcement:** `scripts/cline-essence-drift-check.sh` (includeBuild + substitution targets)

This document is **checked-in law**, not tribal knowledge.

---

## 1. Allowed module dependencies

| Module | May depend on |
|--------|----------------|
| **app** | backbone, teacher, student, foundation, theme, theme-compose, data, widget |
| **teacher** | backbone, foundation, theme-compose |
| **student** | backbone, foundation, theme-compose |
| **backbone** | foundation, data (optional PF5), Room / OkHttp / NanoHTTPD / JmDNS / security-crypto |
| **widget** (platform) | foundation, theme, data — **never** teacher/student/backbone |
| **data** (platform) | foundation only (as defined by phoenixforge-data) |
| **theme** (platform) | — (no schooling modules) |
| **foundation** (platform) | — (no schooling modules) |

### Gradle edges (schooling modules)

```
app → backbone, teacher, student
teacher → backbone
student → backbone
backbone → (no schooling modules)
```

---

## 2. Explicitly forbidden

```
foundation → backbone
foundation → teacher
foundation → student
foundation → app

teacher → student
student → teacher

theme → backbone
theme → teacher
theme → student
theme → app

widget → teacher
widget → student
widget → backbone

backbone → app
backbone → teacher
backbone → student

data → teacher
data → student
data → app          # app may depend on data; not reverse

# After port complete:
any schooling module → com.phoenixforge.profile / .student / .classroom.teacher (compile)
```

### Kotlin package directions (backbone)

| From | To | Allowed? |
|------|----|----------|
| events | TransportPort | yes |
| events | LanHttpServer | **no** |
| network | security | yes |
| security | network | **no** (except pure types if unavoidable) |
| teacher UI | PermissionMatrix / repositories | yes via backbone APIs |
| student UI | MeshAuth / PairingManager | **no** |

---

## 3. Platform composite builds (absolute paths)

| Path | Module coordinate | Substitution project |
|------|-------------------|----------------------|
| `/var/lib/phoenix-ai/workspace/phoenixforge-kit` | `com.phoenixforge:foundation` | `:foundation` |
| `/var/lib/phoenix-ai/workspace/phoenixforge-theme` | `com.phoenixforge:theme` | `:theme` |
| same | `com.phoenixforge:theme-compose` | `:theme-compose` |
| `/var/lib/phoenix-ai/workspace/phoenixforge-data` | `com.phoenixforge:data` | `:data` |
| `/var/lib/phoenix-ai/workspace/phoenixforge-widget` | `com.phoenixforge:widget` | `:widget` |

`settings.gradle.kts` **must** contain both `includeBuild("../phoenixforge-<lib>")` **and** the matching `substitute(module(...)).using(project(...))` lines.

---

## 4. Diagram

```
                    foundation
                    theme / theme-compose
                    data
                    widget
                         ↑
                      backbone
                     ↗        ↖
                 teacher    student
                     ↘        ↙
                        app
```

---

## 5. Verification

```bash
./scripts/cline-essence-drift-check.sh
# Manual / future lint:
rg 'project\(":student"\)' teacher/build.gradle.kts   # empty
rg 'project\(":teacher"\)' student/build.gradle.kts   # empty
rg 'project\(":app"\)' backbone/build.gradle.kts      # empty
```

**Status:** `[VERIFIED]` as documentation law when drift check passes.
