<!-- AGENTS.md -->
# AGENTS.md — Howdy World Endpoint Checklist

Instructions for AI agents and contributors adding or maintaining a Howdy World endpoint.
Read [POLICY.md](POLICY.md) and [ARCHITECTURE.md](ARCHITECTURE.md) first; this file is the
operational inventory. The baseline is [`ruby-on-rails/`](ruby-on-rails), with
[`bin/templates/generic/`](bin/templates/generic) as the scaffold source.

An endpoint is **complete** only when every item below exists and `bin/ci` passes.

## 1. Endpoint directory (`<endpoint>/`)

The directory name is lowercase kebab-case (`<language>` or `<language>-<framework>`).

### Required (enforced by `bin/contracts/endpoints.sh`)

| File | Purpose |
|---|---|
| `.dockerignore` | Keep build context small |
| `.gitignore` | Ignore build/dependency output |
| `Dockerfile` | Production image |
| `compose.yml` | Standalone production run (`bin/up`) |
| `README.md` | What it is, `bin/run`, `bin/up` |

### Required by convention (Rails baseline + scaffold template)

| File | Purpose |
|---|---|
| `bin/_lib.sh` | Resolves `ENDPOINT_DIR`, sources root `bin/_lib.sh`, `cd`s into the endpoint |
| `bin/build` | Build the app |
| `bin/clean` | Remove build artifacts and dependencies |
| `bin/doctor` | Verify local toolchain |
| `bin/down` | `docker compose down` |
| `bin/lint` | Run the linter (or `abort "No linter configured for <endpoint>."`) |
| `bin/logs` | Tail compose logs |
| `bin/outdated` | List outdated dependencies |
| `bin/restart` | `down` then `up` |
| `bin/run` | Development run (`compose.dev.yml` when present) |
| `bin/setup` | Install dependencies (use the lockfile) |
| `bin/start` | Alias for `bin/up` |
| `bin/stop` | Alias for `bin/down` |
| `bin/test` | Smoke test: the endpoint returns `Howdy, World!` |
| `bin/up` | Production run (`compose.yml`) |
| `bin/update` | Update dependencies |

Start from `bin/scaffold <endpoint> [port]`; it copies the scaffold template and registers the
endpoint. Replace every `Not implemented.` stub with real logic or a deliberate `abort`.

### Optional

`compose.dev.yml` + `Dockerfile.dev` (hot-reload development), `NOTES.md`, `TODO.md`,
a dependency lockfile (see below).

### Behavior

- Responds with HTML containing `<h1>Howdy, World!</h1>` (or plain text `Howdy, World!`).
- Listens on a single internal port and works under its base path `/<endpoint>/`,
  or tolerates the proxy stripping it (see [POLICY.md](POLICY.md)).
- Builds from a **committed lockfile** with a deterministic install
  (`npm ci`, `bundle install --frozen`, `go.sum`, `mix.lock`, `shard.lock`, …). Pin the framework version.
- Does not reference other endpoints (client-side SPAs and databases excepted).
- Does not hardcode its framework patch version in served content.

## 2. Prologs

Line 1 of every source file is a comment naming its repo-relative path (enforced by
`bin/contracts/prologs.sh`):

| Type | Prolog |
|---|---|
| `.sh`, `.yml`, `.conf`, `.rb`, `.py`, `.ex`, `.exs`, `.cr`, `Dockerfile*`, `.dockerignore`, `.gitignore` | `# <path>` |
| `.js`, `.ts`, `.go`, `.cs`, `.java`, `.rs`, `.zig`, `.odin`, `.mod` | `// <path>` |
| `.html` | `<!-- <path> -->` |
| `.css` | `/* <path> */` |
| `.clj` | `;; <path>` |
| `.php` | `<?php` then `// <path>` |
| `bin/*` scripts | shebang on line 1, `# <path>` on line 2 |
| `.md` | `<!-- <path> -->` (not enforced; new docs should include it) |

Files with no enforced prolog (`.mjs`, `.astro`, `.json`, lockfiles) may be left alone, because
the checker only warns for unknown types. Exempt: `.json`, `.md`, `.svg`, images, lockfiles.

## 3. Root registration (every new endpoint touches all of these)

1. `compose.yml` — service with `build: ./<endpoint>`, `container_name`, `expose` (kept alphabetical).
2. `_infrastructure/proxy/nginx/conf.d/<endpoint>.conf` — redirect `/<endpoint>` → `/<endpoint>/`
   and the `location ^~ /<endpoint>/` proxy block (see `bin/templates/nginx_endpoint.conf`).
3. `_dashboard/www/index.html` — link in the supported list (alphabetical).
4. `README.md` — entry in the language list (alphabetical).
5. `TODO.md` — checked `[x]` entry in **Languages and Frameworks** (alphabetical).
6. `BENCHMARK.md` — a row produced by running `bin/benchmark` (never hand-written numbers).

## 4. Verification

```bash
bin/ci                 # contracts: required files, prologs, proxy, root compose
<endpoint>/bin/test    # endpoint smoke test (needs Docker)
```

`bin/ci` is the GitHub Actions gate on PRs to `master`. It scans every root-level directory,
so untracked local directories (for example `graft/`, `c-posix/`) fail it locally but not in CI.

## 5. Git and PRs

- Default branch `master`; branches `feat/<name>`, `fix/<name>`, `chore/<name>`.
- Conventional Commits. Never force-push `master`; never `--no-verify`.
- PR body: `## Summary`, `## Test plan`.

—
Stan Carver II
Made in Texas 🤠
https://stancarver.com
