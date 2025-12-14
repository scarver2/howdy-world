FROM ruby:alpine

WORKDIR /app

RUN gem install webrick

# Copy the Ruby Webrick script
COPY howdy.rb /app/howdy.rb

ENV PORT=3000

EXPOSE $PORT

CMD ["ruby", "howdy.rb"]
