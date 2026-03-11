# swift-vapor/Dockerfile

FROM swift:6.2.4-jammy AS builder

WORKDIR /build
COPY . .

RUN swift build -c release

FROM swift:6.2.4-jammy-slim

WORKDIR /app

COPY --from=builder /build/.build/release/App .

EXPOSE 8080

CMD ["./App"]
