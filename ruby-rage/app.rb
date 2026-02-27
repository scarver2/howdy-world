# ruby-rage/app.rb
# frozen_string_literal: true

require "rage"

class App < Rage::Application
  route do |r|
    r.root do
      [
        200,
        { "Content-Type" => "text/html" },
        [<<~HTML]
          <!DOCTYPE html>
          <html>
          <head>
            <meta charset="utf-8">
            <title>Howdy from Rage</title>
          </head>
          <body>
            <h1>Howdy, World!</h1>
          </body>
          </html>
        HTML
      ]
    end
  end
end
