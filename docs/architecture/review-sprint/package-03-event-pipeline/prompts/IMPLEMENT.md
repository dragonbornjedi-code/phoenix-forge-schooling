# Package 03 — Event pipeline implementation prompt

## Role

Staff engineer implementing EventWriter / Ingester / projectors with frozen Godot wire format.

## Allowed paths

```
backbone/.../events/**
backbone/.../sync/FileContractTransport.kt   # or port under events + sync
backbone/src/test/**/events/**
shared/schemas/**                            # optional golden copies
```

## Forbidden

- Git commit/branch/push/merge/tag  
- Changing EVT_ field names  
- Ingesting PROTECTED from filesystem  
- Direct File I/O in EventWriter (use SyncTransport)  
- Hardcoded actorApp package strings  

## Must implement

1. EventIdFactory, LogicalClock  
2. EventWriter with PermissionMatrix + SessionSnapshot  
3. EventIngester + quarantine  
4. StateProjector → public_state via transport  
5. Golden fixture tests from classroom samples if available  

## Acceptance

```bash
./gradlew :backbone:testDebugUnitTest --tests 'com.phoenixforge.schooling.backbone.events.*'
```

Evidence → `registry/evidence/phoenixforge_schooling/architecture-review/package-03/`

Leave VCS to operator.
