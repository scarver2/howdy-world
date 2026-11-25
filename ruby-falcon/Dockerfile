# ruby-falcon/Dockerfile
FROM ruby:4.0.10-alpine

WORKDIR /app

RUN apk add --no-cache \
    build-base \
    openssl-dev \
    pkgconfig

# Pin RubyGems and Bundler to 4.1.0 (ruby:4.0.10 ships 4.0.20 of both)
RUN gem update --system 4.1.0 --no-document && \
    gem install bundler:4.1.0 --no-document

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

ENV PORT=3000

EXPOSE 3000

CMD ["falcon", "serve", "--bind", "http://0.0.0.0:3000"]
