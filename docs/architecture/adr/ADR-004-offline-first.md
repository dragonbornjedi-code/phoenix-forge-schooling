# ADR-004 — Offline-first

## Status

Accepted

## Context

Family devices are often offline; Sage/cloud is optional.

## Decision

Core loops (quests, events, manifests, progression) work with `file_contract` only. LAN and LiveMessageChannel are enhancements.

## Consequences

+ Resilient product  
− Multi-device sync depends on Syncthing/filesystem trust model short-term
