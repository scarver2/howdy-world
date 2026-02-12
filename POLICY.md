# Howdy World Engineering Policy

This repo has reached the point where consistency matters more than “whatever works.”  
This policy defines a repeatable contract for adding endpoints without creating drift, tight coupling, or hidden build/runtime dependencies.

## Guiding Principle

1. Let Separation of Concerns prevail. The orchestration (Docker Compose) and router (NGINX) should not have knowledge of the internal workings of enpoints.
2. Endpoints should respond with HTML via port or ASCII plain text via STDIO.
3. The conductor/router should set environment variables to manipulate endpoint responses e.g. Docker profiles, environment variables.
4. Endpoints should have no knowledge of other endpoints _except_ for client-side SPAs, databases.


**The “front door” owns routing.**  
Endpoints should not require the root compose file or root router to understand their internal build toolchain.

In other words:

- The router decides: **what URL maps to what endpoint**
- The endpoint decides: **how it runs internally**
- The contract between them stays simple and stable

This keeps the system maintainable whether the front door is **NGINX today** or **Traefik tomorrow**.

---

## Endpoint Types

Every endpoint must conform to exactly one of these contracts:

### Contract A: Static Artifact Endpoint
A static endpoint produces a folder of static files that can be served directly by the front door.

**Definition**
- The endpoint outputs production artifacts to:  
  `dist/<endpoint>/` (preferred)  
  OR `public/<endpoint>/` (acceptable)

**Front door behavior**
- The front door serves the folder at:
  `/<endpoint>/`

**Examples**
- React (Vite build output)
- Vue/Svelte build output
- Any compiled-to-static site

**SPA rule**
If the endpoint is a Single Page App (React/Vue/etc.), the front door must provide SPA fallback so deep links work:
- Unknown paths under `/<endpoint>/...` return the endpoint’s `index.html`

---

### Contract B: Web Service Endpoint
A web-service endpoint runs a server inside its container (dynamic).

**Definition**
- The endpoint listens on a single internal port (e.g., `3000`, `8080`, etc.)
- It must serve its app under its base path, OR tolerate reverse proxy base-path rules.

**Front door behavior**
- The front door reverse-proxies requests at:
  `/<endpoint>/`
  to the endpoint container’s port.

**Examples**
- Ruby/Rails
- Phoenix
- Zig/Go HTTP services
- Any backend runtime service

---

## Front Door Responsibilities

The front door (currently NGINX) is the authoritative routing layer. It is responsible for:

- Mapping `/<endpoint>/` to the correct target (static dir or upstream)
- SPA fallback for SPAs
- Consistent headers (as desired later)
- Optional gzip/brotli/caching later
- Keeping routing config and structure consistent

The front door is **not** responsible for:
- Knowing how an endpoint builds (Bun vs npm vs Maven vs Mix)
- Running build commands for endpoints
- Mounting complicated endpoint internals beyond the standard artifact folder

---

## Directory Conventions

### Endpoint folder
Each endpoint lives at repo root:

- `<endpoint>/` (e.g., `javascript-react/`, `ruby/`, `zig/`)

### Static artifacts
Static endpoints publish artifacts in one of these forms:

Preferred:
- `dist/<endpoint>/` (repo root, shared pattern)

Acceptable (endpoint-local):
- `<endpoint>/dist/` (only if you also provide a predictable mount path into the front door)

**Policy preference**
To minimize mounts and complexity, we prefer a single shared artifact tree:
- `dist/<endpoint>/`

This keeps the front door wiring simple and repeatable.

---

## NGINX Config Placement

Routing config lives in one place:

- `nginx/conf.d/<endpoint>.conf`

Do not scatter endpoint conf files across other paths.

---

## When an Endpoint “Needs a Webserver”

Most static endpoints do not need their own web server in production if the front door serves the artifacts (Contract A).

However, there are cases where an endpoint wants/needs to self-serve static content:
- you want the endpoint to be runnable outside the full Howdy World stack
- you want to demo a standalone container
- you want alternate routing behavior
- you want to decouple static serving from the front door for portability

### Approved minimal webservers inside endpoints

#### lighttpd (preferred minimal static server)
lighttpd is a strong “tiny webserver” option for endpoints that want a self-contained server:
- lightweight
- simple configuration
- good static performance
- supports SPA fallback with rewrite rules

Use lighttpd in endpoints when:
- the endpoint must be “docker run” runnable as a standalone static server
- you want a smallest-possible runtime image for a static artifact

#### nginx (acceptable)
nginx inside an endpoint is allowed, but we avoid creating a habit of “nginx proxy -> nginx endpoint” unless there’s a clear reason. It’s not wrong; it’s just more config surface area.

#### Caddy (acceptable)
Caddy is acceptable for endpoints that want extremely simple configs, especially if HTTPS becomes a goal. It’s a bit heavier than lighttpd but very ergonomic.

---

## Stability Rules

1. The front door routing contract should not depend on endpoint build tools.
2. Static endpoints must publish deterministic artifacts in a predictable location.
3. Dynamic endpoints must expose one stable internal port and be reverse-proxy compatible.
4. Endpoint additions should require:
   - one front door config file (`nginx/conf.d/<endpoint>.conf`)
   - one service entry in compose
   - no special-case wiring beyond the contract

---

## Future (Builder + Testing)

When Howdy World Builder is implemented:

- Each endpoint should include test coverage where its ecosystem supports it.
- The repo should include a root-level end-to-end test that validates the full production stack via the front door.

---

## Summary

We optimize for:
- repeatability
- low coupling
- minimal drift
- easy endpoint onboarding

**Front door owns routing. Endpoints own implementation. The contract stays stable.**

