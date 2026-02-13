# rust-leptos/Dockerfile

# ---- Build stage ----
FROM rust:1.93.1-slim AS build

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    pkg-config \
    libssl-dev \
    curl \
    git \
    clang \
    lld \
    && rm -rf /var/lib/apt/lists/*

RUN rustup target add wasm32-unknown-unknown
RUN cargo install --locked trunk

COPY . .

RUN trunk build --release --public-url /rust-leptos/

# ---- Runtime stage ----
FROM alpine:3.20

RUN apk add --no-cache lighttpd

COPY lighttpd.conf /etc/lighttpd/lighttpd.conf
COPY --from=build /app/dist /var/www/localhost/htdocs

EXPOSE 3000

CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
