# List of To-Dos for Howdy World

### Master Control Builder

- [ ] Build files and folders from CSV data
  - [ ] docker-compose.yml
  - [ ] nginx/conf.d/<language>.conf
  - [ ] Languages section of README of supported languages and frameworks
- [ ] Add Dockerfile for each language
- [ ] Add .gitignore for each language (source: https://github.com/github/gitignore)
- [ ] Add GitHub Actions for:
  - [ ] `docker compose config` (lint/validate)
  - [ ] building images
  - [ ] smoke testing endpoints
- [ ] Create Docker Compose profiles to run “just nginx + ruby” instead of the whole zoo:
  - [ ] e.g. `docker compose --profile ruby up --build`
- [ ] Verify service README.md contains consistent structure
  - [ ] Copyright
  - [ ] Link to portfolio
  - [ ] Made in Texas
- [ ] Verify HTML Structure
  - [ ] Outputs "Howdy from <service_name>"
  - [ ] Link back to <root>/index.html, if production

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
  - [ ] Phoenix
- [ ] Erlang
- [ ] Fortran
- [ ] Go
- [ ] Haskell
- [ ] Java
  - [ ] Spring
- [x] JavaScript
  - [ ] Angular
  - [ ] Ember
  - [x] Inertia
  - [ ] jQuery
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
- [ ] Zig

### NGINX

- [x] Reverse Proxy
- [x] index catalog of available endpoints
- [x] place individual endpoint's configuration into conf.d


## HTML

### Possible styling for pages
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
