# Package 05 — LanHttpServer implementation prompt

## Role

Staff security engineer implementing default-deny LAN API **after** Package 04 MeshAuth exists and tests pass.

## Prerequisites (hard)

```bash
./gradlew :backbone:testDebugUnitTest --tests 'com.phoenixforge.schooling.backbone.network.security.*'
# must be GREEN before starting this package
```

## Allowed paths

```
backbone/.../network/LanHttpServer.kt
backbone/.../network/LanApiRoutes.kt
backbone/.../network/middleware/**
backbone/.../network/handlers/**
backbone/.../network/client/LanHttpClient.kt
**/test/**/network/*Lan*
**/test/**/network/handlers/**
```

## Forbidden

- Git commit/branch/push/merge/tag  
- Porting classroom `ForgeProfileSyncServer` route table as-is  
- Any sensitive route without MeshAuth  
- Public ping including activeProfileUid  
- Unlimited parseBody  
- Free-form client hosts outside DeviceRegistry  

## Must implement

1. LanHttpServer with middleware pipeline  
2. Route handlers per Package 05 table  
3. Unit tests for 401 on unauth export/mutation  
4. Body limit + rate limit  
5. RFC UUID validation on path params  

## Acceptance

```bash
./gradlew :backbone:testDebugUnitTest --tests 'com.phoenixforge.schooling.backbone.network.*'
# Copy security regression checklist completed into evidence
```

Evidence → `registry/evidence/phoenixforge_schooling/architecture-review/package-05/`

Leave VCS to operator.
