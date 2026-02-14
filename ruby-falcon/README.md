# Ruby (via Falcon)

## Prerequisites

```bash
brew install ruby
```

## Docker

```bash
# docker build --no-cache -t howdy-ruby .
# docker run --rm -p 3000:80 howdy-ruby
```

## Execution

```bash
bundle exec falcon serve --port 3000
```

then visit https://localhost:3000 (accept the self-signed certificate)

&copy;2025 Stan Carver II

![Made in Texas](https://raw.githubusercontent.com/scarver2/howdy-world/main/nginx/www/made-in-texas.png)
