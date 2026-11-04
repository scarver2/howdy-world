module HowdyWorld
  module Actions
    module Home
      class Show < HowdyWorld::Action
        def handle(_request, response)
          response.format = :html
          response.body = <<~HTML
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="utf-8">
                <title>Howdy from Hanami</title>
            </head>
            <body>
                <h1>Howdy, World!</h1>
            </body>
            </html>
          HTML
        end
      end
    end
  end
end
