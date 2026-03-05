# go-fiber/Dockerfile
# FROM golang:1.25.0

# WORKDIR /app

# COPY go.mod go.sum ./
# RUN go mod download

# COPY . .

# RUN go build -o main .

# EXPOSE 3000

# CMD ["./main"]


# go/Dockerfile

# Build
FROM golang:1.25-alpine AS build
WORKDIR /src
# COPY go.mod ./
COPY . .
RUN go build -trimpath -ldflags="-s -w" -o /out/howdy .

# Run
FROM alpine:3.20
# RUN adduser -D -H -u 10001 appuser
# USER appuser
# WORKDIR /app
COPY --from=build /out/howdy /app/howdy
ENV PORT=3000
EXPOSE 3000
CMD ["/app/howdy"]
