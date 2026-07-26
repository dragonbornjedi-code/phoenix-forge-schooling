# Capability map — classroom → schooling

**Status:** skeleton (step 0.12). Full file-level map:  
`../../phoenix-forge-classroom/docs/REARCHITECTURE_PHASE4_OWNERSHIP.md`

| Source module | Target | Notes |
|---------------|--------|-------|
| forge-profile-core | backbone/ | Rewrite network/backup for security |
| forge-sync-client | backbone/sync | Path jail + message ACL |
| forge-profile-app UI | app/ + dual UI | RoleRouter |
| teacher-app | teacher/ | Package `com.phoenixforge.schooling.teacher` |
| student-app | student/ | Package `com.phoenixforge.schooling.student` |
| scripts/ agency | scripts/ | Injection-safe rewrites |
| shared/ contracts | shared/ | Copy as needed |

## 140 capability buckets

| Bucket | Count | Target |
|--------|------:|--------|
| Kit | 15 | phoenixforge-kit (consume) |
| Backbone | 66 | backbone/ |
| Teacher | 38 | teacher/ |
| Student | 19 | student/ |
| Archive | 2 | classroom git only |
