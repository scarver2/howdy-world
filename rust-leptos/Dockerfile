FROM rust:1.84-slim AS build
WORKDIR /app

# Cache dependencies
COPY Cargo.toml ./
RUN mkdir -p src && printf "fn main() {}\n" > src/main.rs
RUN cargo build --release

# Build app
COPY src ./src
RUN cargo build --release

FROM debian:bookworm-slim
WORKDIR /app

# TLS roots (handy if you later call out to HTTPS APIs)
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /app/target/release/rust-leptos /app/rust-leptos

EXPOSE 3000
CMD ["/app/rust-leptos"]
