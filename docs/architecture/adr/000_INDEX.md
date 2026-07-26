# Architecture Decision Records — phoenixforge_schooling

**Status:** Formal registry (discoverable law)  
**Location:** `docs/architecture/adr/`  
**Rule:** New structural decisions require an ADR **before** code. Status ∈ {Proposed, Accepted, Superseded, Deprecated}.

---

## Index

| ID | Title | Status | File |
|----|-------|--------|------|
| **001** | One dual-interface APK | Accepted | [ADR-001-one-apk.md](ADR-001-one-apk.md) |
| **002** | Foundation ownership (kit) | Accepted | [ADR-002-foundation-ownership.md](ADR-002-foundation-ownership.md) |
| **003** | TransportPort abstraction | Accepted | [ADR-003-transport-port.md](ADR-003-transport-port.md) |
| **004** | Offline-first core loop | Accepted | [ADR-004-offline-first.md](ADR-004-offline-first.md) |
| **005** | Frozen Godot file contracts | Accepted | [ADR-005-godot-contract-freeze.md](ADR-005-godot-contract-freeze.md) |
| **006** | Role isolation (Steward/Child) | Accepted | [ADR-006-role-separation.md](ADR-006-role-separation.md) |
| **007** | Mesh trust model | Accepted | [ADR-007-mesh-trust-model.md](ADR-007-mesh-trust-model.md) |
| **008** | PF5 / SchoolingDatabase operational boundary | Accepted | [ADR-008-schooling-db-vs-pf5.md](ADR-008-schooling-db-vs-pf5.md) |
| **009** | Security bounded context (`backbone/security`) | Accepted | [ADR-009-security-bounded-context.md](ADR-009-security-bounded-context.md) |
| **010** | CallableVariableIndex sole runtime lookup | Accepted | [ADR-010-callable-variable-index.md](ADR-010-callable-variable-index.md) |

---

## Related architecture laws (not ADRs)

| Document | Purpose |
|----------|---------|
| [../DEPENDENCY_DIRECTION.md](../DEPENDENCY_DIRECTION.md) | Allowed/forbidden module edges |
| [../CALLABLE_VARIABLE_INDEX_POLICY.md](../CALLABLE_VARIABLE_INDEX_POLICY.md) | Index key ownership & lifecycle |
| [../review-sprint/GOVERNANCE_LOCK.md](../review-sprint/GOVERNANCE_LOCK.md) | Package 00 / 0.14 lock pack |
| [../../CONSTITUTION.md](../../CONSTITUTION.md) | Product non-negotiables |
| [../../ARCHITECTURE.md](../../ARCHITECTURE.md) | Module graph & transports |

---

## Numbering

- Sequential integers, zero-padded filenames `ADR-NNN-slug.md`.  
- Never renumber Accepted ADRs; supersede with a new ADR that points to the old one.  
- Review-sprint packages **reference** ADRs; they do not replace this registry.
