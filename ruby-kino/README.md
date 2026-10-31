# Ruby (via Kino)

[Kino](https://yaroslav.io/opensource/kino) is a Rack 3 web server for Ruby 4.0+ with a Rust Tokio/Hyper front end and Ractor-parallel Ruby workers.

This example intentionally uses a `Ractor.shareable_proc` and runs Kino in `:ractor` mode.

## Prerequisites

Ruby 4.0+

```bash
brew install ruby
```

## Run locally

```bash
bundle install
bundle exec kino -C kino.rb config.ru
```

then visit http://localhost:3000

Kino can also verify whether the Rack app is Ractor-compatible:

```bash
bundle exec kino --check -C kino.rb config.ru
```

## Run in Docker

```bash
docker compose up --build --remove-orphans
```

then visit http://localhost:3000

&copy;2026 Stan Carver II

![Made in Texas](https://raw.githubusercontent.com/scarver2/howdy-world/master/_dashboard/www/assets/made-in-texas.png)
