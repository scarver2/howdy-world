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

### Security

- Internal endpoint containers SHALL communicate over HTTP only.
- TLS termination occurs exclusively at the root front door.
- No endpoint ports are ever exposed to the public.
- No endpoint container manages certificates.
- Endpoint containers run with USER policy, *NEVER* as root user

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

## Dockerfile Conventions

Opted-for clarity over cleverness, so Howdy World uses separate Dockerfiles for production and development instead of multi-stage build profiles in a monolithic Dockerfile.

- Dockerfile = production only (build + runtime)
- Dockerfile.dev = development only (dev server, hot-reloading, bind mounts, etc.)

### Local Development:
```bash
cd <endpoint>
docker compose -f compose.dev.yml up --build --remove-orphans
```

### Production:
```bash
cd <endpoint>
docker compose up --build --remove-orphans
```

---

## Summary

We optimize for:
- teachability
- reusability
- repeatability
- low coupling
- minimal drift
- easy endpoint onboarding

**Front door owns routing. Endpoints own implementation. The contract stays stable.**

---

From my work on Odin HTTP endpoint:

Yes.

A **git submodule** keeps a *real, separate Git repo* inside your repo, and your repo records **a specific commit SHA** of that submodule.

What that means in practice:

* The submodule has its **own remote** (`https://github.com/laytan/odin-http`) and **its own history**.
* Your main repo doesn’t “copy” the dependency; it **pins** it to a commit.
* Updating the dependency is an explicit action: you move the submodule forward to a newer commit, then commit that new SHA in your main repo.

### Day-to-day submodule lifecycle

**Clone your repo (fresh checkout):**

```bash
git clone <your-repo>
git submodule update --init --recursive
```

**Pull changes later (including submodules):**

```bash
git pull
git submodule update --init --recursive
```

**Update the dependency to latest (or a branch) explicitly:**

```bash
cd deps/odin-http
git fetch
git checkout main   # or whatever branch you want to track
git pull
cd ../..
git add deps/odin-http
git commit -m "Bump odin-http submodule"
```

Or one-liner-ish:

```bash
git submodule update --remote --merge deps/odin-http
git add deps/odin-http
git commit -m "Bump odin-http submodule"
```

### The “pin” behavior (important)

Even if `odin-http` moves forward upstream, your repo **stays on the exact commit you pinned** until you bump it. That’s good for reproducible builds.

### Tradeoffs (quick heads-up)

* ✅ Great when you want “dependency as a repo” and you may contribute upstream.
* ✅ Keeps your repo smaller than vendoring full history manually.
* ⚠ Requires devs/CI to remember `--init --recursive`.
* ⚠ Can be mildly annoying with tooling if people aren’t used to submodules.

If you want the simplest possible life for contributors/CI, the alternative is **vendor the code** (copy it in), but then you lose the clean “independent repo” relationship.

If you want, I can suggest a Howdy World convention: `deps/` as submodules + a root `bin/bootstrap` step that runs `git submodule update --init --recursive` so nobody forgets.

## Endpoint

### Docker
- dev environment should watch for file changes and restart
- prod environment must never include development resources to be lightweight and secure.

#### Dockerfile Organization

Keep Dockerfiles lean.

```Dockerfile
# <endpoint>/.dockerignore

# Root-level docs
/*.md

# Compose
compose.yml
compose.dev.yml

# Dockerfiles
Dockerfile
Dockerfile.dev

# Docker ignore itself
.dockerignore
```

#### Docker Compose Organization

Keep Docker Compose files focused on environment-specific configuration.

# <endpoint>/compose.yml
# <endpoint>/compose.dev.yml
