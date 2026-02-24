# List of To-Dos for Howdy World

### Master Control Builder

- [ ] Build files and folders from CSV data
  - [ ] compose.yml
  - [ ] _infrastructure/proxy/nginx/conf.d/<language>.conf
  - [ ] Languages section of README of supported languages and frameworks
- [ ] Add Dockerfile for each language
- [ ] Add compose.yml for each language
- [ ] Add README.md for each language
- [ ] Add TODO.md for each language
- [ ] Add .gitignore for each language (source: https://github.com/github/gitignore)
- [ ] Add .dockerignore for each language
- [ ] Add healthz endpoint for each language
- [ ] Add common CSS/JS? libraries
- [ ] Add GitHub Actions for:
  - [ ] `docker compose config` (lint/validate)
  - [ ] building images
  - [ ] smoke testing endpoints
- [ ] Create Docker Compose profiles to run “just nginx + ruby” instead of the whole zoo:
  - [ ] e.g. `docker compose --profile ruby up --build`
- [ ] Verify compiled languages produce a binary in `/out` folder
- [ ] Verify <service_name>/Dockerfile recompiles live changes
- [ ] Verify service README.md contains consistent structure
  - [ ] Copyright
  - [ ] Link to portfolio
  - [ ] Made in Texas
- [ ] Verify HTML Structure
  - [ ] Outputs "Howdy from <service_name>" in `<title>`
  - [ ] Outputs "Howdy, World!" in `<h1>`
  - [ ] Link back to <root>/index.html, if production
  - [ ] Timestamp
  - [ ] Language name and version
  - [ ] Framework name and version
  - [ ] Common CSS/JS? libraries
  - [ ] Cowboy icon
  - [ ] Copyright
  - [ ] Link to portfolio
  - [ ] Made in Texas

### Languages and Frameworks

- [ ] Ada
- [ ] AWK
- [ ] BASIC
- [ ] C
- [ ] C++
- [x] C# (ASP.NET)
- [x] Caddy
- [x] Clojure
- [ ] COBOL
- [ ] Dart
- [ ] Elixir
  - [x] Bandit
  - [x] Phoenix
- [ ] Erlang
- [ ] Fortran
- [x] Go
- [ ] Haskell
- [ ] Java
  - [x] Spring Boot
- [x] JavaScript
  - [ ] Angular
  - [ ] Ember
  - [x] Inertia
  - [x] jQuery
  - [ ] Next
  - [ ] Nuxt
  - [ ] Node
  - [ ] React
  - [x] Stimulus
  - [ ] Svelte
  - [o] TypeScript (see [javascript-inertia][./javascript-inertia])
  - [ ] Vanilla
  - [x] Vue
- [ ] Lisp
- [ ] Lua
- [x] NGINX
- [ ] Oberon
- [ ] Odin
  - [x] Odin HTTP
- [ ] Perl
- [ ] PHP
  - [ ] Laravel
  - [ ] Symfony
- [ ] Python
  - [ ] Django
  - [x] FastAPI
  - [ ] Flask
  - [ ] Typer
  - [ ] Uvicorn
  - [ ] Werkzeug
  - [ ] Ython
  - [ ] Zappa
  - [ ] Zoo
  - [ ] Zulip
- [ ] Ruby
  - [ ] Cuba
  - [ ] Falcon
  - [ ] Jekyll
  - [ ] Middleman
  - [ ] Rack
  - [x] Ruby on Rails
  - [ ] Sinatra
  - [x] WEBrick
- [ ] Rust
  - [ ] Axum
  - [x] Leptos
- [ ] Shell
  - [ ] Bash
- [ ] Swift
- [x] Zig

### NGINX

- [x] Reverse Proxy
- [x] index catalog of available endpoints
- [x] place individual endpoint's configuration into conf.d


## HTML

### Example styling with dark mode feature
```html
<html class="light">
  <head>
    <style>
      html.dark {
        color-scheme: dark;
      }
      body {
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto,
          Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
      }
    </style>
  </head>
```

### Example HTML5 markup
```html
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <meta name="description" content="Howdy World via {{language}}" />
  <title>🤠 Howdy from {{language}}</title>
  <style>
    :root { color-scheme: dark; }
    body { margin: 0; font-family: system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial, sans-serif; line-height: 1.5; }
    main { max-width: 860px; margin: 0 auto; padding: 2.5rem 1.25rem; }
    .card { border: 1px solid rgba(255,255,255,0.12); border-radius: 16px; padding: 1.25rem 1.25rem; background: rgba(255,255,255,0.04); }
    h1 { margin: 0 0 0.75rem; font-size: 2rem; }
    p { margin: 0.25rem 0 0.75rem; opacity: 0.92; }
    small { opacity: 0.7; }
    code { padding: 0.15rem 0.35rem; border-radius: 6px; background: rgba(0,0,0,0.35); }
  </style>
</head>
<body>
  <main>
    <div class="card">
      <h1>Howdy, World!</h1>
      <p>Full HTML5 output rendered via html/template (inline).</p>
      <small>Rendered at <code>{{timestamp}}</code></small>
    </div>
  </main>
</body>
</html>
```

## The Howdy World Story

Tell the Howdy World story at a glance:

One README section called “Why these languages”

3 bullets: what problem, why this tool, what outcome.

A tiny “bench / profile” note (even if informal)

“Zig image processing: X ms for N images on my machine”

“Go QR: throughput / latency rough numbers”

A “learning → shipped” changelog

5–10 lines that show momentum without making people dig.

Emphasis the birth to test multiple languages accomplishing the same task, not just for performance, but ease of use and implementation.


# Repo Health TODO

## Root-level
Documentation
  - Add README.md with setup instructions
  - Add how to run with Docker
  - Add how to run locally
  - Add development workflow notes
General
  - add .gitignore?
Testing
  - e2e
Dockerfile
  - add .dockerignore?

## Service-level
App
  - Native Linter
  - Native Test Suite
  - AST testing
  - CSS - /assets
  - Version locking
  - Purge extraneous comments and unused codeblocks
  - HTML Templated for web apps
  - consume `.env` and secrets?
  - .gitignore present?
  - Handle endpoints
    - production: "/<service>/"
    - development: "/"
  - Documentation
    - Add README.md with setup instructions
    - Add how to run with Docker
    - Add how to run locally
    - Add development workflow notes
Document how to run locally
Add development workflow notes
Dockerfile
  - .dockerignore present?
  - production profile
  - dev profile or Dockerfile.dev
  - version locked
  - minimal container size
  - howdy.localhost
  - corral network
  - security: add non-root user to Dockerfile
    - Add user/group creation  e.g. `RUN addgroup --system --gid 1001 nodejs && adduser --system --uid 1001 bunuser`
    - Add USER directive e.g. `USER bunuser`
### Docker Compose
  - minimal and consistent formatting
  - port mapping
  - consistent file naming
  - environment variables

#### Networks
  - corral network
  - howdy.localhost

```yml
    networks:
      - corral

networks:
  corral:
    external: true
```

## Testing
### Smoke Tests
  - [ ] Confirm root / endpoint (dashboard)is available
  - [ ] Confirm  endpoint is 200 OK
  - [ ] Confirm /<service>/ endpoint is 200
  - [ ] Confirm "Howdy World" in the response body
  - [ ] Confirm /<service>/healthz endpoint is 200 OK

### Negative Tests
  - [ ] Confirm no port leakage to public (e.g. 3000, 8080, 9292)
  - [ ] Confirm global 404 page for non-existent endpoints
  - [ ] Confirm global 404 page for non-existent pages in endpoints
  - [ ] Confirm global 500 page for endpoints

### Performance
- [ ] Benchmark endpoints


--- 2026-02-22 ---

# 🤠 Howdy World — Unified Master Task List
TODO: conform and merge this list below into the above
---

# 🧱 Master Control Builder

- [ ] Build files and folders from CSV data
  - [ ] compose.yml
  - [ ] _infrastructure/proxy/nginx/conf.d/<language>.conf
  - [ ] Languages section of README of supported languages and frameworks
- [x] Add Dockerfile for each implemented language
- [x] Add compose.yml for each implemented language
- [x] Add README.md for each implemented language
- [x] Add TODO.md for each implemented language
- [x] Add .gitignore for each implemented language
- [x] Add .dockerignore for each implemented language
- [ ] Add healthz endpoint for each language (intentionally not standardized globally)
- [ ] Add common CSS/JS libraries (shared `/assets/`)
- [ ] Add GitHub Actions for:
  - [ ] `docker compose config` lint/validate
  - [ ] building images (partial)
  - [ ] smoke testing endpoints
- [ ] Create Docker Compose profiles (e.g., `--profile ruby`)
- [x] Verify compiled languages produce binary in `/out`
- [x] Verify Dockerfile recompiles live changes (dev variants)
- [ ] Verify service README.md contains consistent structure
- [ ] Verify HTML Structure consistency checklist

---

# 🌐 Reverse Proxy Layer

- [x] NGINX Reverse Proxy
- [x] index catalog of endpoints
- [x] conf.d per-endpoint config
- [ ] Global 404 branded page
- [ ] Global 500 branded page
- [ ] Proxy config linting in CI
- [ ] SPA fallback standardization
- [ ] Gzip / Brotli tuning
- [ ] Cache headers optimization

---

# 🐳 Docker & Compose Architecture

- [x] Separate Dockerfile and Dockerfile.dev (Option B lock-in)
- [x] Minimal compose formatting
- [x] corral network
- [x] howdy.localhost support
- [ ] Add non-root user to all Dockerfiles (planned hardening)
- [ ] Add healthchecks to containers
- [ ] Multi-stage builds standardized everywhere
- [ ] Image size audit
- [ ] Reproducible build validation
- [ ] Production compose profile separation

---

# 🧪 CI / GitHub Actions

- [x] Basic CI concept established
- [ ] Detect changed endpoints
- [ ] Docker layer caching (type=gha)
- [ ] Matrix builds per endpoint
- [ ] Infra-change full rebuild logic
- [ ] Nightly full ecosystem spin-up
- [ ] E2E job in CI
- [ ] Dockerfile lint (hadolint)
- [ ] Security scan (Trivy)
- [ ] Dependency audit job
- [ ] CI duration metrics tracking

---

# 🧪 Testing Infrastructure

## Root-Level

- [ ] E2E test framework
- [ ] Smoke test harness
- [ ] Endpoint discovery test
- [ ] Proxy routing validation
- [ ] CI test report aggregation

## Service-Level

- [ ] Native linter for each service
- [ ] Native test suite for each service
- [ ] AST testing where applicable
- [x] Version locking (partial in many endpoints)
- [ ] Purge unused code/comments
- [x] HTML templated output for web apps
- [ ] Consume `.env` and secrets properly
- [x] Production path handling `/<service>/`
- [x] Dev path handling `/`
- [ ] Standardized documentation format per service

---

# 🧪 Smoke Tests

- [ ] Confirm root dashboard is available
- [ ] Confirm endpoint returns 200
- [ ] Confirm `/<service>/` returns 200
- [ ] Confirm "Howdy, World!" in response
- [ ] Confirm `/healthz` if implemented

---

# 🧪 Negative Tests

- [ ] Confirm no public port leakage
- [ ] Confirm global 404 page
- [ ] Confirm endpoint-level 404
- [ ] Confirm global 500 page

---

# 📊 Performance & Benchmarking

- [ ] Benchmark endpoints
- [ ] RPS comparison
- [ ] Memory usage comparison
- [ ] Cold start timing
- [ ] Container startup timing
- [ ] Proxy performance comparison

---

# 📦 Shared Assets

- [ ] Root `/assets/` folder (future lock-in)
- [ ] Shared favicon
- [ ] Shared CSS baseline
- [ ] Shared JS helper
- [ ] Shared branding banner
- [ ] Shared logging format
- [x] Consistent port conventions
- [x] Consistent environment variable schema

---

# 🔐 Security Hardening

- [ ] Non-root containers
- [ ] Remove unnecessary OS packages
- [ ] Image vulnerability scanning
- [ ] Dependency audit
- [ ] CSP headers
- [ ] Rate limiting
- [ ] Secure headers audit

---

# 🚀 Deployment

- [x] Kamal 2 baseline configuration
- [x] GHCR support
- [x] DigitalOcean deploy model
- [ ] Production validation workflow
- [ ] Rollback validation
- [x] Bitwarden secrets model
- [ ] Zero-downtime verification

---

# 🧠 Builder (Future Critical System)

- [ ] Endpoint generator CLI
- [ ] CI config generator
- [ ] Dockerfile template generator
- [ ] Compose validator
- [ ] Endpoint health scanner
- [ ] Drift detection system
- [ ] Cross-endpoint dependency map
- [ ] Auto-doc generator

---

# 🏛 Languages & Framework Coverage

## Completed & Deployed

- [x] C# (ASP.NET)
- [x] Caddy
- [x] Clojure
- [x] Go
- [x] Java Spring Boot
- [x] JavaScript Inertia
- [x] jQuery
- [x] Stimulus
- [x] Vue
- [x] NGINX
- [x] Odin HTTP
- [x] Python FastAPI
- [x] Ruby on Rails
- [x] WEBrick
- [x] Rust Leptos
- [x] Zig

## Pending / Planned

- [ ] Ada
- [ ] AWK
- [ ] BASIC
- [ ] C
- [ ] C++
- [ ] COBOL
- [ ] Dart
- [ ] Elixir (Ecosystem beyond Phoenix/Bandit)
- [ ] Erlang
- [ ] Fortran
- [ ] Haskell
- [ ] Angular
- [ ] Ember
- [ ] Next.js
- [ ] Nuxt
- [ ] Node (plain)
- [ ] React
- [ ] Svelte
- [ ] TypeScript (full native endpoint)
- [ ] Vanilla JS
- [ ] Lisp
- [ ] Lua
- [ ] Oberon
- [ ] Perl
- [ ] PHP (Laravel, Symfony)
- [ ] Django
- [ ] Flask
- [ ] Typer
- [ ] Uvicorn standalone
- [ ] Rack
- [ ] Sinatra
- [ ] Falcon
- [ ] Axum
- [ ] Bash
- [ ] Swift
- [ ] Kotlin
- [ ] Scala
- [ ] Crystal
- [ ] gRPC demo
- [ ] WebSocket demo
- [ ] GraphQL demo

---

# 📖 Documentation & Story

- [ ] “Why These Languages” README section
- [ ] Bench / profile notes per language
- [ ] “Learning → Shipped” changelog
- [ ] Architecture overview diagram
- [ ] Builder roadmap document
- [ ] Deployment guide
- [ ] CI explanation document

---

