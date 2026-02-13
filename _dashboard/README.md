# Howdy World Dashboard (Homepage) README

Howdy World homepage endpoint.

- Serves `www/` (index.html + assets) via lighttpd on port 8080
- Intended to be reverse-proxied from the root router (NGINX/Traefik/Angie)

## Important
The files below are placeholders in this generated bundle (0 bytes). Copy the real ones from your existing `nginx/www/`:

- favicon.ico
- apple-touch-icon.png
- apple-touch-icon-precomposed.png
- howdy-world.png
- made-in-texas.png

## Run (dev)
From `_dashboard/`:

  docker compose -f compose.dev.yml up --build --remove-orphans

## Run (prod)
  docker compose -f compose.yml up --build --remove-orphans
