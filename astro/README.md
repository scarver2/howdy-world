# Astro 7.3

Howdy World endpoint implemented with Astro 7.3.

## Development

```bash
docker compose -f compose.dev.yml up --build --remove-orphans
```

Open http://localhost:4321/astro/

## Production

```bash
docker compose up --build --remove-orphans
```

Open http://localhost:4321/astro/

Production builds the static Astro artifact and serves it with lighttpd.
