# Howdy World Architecture

Howdy World is a polyglot endpoint ecosystem designed with strict governance,
repeatable structure, and intentional separation of concerns.

---

## Repository Layout

bin/                     # Root CLI (Developer Operating System)
bin/functions/           # Shared CLI logic modules
bin/templates/           # Generic scaffold templates
_infrastructure/         # Cross-cutting runtime concerns
  proxy/
    nginx/               # Reverse proxy configuration
<endpoint>/              # One folder per endpoint
compose.yml              # Root production stack
ARCHITECTURE.md          # This document

---

## Core Principles

1. Intent over implementation
2. Automation over brittle manual processes
3. Contract enforcement over convention
4. Explicit configuration over magic
5. Infrastructure isolated from endpoints
6. Deterministic execution contexts

---

## Endpoint Contract

An endpoint is defined as:

- Any root-level folder not starting with `_` or `.`
- Not blacklisted in CLI configuration

### Required Files

- Dockerfile
- compose.yml
- .dockerignore
- .gitignore
- README.md
- bin/setup
- bin/outdated

### Optional Files

- Dockerfile.dev
- compose.dev.yml
- TODO.md
- NOTES.md

Endpoints must pass:

    bin/health --strict

Endpoint scripts must enforce:

    require_endpoint_contract

---

## CLI Governance

Root-level CLI (`bin/`) provides:

- scaffold  → create endpoint structure
- build     → docker image builds
- up/down/restart
- status
- logs
- test
- health
- doctor
- help
- version
- ci (governance runner)

All commands:

- Use a unified banner
- Enforce deterministic execution context
- Source shared logic from bin/functions/

---

## Infrastructure

Infrastructure is isolated under:

_infrastructure/

Current implementation:

_infrastructure/proxy/nginx/

Infrastructure is not an endpoint.

---

## Workflow Governance

- Direct commits to master are blocked via git hook
- Scaffold requires master to be clean and synced with origin
- Feature branches are mandatory
- bin/ci enforces local quality gates before merge

---

## Future Builder

A future Builder tool may:

- Generate language-aware scaffolds
- Install dependencies
- Configure dev workflows

Builder will extend — not replace — the endpoint contract.

---

Howdy World is not a demo collection.
It is a governed polyglot development platform.

Last Updated: 20260219
