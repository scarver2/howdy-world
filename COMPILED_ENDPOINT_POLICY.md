Excellent. This deserves precision.

Below is a formal, enforceable policy document you can either:

* Append to `CONVENTIONS.md`
* Or place in `COMPILED_ENDPOINT_POLICY.md`

This is written in the same tone as your existing conventions — deterministic, enforceable, zero fluff.

---

# Howdy World — Compiled Endpoint Policy

This policy governs all endpoints whose primary implementation language is **compiled** (native or VM-compiled).

Compiled endpoints include, but are not limited to:

* C
* C++
* Rust
* Go
* Zig
* Swift
* Nim
* Fortran
* Odin
* JVM-based languages (Java, Kotlin, Scala, etc.)
* .NET-based languages (C#, F#, etc.)

---

## 1. Build Requirements

### 1.1 Deterministic Builds

Compiled endpoints must:

* Build inside Docker
* Not depend on host toolchains
* Not require interactive setup
* Not require external proprietary tooling unless marked `nonserviceable`

The Dockerfile must:

* Fully define the toolchain
* Produce a runnable artifact
* Avoid unnecessary layers

---

### 1.2 Multi-Stage Builds (Preferred)

Where practical, compiled endpoints should use:

```dockerfile
# build stage
# runtime stage
```

Final runtime images should:

* Contain only the compiled artifact
* Avoid including compilers or build toolchains
* Minimize attack surface

---

## 2. Runtime Mode

All compiled endpoints exposed through the root reverse proxy must:

* Run in **production mode**
* Not run development watchers
* Not run hot reload servers
* Not expose debug ports

Standalone execution may allow development mode.

---

## 3. HTTP Contract

Compiled endpoints that serve HTTP must:

* Listen on a fixed internal port
* Bind to `0.0.0.0`
* Respond with valid HTTP headers
* Follow the strict HTML Output Contract

### Required HTML

```html
<title>Howdy from <service name></title>
<h1>Howdy, World!</h1>
```

No styling. No additional content.

---

## 4. Port Management

Ports must:

* Be defined in `languages.csv`
* Be injected into NGINX config via ERB
* Not be hard-coded inside reverse proxy templates

The compiled binary may:

* Hard-code its listening port
* Or read from environment variable

But the project must remain consistent.

---

## 5. Artifact Placement

If the build produces a binary artifact, it must:

* Be stored in `/app` (or similar predictable path)
* Not be committed to source control
* Not be built on the host machine

If cross-compiling (e.g., macOS → Linux), output must go to:

```
dist/<platform>/
```

These artifacts are:

* Ignored by git
* Not part of Docker context unless intentional

---

## 6. Service Type Classification

Compiled languages must use one of:

* `proxy` — binary runs HTTP server
* `fastcgi` — binary runs via FastCGI
* `nonserviceable` — cannot practically serve HTTP

No ambiguous classifications allowed.

---

## 7. Resource Discipline

Compiled endpoints must:

* Avoid excessive runtime dependencies
* Avoid unnecessary dynamic linking where static linking is reasonable
* Avoid bundling dev libraries in runtime images

Lean images are preferred.

---

## 8. Logging

Compiled endpoints must:

* Log to STDOUT
* Not log to files inside containers
* Not daemonize

Containers run in foreground only.

---

## 9. Failure Conditions

Compiled endpoints are considered invalid if they:

* Require manual build steps
* Depend on system packages outside Dockerfile
* Serve non-compliant HTML
* Fail to bind properly in container
* Expose dev servers at root

---

## 10. Philosophy

Compiled endpoints in Howdy World are:

* Demonstrations of language capability
* Not production-optimized frameworks
* Minimal by design
* Intentionally boring

The goal is consistency across ecosystems, not feature richness.

---

If a compiled endpoint deviates from these rules, it must justify the deviation in `notes` within `languages.csv`.

---

If you’d like next-level refinement, we can:

* Add a **“VM Endpoint Policy”**
* Add a **“Static Asset Endpoint Policy”**
* Or unify all of this into a formal “Service Taxonomy”

Deputy is ready to formalize the empire.

