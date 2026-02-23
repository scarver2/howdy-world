# ruby-webrick/Dockerfile
FROM ruby:4.0.1-alpine

WORKDIR /app

RUN gem install webrick

# Copy the Ruby Webrick script
COPY app.rb /app/app.rb

ENV PORT=3000

EXPOSE 3000

CMD ["ruby", "app.rb"]
