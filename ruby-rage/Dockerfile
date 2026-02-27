# ruby-rage/Dockerfile
FROM ruby:4.0.1-alpine

WORKDIR /app

RUN apk add --no-cache build-base

COPY Gemfile* ./
RUN bundle install --without development test

COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0", "-p", "3000"]