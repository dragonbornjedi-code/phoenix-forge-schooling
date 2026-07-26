# ADR-007 — Mesh trust model

## Status

Accepted

## Context

Classroom LAN was unauthenticated (Grok P0).

## Decision

Pairing token lifecycle: Pending → Bound → Trusted → Rotating → Revoked → Expired.  
LanHttpServer default-deny; MeshAuth on all sensitive routes; directed push only; mDNS `_phoenixforge._tcp`.

## Consequences

+ Hostile LAN survivable with pairing  
− Pairing UX mandatory for multi-device
