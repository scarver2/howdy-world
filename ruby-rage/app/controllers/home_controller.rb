# ruby-rage/app/controllers/home_controller.rb
# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    render plain: <<~HTML
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
    headers["content-type"] = "text/html; charset=utf-8"
  end
end
