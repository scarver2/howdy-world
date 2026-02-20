# ruby-webrick/app.rb
require 'webrick'

PORT=ENV['PORT'] || 3000 # Let Docker set the port

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

WEBrick::HTTPServer.new(Port: PORT).tap { |srv|
  srv.mount_proc('/') do |request, response|
    response.body = WEBPAGE
  end
}.start
