---
name: audit-endpoints
description: Audit every Howdy World endpoint against the Rails baseline / AGENTS.md inventory and report drift. Use when asked to check consistency, maintain endpoints, or before a cleanup PR.
---

# Audit endpoints for drift

1. Run `bin/ci` for the enforced contracts (required files, prologs, proxy, root compose).
2. Print an inventory matrix of what each endpoint actually has, from the repo root:

```bash
for e in $(ls -d */ | tr -d / | grep -Ev '^(_|bin$)'); do
  printf "%-22s" "$e"
  for f in .dockerignore .gitignore Dockerfile compose.yml README.md bin/_lib.sh bin/test bin/up bin/run; do
    [ -e "$e/$f" ] && printf "Y" || printf "."
  done; echo
done
```

3. Check registration for each endpoint: root `compose.yml`, `conf.d/<endpoint>.conf`,
   `_dashboard/www/index.html`, `README.md`, `TODO.md`, `BENCHMARK.md`.
4. Check stubs: `grep -rl 'Not implemented' */bin` — stubs mean the endpoint is not complete.
5. Check lockfiles and pinned versions per endpoint; flag hardcoded patch versions in served content.
6. Where it is cheap and obvious, fix. Where it needs a real run (benchmarks, Docker builds), say
   what was not verified.

Report as: enforced failures, convention gaps (from `AGENTS.md`), unverified items. Do not
claim an endpoint is complete from file presence alone — run its `bin/test`.
