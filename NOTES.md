# Howdy World Notes

## Version 2 Prototype

I've come to the conclusion that NGINX as the reverse proxy and a master docker-compose file is cumbersome. I'm also considering using Angie (an NGINX OSS replacement) to run the root index page and assets.
I am also reviewing Caddy since it serves static assets and can access docker images too.

infra/compose.yml (Traefik)
angie/compose.yml (Angie + Traefik labels for / and /assets)
bin/up, bin/down (scripts above)

CLI workflow becomes:

```bash
bin/up          # everything in dev profile
bin/up --prod   # everything in prod profile
bin/up javascript-react elixir-phoenix
bin/down
```

## Branding

Project management: steps to call HowdyWorld branding “complete”

This is the checklist I’d use to declare the branding/theme effort done (v1):

1) Shared assets shipped

 /assets/howdy.css committed

 /assets/howdy-meta.js committed

 /assets/icons/ populated with the initial official tech set (SVG preferred)

 Root web server serves /assets/* reliably in dev + prod

2) Contract locked + documented

 Document howdyMetaVersion, serviceId, and required/optional fields (short spec in repo)

 Document icon naming convention and official-link requirements

 Document PT1 policy: plain-text endpoints remain plain-text (no theme)

3) Root homepage finished

 / uses the theme and has a curated “Endpoints” list

 Breadcrumb works and Home icon renders correctly

 “Stable links” point to canonical repo paths

4) Primary endpoints migrated (the “core set”)

 Decide the “primary endpoints” list (your top N: Ruby/Rails, JS/React, Elixir/Phoenix, Go, Zig, etc.)

 Each primary endpoint:

 has the semantic skeleton HTML (or equivalent SSR template)

 embeds the JSON bootstrap payload (howdyMetaVersion, serviceId, etc.)

 has correct breadcrumbs

 has correct icons and versions

 has stable links including nginx conf

 shows Dev/Prod status correctly (M3)

5) Builder script integration

 Builder can generate/update the JSON payload consistently

 Builder can generate the skeleton (or verify it) without drift

 Builder enforces ordering rules for icons (stack → build → infra)

6) Cross-browser + accessibility acceptance

 macOS Safari + Chrome + Firefox sanity pass

 Mobile layout sanity pass

 Keyboard navigation (focus states visible, breadcrumbs usable)

 Images have alt, icons have alt/title/aria-label

7) “Done” acceptance criteria

 Theme looks consistent across root + all primary endpoints

 No endpoint-specific CSS hacks

 Documentation updated (README + endpoint notes)

 One screenshot (or short GIF) added to README showing the branded panel (optional but nice)



## Standardization endpoints scripts
- bin/setup: fetch deps / submodules, verify prerequisites, print “Next steps”
- bin/build: build artifact(s)
- bin/run (when applicable): run dev server
- bin/clean: delete build artifacts
- bin/outdated: show version drift / upstream availability (best-effort)
- bin/update: update deps (submodules or vendored repos)

    endpoint/
    bin/
        _lib.sh
        setup
        build
        run
        clean
        outdated
        update

```bash
chmod +x bin/setup bin/build bin/run bin/clean bin/outdated bin/update
```

🧠 Keeping Architecturally Clean

### File Naming Conventions

> "There are only two hard things in Computer Science: cache invalidation and naming things"
> — Phil Karlton, Netscape Developer
> https://www.karlton.org/2017/12/naming-things-hard/

Example of good naming conventions:
    Layer	Name
    Folder	odin-http
    Binary	howdy-odin-http
    Docker service	odin-http
    NGINX location	/odin-http/
    Compose service	odin-http

