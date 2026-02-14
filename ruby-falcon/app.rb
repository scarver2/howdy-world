# ruby-falcon/app.rb
# frozen_string_literal: true

WEBPAGE = <<~HTML
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Howdy from Ruby Falcon</title>
  </head>
  <body>
    <h1>Howdy, World!</h1>
  </body>
</html>
HTML

class App
  def call(env)
    [200, { "content-type" => "text/html; charset=utf-8" }, [WEBPAGE]]
  end
end
