# ruby-kino/app.rb
# frozen_string_literal: true

WEBPAGE = <<~HTML.freeze
  <!doctype html>
  <html>
    <head>
      <meta charset="utf-8">
      <title>Howdy from Ruby Kino</title>
    </head>
    <body>
      <h1>Howdy, World!</h1>
    </body>
  </html>
HTML

APP = Ractor.shareable_proc do |_env|
  [200, { "content-type" => "text/html; charset=utf-8" }.freeze, [WEBPAGE].freeze]
end
