# elixir-phoenix/Dockerfile

FROM elixir:1.18.4-alpine

WORKDIR /app

# Build + file-watching (dev)
RUN apk add --no-cache \
    build-base \
    git \
    watchexec

ENV MIX_ENV=dev \
    PORT=4000

# Cache deps
COPY mix.exs mix.lock ./
COPY config ./config
RUN mix local.hex --force \
    && mix local.rebar --force \
    && mix deps.get \
    && mix deps.compile

# Copy the rest (compose bind-mount will override in dev, but keeps image runnable)
COPY lib ./lib
COPY rel ./rel

EXPOSE 4000

# Restart on change (keeps it lightweight)
CMD ["sh", "-lc", "watchexec -r -e ex,exs -- mix run --no-halt"]
