# zig/Dockerfile

FROM --platform=$BUILDPLATFORM denisgolius/zig:0.15.2 AS build
ARG TARGETARCH
WORKDIR /app

# Copy your Zig source
COPY howdy.zig ./howdy.zig

# Cross-compile for the target platform rather than the build host
RUN case "$TARGETARCH" in \
        amd64) ZIG_TARGET=x86_64-linux ;; \
        arm64) ZIG_TARGET=aarch64-linux ;; \
        *) echo "unsupported TARGETARCH: '$TARGETARCH'" >&2; exit 1 ;; \
    esac \
    && mkdir -p /out \
    && zig build-exe howdy.zig -target "$ZIG_TARGET" -O ReleaseSafe -fstrip -femit-bin=/out/howdy

# ---- runtime stage ----
FROM debian:bookworm-slim AS runtime
WORKDIR /app

COPY --from=build /out/howdy /usr/local/bin/howdy

EXPOSE 3000
CMD ["howdy"]

