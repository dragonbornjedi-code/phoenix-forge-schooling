# ADR-005 — Godot contract freeze

## Status

Accepted

## Context

World reads EVT_, public_state.json, lesson manifests.

## Decision

Wire format `schemaVersion=1` field names frozen. Schooling may add **per-event** `eventVersion` inside payload or top-level optional field without removing v1 fields. Global schemaVersion bumps only with World lockstep.

## Consequences

+ World compatibility  
− Evolution constrained
