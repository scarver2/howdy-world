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
cd vendor/odin-http
git fetch
git checkout main   # or whatever branch you want to track
git pull
cd ../..
git add vendor/odin-http
git commit -m "Bump odin-http submodule"
```

Or one-liner-ish:

```bash
git submodule update --remote --merge vendor/odin-http
git add vendor/odin-http
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

If you want, I can suggest a Howdy World convention: `vendor/` as submodules + a root `bin/bootstrap` step that runs `git submodule update --init --recursive` so nobody forgets.

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
