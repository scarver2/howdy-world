# odin/Dockerfile

FROM primeimages/odin:latest AS build

WORKDIR /app
COPY . .

RUN odin build main.odin -file -o:speed -out:server

FROM debian:bookworm-slim

WORKDIR /app
COPY --from=build /app/server .

EXPOSE 6969

CMD ["./server"]
