---
name: howdy-bin
description: How to use the Howdy World root CLI (bin/) and per-endpoint bin scripts. Use when running, testing, building, benchmarking, or troubleshooting endpoints or editing bin scripts.
---

# Howdy World bin scripts

## Root CLI (`bin/<command>`, run from repo root)

`benchmark`, `build`, `ci`, `doctor`, `down`, `health`, `help`, `logs`, `restart`, `scaffold`,
`setup`, `start`, `status`, `stop`, `test`, `up`, `version`. `bin/help` lists them.
Helpers live in `bin/functions/*.sh`; contracts in `bin/contracts/*.sh`.

- `bin/ci` runs the contracts only (what GitHub Actions runs on PRs to `master`).
- `bin/benchmark` needs Docker and `hey` and a running stack at `http://howdy.localhost`.
- `bin/scaffold` needs a clean, up-to-date `master` — see the `add-endpoint` skill.

## Per-endpoint scripts (`<endpoint>/bin/<command>`)

Standard set: `build clean doctor down lint logs outdated restart run setup start stop test up update`.

- `up`/`start` → `compose.yml` (production); `run` → `compose.dev.yml` (development, if present).
- `down`/`stop` → `docker compose down`; `restart` → down then up.
- `setup` installs dependencies from the lockfile; `update` changes them; `outdated` only reports.
- `test` is the smoke test and must really exercise the endpoint.

## Writing or editing a script

```bash
#!/usr/bin/env bash
# <endpoint>/bin/<name>

source "$(dirname "$0")/_lib.sh"

banner
```

- Shebang on line 1, repo-relative path on line 2 (enforced).
- `_lib.sh` `cd`s into the endpoint and exposes `banner`, `abort`, `require_command`,
  `install_command`, `remove_build_artifacts`, `compose`.
- Call `require_command <tool>` before using a tool. Use `abort "message"` to fail.
- No raw stubs: a script is either real or a deliberate `abort`.
- Make it executable (`chmod +x`).

## Tool paths on this machine

Claude's Bash tool does not inherit the zsh PATH. Use `/usr/local/bin/gh` for GitHub, and
`mise exec -- …` for Ruby tooling. Node comes from mise too
(`~/.local/share/mise/installs/node/latest/bin`).

## Keep graft fresh

Before using graft (`graft ask`, `callers`, `blast`, MCP tools) run `graft build`, or `graft check`
to see whether `graft/` is stale. Rebuild after switching branches or adding an endpoint.
