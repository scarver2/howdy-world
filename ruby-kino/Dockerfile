# ruby-kino/Dockerfile
FROM ruby:4.0.6-alpine

WORKDIR /app

RUN apk add --no-cache build-base

COPY Gemfile ./
RUN bundle install

COPY . .

ENV PORT=3000

EXPOSE 3000

CMD ["bundle", "exec", "kino", "-C", "kino.rb", "config.ru"]
