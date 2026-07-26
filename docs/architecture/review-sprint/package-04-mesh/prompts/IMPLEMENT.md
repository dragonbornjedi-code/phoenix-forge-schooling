# Package 04 — Mesh pairing implementation prompt

## Role

Security-minded staff engineer. Implement pairing trust anchor only (no full NanoHTTPD route table yet).

## Allowed paths

```
backbone/.../network/pairing/**
backbone/.../network/DeviceRegistry.kt
backbone/.../network/security/MeshAuth.kt
backbone/.../network/security/RateLimiter.kt
backbone/.../network/NsdRegistrar.kt
backbone/.../network/discovery/**
backbone/.../network/transport/**
backbone/.../backup/**                 # encrypted private only
**/test/**/network/**
```

## Forbidden

- Git commit/branch/push/merge/tag  
- Logging raw Bearer tokens  
- Writing tokens or Room dumps to public storage  
- `_http._tcp` as sole discovery filter  
- `discoverPeers().forEach { post }` fan-out helpers  
- Hardcoded IP/UID  

## Must implement

1. PairingManager + TokenStore (hash) + DeviceRegistry  
2. MeshAuth.authenticate(headers)  
3. NsdRegistrar with phoenixforge service type  
4. SyncTransport interface + FileContractTransport skeleton  
5. Unit tests for auth success/fail/revoke  

## Acceptance

```bash
./gradlew :backbone:testDebugUnitTest --tests 'com.phoenixforge.schooling.backbone.network.*'
```

Evidence → `registry/evidence/phoenixforge_schooling/architecture-review/package-04/`

Leave VCS to operator.
