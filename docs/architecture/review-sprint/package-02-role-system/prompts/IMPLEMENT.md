# Package 02 — Role system implementation prompt

## Role

Staff engineer implementing session + role gate + RoleRouter shell.

## Allowed paths

```
backbone/.../auth/**
app/.../navigation/RoleRouter.kt
app/.../navigation/SchoolingNavHost.kt
app/.../navigation/FirstRunWizard.kt
app/.../MainActivity.kt
app/.../di/RoleModule.kt
**/test/**/auth/**
```

## Forbidden

- Git commit/branch/push/merge/tag  
- Boolean SharedPreferences “steward_auth_state=true” as permanent grant  
- student module importing teacher  
- Hardcoded profile UIDs  

## Must implement

1. SessionStore (DataStore) with SessionSnapshot  
2. PermissionMatrix + RoleManager  
3. StewardGate (PIN hash in EncryptedSharedPreferences; biometric optional)  
4. RoleRouter + SchoolingNavHost wiring existing TeacherNavGraph / StudentNavGraph  
5. Unit tests for matrix + session generation  

## Acceptance

```bash
./gradlew :backbone:testDebugUnitTest --tests 'com.phoenixforge.schooling.backbone.auth.*'
./gradlew :app:assembleDebug
```

Evidence → `registry/evidence/phoenixforge_schooling/architecture-review/package-02/`

Leave VCS to operator.
