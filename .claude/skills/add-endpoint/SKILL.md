---
name: add-endpoint
description: Add a new Howdy World endpoint (language or framework) end to end — scaffold, implement, register at the repo root, and verify. Use when asked to add, create, or scaffold an endpoint.
---

# Add a Howdy World endpoint

The authoritative inventory is `AGENTS.md`. Read it first; do not work from memory.

1. **Name it** in lowercase kebab-case: `<language>` or `<language>-<framework>`.
2. **Scaffold.** `bin/scaffold <endpoint> [port]` requires a clean tree on an up-to-date
   `master`. If you are already on a feature branch, copy `bin/templates/generic/` into
   `<endpoint>/` yourself and replace `__ENDPOINT__` / `__PORT__`.
3. **Implement** the app so it returns `<h1>Howdy, World!</h1>` (HTML) or `Howdy, World!`
   (text) and works under `/<endpoint>/`. Pin the framework version and commit a lockfile with a
   deterministic install (`npm ci`, `bundle install --frozen`, …).
4. **Replace every `Not implemented.` stub** in `<endpoint>/bin/*` (build, clean, doctor, lint,
   outdated, setup, test, update) with real logic, or a deliberate `abort "No <thing> configured"`.
   `bin/test` must be a real smoke test of the running endpoint.
5. **Prologs.** Line 1 of every file is its repo-relative path in the right comment syntax
   (`bin/*` scripts: shebang, then the path on line 2). See `AGENTS.md` §2.
6. **Register at the root** (all six): `compose.yml`, `_infrastructure/proxy/nginx/conf.d/<endpoint>.conf`,
   `_dashboard/www/index.html`, `README.md`, `TODO.md` (checked), `BENCHMARK.md` (via
   `bin/benchmark`, never hand-written).
7. **Verify, and report honestly:**
   - `bin/ci` — contracts. Untracked local directories (for example a stray scratch dir) fail it
     locally but not in CI; say so rather than hiding it.
   - `<endpoint>/bin/test` — run it for real with Docker. `bin/ci` does not build or start anything,
     so a green CI does not mean the endpoint serves traffic.
   - Confirm the path the proxy uses (`proxy_pass` target) actually returns the page, not just the
     standalone port.
8. **Commit** with Conventional Commits; PR to `master` with `## Summary` and `## Test plan`.

## Keep graft fresh

Before using graft (`graft ask`, `callers`, `blast`, MCP tools) run `graft build`, or `graft check`
to see whether `graft/` is stale. Rebuild after switching branches or adding an endpoint.
