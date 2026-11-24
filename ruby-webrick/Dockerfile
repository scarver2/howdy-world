# ruby-webrick/Dockerfile
FROM ruby:4.0.10-alpine

# Pin RubyGems and Bundler to 4.1.0 (ruby:4.0.10 ships 4.0.20 of both)
RUN gem update --system 4.1.0 --no-document && \
    gem install bundler:4.1.0 --no-document

WORKDIR /app

# Install WEBrick from the lockfile (frozen) so the image matches Gemfile.lock
COPY Gemfile Gemfile.lock ./

RUN bundle config set frozen 'true' \
    && bundle config set without 'development test' \
    && bundle install

# Copy the Ruby Webrick script
COPY app.rb /app/app.rb

ENV PORT=3000

EXPOSE 3000

CMD ["bundle", "exec", "ruby", "app.rb"]
