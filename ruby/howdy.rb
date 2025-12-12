require 'webrick'

WEBrick::HTTPServer.new(Port: 3000).tap { |srv|
  srv.mount_proc('/') do |request, response|
    response.body = "Howdy, World!"
  end
}.start