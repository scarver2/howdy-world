# elixir-bandit/Dockerfile

FROM elixir:1.16-alpine

WORKDIR /app

# Needed to compile deps, and to watch files (recompile/restart on change)
RUN apk add --no-cache \
    build-base \
    git \
    watchexec

ENV MIX_ENV=dev
ENV PORT=4000

# Cache deps
COPY mix.exs mix.lock ./
COPY config ./config

RUN mix local.hex --force \
    && mix local.rebar --force \
    && mix deps.get \
    && mix deps.compile

# Copy source (compose will mount over this in dev, but keeps image runnable standalone)
COPY lib ./lib

EXPOSE 4000

# In dev, restart the server whenever .ex/.exs files change
CMD ["sh", "-lc", "watchexec -r -e ex,exs -- mix run --no-halt"]
