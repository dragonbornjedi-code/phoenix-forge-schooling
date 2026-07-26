# Architecture Review Sprint — Index

**Repo:** `phoenix-forge-schooling`  
**App:** `phoenixforge_schooling`  
**Date:** 2026-07-26  
**Protocol:** Cline Essence + Constitution + Blueprint (phoenixforge-kit)  
**Roadmap alignment:** Master `0.25` Security Foundation **before** bulk backbone port; these packages are **design-only**, not implementation.

---

## Mission

Produce **implementation-ready specifications** for the six foundation subsystems of dual-interface schooling so coding can proceed without rework, without reinventing kit foundation, and without reintroducing classroom P0 security failures.

## Constraint (operator law)

| Do | Do not |
|----|--------|
| Design, specify, prompt | Implement all five in one coding pass |
| Respect master roadmap sequence | Skip security for speed |
| Consume kit foundation | Duplicate EventBus, AppIdentity, TelemetryGate, LiveMessageChannel |
| Use CallableVariableIndex keys | Hardcode package names, IPs, roles as string literals |

## Package order (dependencies)

```
Package 00 Compliance + Red-Team
        │
        ▼
Package 01 SchoolingDatabase  ──────┐
        │                           │
        ▼                           │
Package 02 Role / Session / Router  │
        │                           │
        ▼                           │
Package 03 Event Pipeline ◄─────────┘
        │
        ▼
Package 04 Mesh Pairing (trust anchor)
        │
        ▼
Package 05 LanHttpServer (depends on 04 + 03 scopes)
```

## Deliverable map

| Package | Path |
|---------|------|
| 00 | [package-00-compliance/README.md](package-00-compliance/README.md) |
| 01 | [package-01-database/README.md](package-01-database/README.md) |
| 02 | [package-02-role-system/README.md](package-02-role-system/README.md) |
| 03 | [package-03-event-pipeline/README.md](package-03-event-pipeline/README.md) |
| 04 | [package-04-mesh/README.md](package-04-mesh/README.md) |
| 05 | [package-05-lan-http/README.md](package-05-lan-http/README.md) |

Each package contains: Failure & Security Audit · System Design · Verification · CLI/Cursor Implementation Prompt · Evidence checklist.

## Evidence root

```
registry/evidence/phoenixforge_schooling/architecture-review/
  package-00/
  package-01/
  …
```

## Implementation sequencing (after this sprint)

1. Land Package 00 findings into registry + ARCHITECTURE.md (docs only).  
2. Implement Package 01 (`0.51` SchoolingDatabase).  
3. Implement Package 02 (`1.28` RoleRouter / Session — and early stubs for `0.36` steward gate).  
4. Implement Package 03 (`0.56–0.60` event pipeline) — **security scope tests required**.  
5. Implement Package 04 (`0.26–0.30`, `1.76+`) mesh pairing.  
6. Implement Package 05 (`0.27–0.28`, `0.64`) LanHttpServer on top of pairing.

## Git law for implementers

> **DO NOT** git commit, create branches, push, merge, or tag. Only modify requested source files. Leave all version control to the operator.
