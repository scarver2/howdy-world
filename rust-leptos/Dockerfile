# rust-leptos/Dockerfile

# ---- build stage ----
FROM rust:1.90-slim AS build

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    pkg-config \
    libssl-dev \
    clang \
    lld \
    && rm -rf /var/lib/apt/lists/*

# Install wasm target for CSR
RUN rustup target add wasm32-unknown-unknown

# Install tools
RUN cargo install --locked trunk \
    && cargo install --locked wasm-bindgen-cli

# Copy the project into the image (THIS is what you're missing today)
COPY Cargo.toml Cargo.lock* ./
COPY Trunk.toml index.html ./
COPY src ./src
# If you have these, keep them; if not, remove the lines
# COPY public ./public
# COPY style ./style

# Build release assets (Trunk.toml already sets public_url=/rust-leptos/)
RUN trunk build --release --dist /dist

# 🔒 Prove they exist at build time (this will FAIL the build if not installed where expected)
# RUN /usr/local/cargo/bin/trunk --version \
#     && /usr/local/cargo/bin/wasm-bindgen --version \
#     && /usr/local/cargo/bin/cargo --version \
#     && /usr/local/cargo/bin/rustc --version || true

# Use absolute path so PATH/env/volumes can't break it
CMD ["/usr/local/cargo/bin/trunk", "serve", "--address", "0.0.0.0", "--port", "3000"]
