# crystal-kemal/src/server.cr

require "kemal"

get "/" do
  <<-HTML
  <!DOCTYPE html>
  <html>
  <head>
    <meta charset="utf-8">
    <title>Howdy from Crystal Kemal</title>
  </head>
  <body>
    <h1>Howdy, World!</h1>
  </body>
  </html>
  HTML
end

Kemal.run
