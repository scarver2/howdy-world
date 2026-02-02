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
- [ ] Test that all endpoint README files contain consistant structure

### Languages and Frameworks

- [ ] Ada
- [ ] AWK
- [ ] C
- [ ] C++
- [ ] C#
- [ ] Dart
- [ ] Elixir
  - [ ] Phoenix
- [ ] Erlang
- [ ] Fortran
- [ ] Go
- [ ] Haskell
- [ ] Java
- [ ] JavaScript
  - [x] StimulusJS
- [ ] Lisp
- [ ] Lua
- [ ] Node.js
- [ ] Oberon
- [ ] Odin
- [ ] Perl
- [ ] PHP
- [ ] Python
  - [ ] Flask
  - [ ] FastAPI
  - [ ] Django
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
- [ ] Swift
- [ ] Zig

### NGINX

- [x] Reverse Proxy
- [x] index catalog of available endpoints
- [x] place individual endpoint's configuration into conf.d
