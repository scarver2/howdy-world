FROM elixir:1.16-alpine

WORKDIR /app

# Build deps for Hex/Rebar + compiling deps
RUN apk add --no-cache build-base git

ENV MIX_ENV=prod

COPY mix.exs mix.lock ./
COPY config ./config

RUN mix local.hex --force && mix local.rebar --force
RUN mix deps.get --only prod
RUN mix deps.compile

COPY lib ./lib
RUN mix compile

EXPOSE 4000
ENV PORT=4000

CMD ["mix", "run", "--no-halt"]

