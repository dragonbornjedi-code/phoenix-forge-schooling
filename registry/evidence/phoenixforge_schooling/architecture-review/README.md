# Architecture review evidence

Place per-package verification artifacts here after implementation:

```
package-00/  # compliance docs sign-off
package-01/  # kapt + Room tests
package-02/  # auth unit tests
package-03/  # event scope + golden JSON
package-04/  # MeshAuth tests + threat checklist
package-05/  # unauth 401 regression checklist
```

JSONL preferred for automated gates; text logs OK for manual.
