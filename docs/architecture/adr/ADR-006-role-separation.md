# ADR-006 — Role separation

## Status

Accepted

## Context

Child must never see PROTECTED stewardship data.

## Decision

Canonical permission matrix (Package 02 / governance):

| Role | PUBLIC | LESSON | PROTECTED |
|------|--------|--------|-----------|
| Child | R/W | Read | Deny |
| Steward (unlocked) | R/W | R/W | R/W |
| Steward (locked) | R/W | R/W | Deny |
| LAN peer | Token-gated | Token-gated | Never direct |
| World (Godot) | File contract only | Manifest only | Never |

teacher/ and student/ never depend on each other.

## Consequences

+ Testable isolation  
− Steward unlock UX required for protected flows
