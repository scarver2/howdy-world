# crystal-kemal/Dockerfile

FROM crystallang/crystal:latest

WORKDIR /app

COPY shard.yml shard.lock* ./
RUN shards install

COPY src ./src

RUN crystal build src/server.cr --release --no-debug -o server

EXPOSE 3000

CMD ["./server"]
