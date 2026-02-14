# Ruby (via Falcon)

## Prerequisites

```bash
brew install ruby
```

## Run locally

```bash
bundle install
bundle exec falcon serve
```

then visit https://localhost:9292 (accept the self-signed certificate)

## Run in Docker

```bash
docker compose up --build --remove-orphans
```

then visit https://localhost:3000

&copy;2026 Stan Carver II

![Made in Texas](https://raw.githubusercontent.com/scarver2/howdy-world/main/nginx/www/made-in-texas.png)
