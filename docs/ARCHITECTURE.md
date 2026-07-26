# Architecture — Phoenix Forge Schooling

## Module graph

```
phoenixforge-kit:foundation
phoenixforge-theme / theme-compose
phoenixforge-data
phoenixforge-widget
        ↑
    backbone/   (domain: profile, events, sync, secure LAN, DB)
   ↗         ↖
teacher/    student/   (UI libraries by role)
   ↘         ↙
       app/   (APK: RoleRouter, ChannelService, Application)
```

## Roles

| Role | Face | Scopes |
|------|------|--------|
| STEWARD | teacher module | PUBLIC + LESSON + PROTECTED |
| CHILD | student module | PUBLIC + LESSON read; PUBLIC write |

## Transports

| Transport | Use |
|-----------|-----|
| file_contract | Godot/World EVT_, public_state, manifests under PhoenixForge/sync |
| LiveMessageChannel | Same-device suite apps (signature) — scaffold until e2e proof |
| Secure LAN :7433 | Paired devices only after roadmap 0.25+ |

## Source mapping

Classroom 3-APK tree (`phoenix-forge-classroom-forge-profile`) maps into backbone/teacher/student per  
`../phoenix-forge-classroom/docs/REARCHITECTURE_PHASE4_OWNERSHIP.md` with package rename  
`com.phoenixforge.*` → `com.phoenixforge.schooling.*`.
