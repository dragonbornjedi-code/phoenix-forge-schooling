# ADR-003 — TransportPort abstraction

## Status

Accepted

## Context

Domain writers must not bind to NanoHTTPD, File, or LiveMessageChannel concrete types.

## Decision

```
EventWriter / ManifestWriter / MessageRelay
        │
        ▼
   TransportPort   (schooling interface)
        │
        ├── FileContractTransport
        └── LiveEnvelopeTransport  → kit LiveMessageChannel
```

Selection via `schooling.transport.primary` Index key.

## Consequences

+ Mesh rewrites do not touch domain  
− Extra interface layer
