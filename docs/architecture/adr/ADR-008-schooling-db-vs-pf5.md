# ADR-008 — SchoolingDatabase vs PF5 (phoenixforge-data)

## Status

Accepted

## Context

Blueprint assigns PF5 catalog / vectors / cross-app search to **phoenixforge-data**. Schooling needs operational Room state.

## Decision

### SchoolingDatabase (`schooling.db`) owns

- Operational profiles, avatars, timeline, memories metadata  
- Event records (domain), messages  
- Peer devices / token **hashes**  
- Session-related durable prefs may use DataStore instead  

### SchoolingDatabase does **NOT** own

- Global suite catalog  
- Shared vectors / embedding index  
- Cross-app search corpus  
- Phone-wide ContentProvider catalog (omide hub)

### phoenixforge-data (`pf5_schooling.db` when enabled)

- Catalog rows, vectors, cross-app read models  
- Gated by `schooling.data.pf5.enabled` (default **false** until roadmap **2.50**)  
- No dual-write of PROTECTED content into catalog  

## Consequences

+ Clear boundary; no catalog-in-local-DB drift  
− Integration work at 2.50
