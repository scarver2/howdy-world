# Howdy from Hologram!

A minimal [Hologram](https://hologram.page/) endpoint for Howdy World. Hologram runs on Phoenix and compiles client-side Elixir to JavaScript while server-rendering the initial page.

## Prerequisites

- Elixir 1.19+
- OTP 28.1+
- Node.js 20+

## Run locally

```bash
mix deps.get
mix holo
```

Or with Docker:

```bash
docker compose up --build
```

Then visit http://localhost:4000.

Through the Howdy World root proxy, visit http://localhost/elixir-hologram/.

&copy;2026 [Stan Carver II](http://stancarver.com)

![Made in Texas](https://raw.githubusercontent.com/scarver2/howdy-world/master/_dashboard/www/assets/made-in-texas.png)
