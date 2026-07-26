# ADR-010 — CallableVariableIndex as sole runtime lookup

## Status

Accepted

## Context

Blueprint §3 requires apps to resolve config and cross-app targets through the Index. Without policy, implementers invent keys and hardcode peers.

## Decision

1. All runtime lookups use `com.phoenixforge.foundation.index.CallableVariableIndex`.  
2. Canonical policy: [CALLABLE_VARIABLE_INDEX_POLICY.md](../CALLABLE_VARIABLE_INDEX_POLICY.md).  
3. Registry pointer: `registry/callable-variable-policy.md`.  
4. No hardcoded peer packages, LAN IPs, ports, or role string switches outside enums + Index.

## Consequences

+ Cross-app copyable convention  
− Catalog discipline required before new keys
