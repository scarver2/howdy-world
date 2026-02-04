# zig/Dockerfile

FROM denisgolius/zig:0.15.2 AS build
WORKDIR /app

# Copy your Zig source
COPY howdy.zig ./howdy.zig

# Build a simple executable
RUN mkdir -p /out \
    && zig build-exe howdy.zig -O ReleaseSafe -fstrip -femit-bin=/out/howdy

# ---- runtime stage ----
FROM debian:bookworm-slim AS runtime
WORKDIR /app

COPY --from=build /out/howdy /usr/local/bin/howdy

EXPOSE 3000
CMD ["howdy"]

