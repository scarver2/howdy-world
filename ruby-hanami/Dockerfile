FROM ruby:3.4.5-slim

WORKDIR /app

COPY Gemfile ./
RUN bundle install

COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-b", "tcp://0.0.0.0:3000", "config.ru"]
