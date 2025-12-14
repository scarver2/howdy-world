require 'webrick'

PORT=ENV['PORT'] || 3000 # Let Docker set the port

WEBrick::HTTPServer.new(Port: PORT).tap { |srv|
  srv.mount_proc('/') do |request, response|
    response.body = "Howdy, World!"
  end
}.start
