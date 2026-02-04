# List of To-Dos for Howdy World

### Master Control Builder

- [ ] Build files and folders from CSV data
  - [ ] docker-compose.yml
  - [ ] nginx/conf.d/<language>.conf
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
- [ ] C# (.NET)
- [ ] COBOL
- [ ] Dart
- [ ] Elixir
  - [x] Bandit
  - [ ] Phoenix
- [ ] Erlang
- [ ] Fortran
- [x] Go
- [ ] Haskell
- [ ] Java
  - [ ] Spring
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
- [ ] Oberon
- [ ] Odin
- [ ] Perl
- [ ] PHP
  - [ ] Laravel
  - [ ] Symfony
- [ ] Python
  - [ ] Django
  - [ ] Flask
- [x] Ruby
  - [ ] Cuba
  - [ ] Jekyll
  - [ ] Middleman
  - [ ] Rack
  - [x] Ruby on Rails
  - [ ] Sinatra
  - [x] WEBrick
- [ ] Rust
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
