# elixir-hologram/Dockerfile
FROM elixir:1.19-alpine

WORKDIR /app

RUN apk add --no-cache build-base git nodejs npm

ENV MIX_ENV=dev \
    HOLOGRAM_START=1 \
    PORT=4000

COPY mix.exs ./
RUN mix local.hex --force \
    && mix local.rebar --force \
    && mix deps.get \
    && mix deps.compile

COPY config ./config
COPY lib ./lib

RUN mix compile

EXPOSE 4000

CMD ["mix", "holo"]
