# Package 00 — Implementation prompt (docs + Index bootstrap only)

## Role

Staff engineer implementing **PhoenixForge compliance bootstrap only**. No feature domains.

## Scope (allowed files)

- `app/.../SchoolingApp.kt`
- `app/.../di/*` (new)
- `backbone/.../config/SchoolingIndexKeys.kt` (new constants for key strings only)
- `backbone/.../config/SchoolingIndexBootstrap.kt` (new)
- `docs/ARCHITECTURE.md` (update ownership + keys)
- `registry/callable_variables.yaml` (new if missing)

## Forbidden

- Do **not** git commit, branch, push, merge, or tag
- Do not implement LanHttpServer, Room schema, RoleRouter UI
- Do not hardcode peer packages or IPs

## Requirements

1. On `SchoolingApp.onCreate`, create `RegistryBackedIndex`, register keys from Package 00 catalog (defaults from resources/yaml).
2. Construct `PhoenixForgeAppIdentity(appId=phoenixforge_schooling, packageName=applicationId, ...)`.
3. Resolve telemetry: `TelemetryConfig(enabled=index.resolve("schooling.telemetry.enabled"))` → `telemetryGateFor`.
4. Unit test: illegal index key registration fails; missing key throws.

## Acceptance

```bash
./gradlew :app:compileDebugKotlin :backbone:testDebugUnitTest --tests '*Index*'
./scripts/cline-essence-drift-check.sh
```

Evidence → `registry/evidence/phoenixforge_schooling/architecture-review/package-00/`

## Never

Git operations. Operator only.
