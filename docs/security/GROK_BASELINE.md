# Security baseline — Grok classroom audit (2026-07-25)

Imported as **must-fix** for schooling. Do not port classroom network/backup/auth code until these land (master **0.25–0.49**).

## P0

1. Unauthenticated cleartext LAN profile export / events / messages
2. Unauthenticated LAN mutation (link-student, inbound manifest, messages)
3. Cleartext Room backup on world-readable storage
4. Student sync permission `protectionLevel=normal` + exported provider
5. Fan-out push to all mDNS `_http._tcp` peers

## P1

- Boolean steward auth → biometric/session
- Destructive multi-Room migrations
- Hardcoded child UID / LAN IPs in release
- allowBackup true
- Always-on Datadog consent
- AI audit note egress
- Message write without actor ACL
- Shell `python -c` injection in agency scripts

## Schooling response

Implement fixes in **backbone first** under master steps 0.26–0.45 before bulk UI port.
