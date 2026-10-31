# ruby-roda/app.rb
# frozen_string_literal: true

require "roda"

WEBPAGE = <<~HTML
  <!doctype html>
  <html>
    <head>
      <meta charset="utf-8">
      <title>Howdy from Ruby Roda</title>
    </head>
    <body>
      <h1>Howdy, World!</h1>
    </body>
  </html>
HTML

class App < Roda
  route do |r|
    r.root do
      response["content-type"] = "text/html; charset=utf-8"
      WEBPAGE
    end
  end
end
