# Package 01 — SchoolingDatabase implementation prompt

## Role

Staff Android engineer. Implement Room domain DB for schooling only.

## Allowed paths

```
backbone/src/main/java/com/phoenixforge/schooling/backbone/database/**
backbone/src/main/schemas/**          # Room export
backbone/src/test/java/**/database/**
backbone/.../di/DatabaseModule.kt
```

## Forbidden

- Git commit / branch / push / merge / tag  
- `fallbackToDestructiveMigration()` in non-debug  
- PublicSyncWriter for Room dumps  
- Second `Room.databaseBuilder` anywhere  
- SQLCipher unless ADR approved  

## Must implement

1. `SchoolingDatabase` v1 with entities listed in Package 01 README  
2. DAOs + repositories (interfaces + Room impl)  
3. Hilt `@Singleton` provider  
4. Type converters for enums/instants  
5. Unit tests with in-memory Room  

## Acceptance commands

```bash
./gradlew :backbone:compileDebugKotlin :backbone:kaptDebugKotlin
./gradlew :backbone:testDebugUnitTest --tests 'com.phoenixforge.schooling.backbone.database.*'
```

Evidence → `registry/evidence/phoenixforge_schooling/architecture-review/package-01/`

Leave version control to operator.
