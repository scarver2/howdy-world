# ruby-falcon/Dockerfile
FROM ruby:4.0.1-alpine AS builder

WORKDIR /app

# RUN apk add --no-cache build-base
RUN apk add --no-cache \
    build-base \
    openssl-dev \
    pkgconfig \
    && gem install json openssl falcon \
    && apk del build-base \
    && rm -rf /var/cache/apk/* 

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

ENV PORT=3000

EXPOSE 3000

CMD ["falcon", "serve", "--bind", "http://0.0.0.0:3000"]
