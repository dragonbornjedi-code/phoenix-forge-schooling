# ADR-009 — Security as bounded context

## Status

Accepted

## Context

Pairing, crypto, permissions, backup encryption are not “network-only.”

## Decision

Package layout uses:

```
backbone/security/
  MeshAuth, TokenStore, RateLimiter
  StewardGate crypto helpers
  BackupCipher
  ReplayWindow (optional)
  PermissionMatrix (or auth/ + re-export)
```

`backbone/network/` depends on `backbone/security/`, not the reverse for crypto primitives.

## Consequences

+ Clear ownership for audits  
− Slightly more packages
