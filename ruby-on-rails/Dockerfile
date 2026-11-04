# ruby-on-rails/Dockerfile
# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production, not development.
# docker build -t my-app .
# docker run -d -p 127.0.0.1:3000:3000 --name my-app my-app   # loopback only; Puma listens on 3000
# Optional: -e SECRET_KEY_BASE=<128 hex chars> for sessions that survive a restart.

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=4.0.1
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git pkg-config libyaml-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git
#  && \
# bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
# RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
# RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Final stage for app image
FROM base

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
# RUN groupadd --system --gid 1000 rails && \
#     useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
#     chown -R rails:rails db log storage tmp
# USER 1000:1000

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000

# The default Rails Dockerfile uses `./bin/rails server`, but when using Puma, 
# they recommend using bundle exec puma. ref: https://github.com/puma/puma#rails
# No committed master.key or credentials: the demo only needs secret_key_base.
# Use SECRET_KEY_BASE when the operator provides one; otherwise generate a random
# one per container start (the equivalent of `openssl rand -hex 64`). It stays the
# same for the container's lifetime; every new start (including `docker restart`)
# invalidates existing sessions and signed cookies. That is fine for this stateless
# demo endpoint only: a stateful production Rails app needs a persistent secret from
# its secret store, never one generated at startup.
CMD ["sh", "-c", "export SECRET_KEY_BASE=\"${SECRET_KEY_BASE:-$(ruby -rsecurerandom -e 'print SecureRandom.hex(64)')}\"; exec bundle exec puma -C config/puma.rb"]
