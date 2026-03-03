# Developer Notes for Ruby Rage

## Minimal Example

As of February 2026, Ruby Rage is intended to a highly-performant API framework. It can serve HTML responses, but being a web server is not its primary purpose. My original implementation below, just "hacks" the router. The final implementation leverages Rage's fibers for concurrency and performance.

```ruby
# ruby-rage/app.rb
# frozen_string_literal: true

require 'rage'

class App < Rage::Application
  route do |r|
    r.root do
      [
        200,
        { 'Content-Type' => 'text/html' },
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
```

## Rack and Rage

Rage is Rack-compliant, so it can be used with Rack middleware. However, this imposes some limitations on Rage's performance benefits. Rack does not support the use of fibers for concurrency. In the final implementation, it uses Rage's native server to leverage its fibers for concurrency and performance.
