# ruby-webrick/Dockerfile
FROM ruby:4.0.10-alpine

# Pin RubyGems and Bundler to 4.1.0 (ruby:4.0.10 ships 4.0.20 of both)
RUN gem update --system 4.1.0 --no-document && \
    gem install bundler:4.1.0 --no-document

WORKDIR /app

RUN gem install webrick

# Copy the Ruby Webrick script
COPY app.rb /app/app.rb

ENV PORT=3000

EXPOSE 3000

CMD ["ruby", "app.rb"]
