# ruby-rage/Dockerfile

FROM ruby:4.0.1-slim

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    git \
    libyaml-dev \
    pkg-config && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile* ./

RUN bundle config set deployment 'true' \
    && bundle config set without 'development test' \
    && bundle install

COPY . .

EXPOSE 3000

ENV RAGE_ENV=production \
    RAGE_PORT=3000 \
    RAGE_BIND=0.0.0.0

CMD ["bundle", "exec", "rage", "s"]
