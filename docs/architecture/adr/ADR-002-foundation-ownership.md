# ADR-002 — Foundation ownership

## Status

Accepted

## Context

Blueprint §2: kit owns foundation. Classroom reinvented identity, HTTP trust, and telemetry patterns.

## Decision

Schooling **consumes** `com.phoenixforge:foundation` only. Forbidden to reimplement: CallableVariableIndex, PhoenixForgeEventBus, AppIdentity, DeviceProfile, TelemetryGate, LiveMessageChannel.

## Consequences

+ Suite-wide consistency  
− Feature velocity gated on kit APIs
