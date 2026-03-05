# nim-jester/Dockerfile

FROM nimlang/nim:2.0.4-alpine AS build

WORKDIR /app

COPY . .

RUN nimble install -y jester
RUN nim c -d:release app.nim

FROM alpine:3.19

WORKDIR /app

COPY --from=build /app/app /app/app

EXPOSE 5000

CMD ["./app"]
