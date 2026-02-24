# odin-http/Dockerfile
FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    clang \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

# Build Odin using system clang
RUN git clone https://github.com/odin-lang/Odin.git \
    && cd Odin \
    && git checkout b942f72cb \
    && ./build_odin.sh release

ENV ODIN_ROOT=/opt/Odin
ENV PATH="/opt/Odin:${PATH}"

WORKDIR /app
COPY . .

RUN odin build main.odin -file \
    -collection:deps=./deps \
    -o:speed \
    -out:howdy-odin-http

EXPOSE 6969

CMD ["./howdy-odin-http"]
