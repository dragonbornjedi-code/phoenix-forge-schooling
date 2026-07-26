# ADR-001 — One dual-interface APK

## Status

Accepted

## Context

Classroom shipped three packages. Constitution requires one offline-first product face pair.

## Decision

Single applicationId `com.phoenixforge.schooling` with STEWARD and CHILD roles via RoleRouter.

## Consequences

+ One install, one DB, simpler mesh  
− Role isolation must be enforced in software (PermissionMatrix, nav graphs)
