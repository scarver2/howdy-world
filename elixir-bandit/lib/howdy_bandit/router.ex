# elixir-bandit/lib/howdy_bandit/router.ex

defmodule HowdyBandit.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  @html """
  <!doctype html>
  <html lang="en">
    <head>
      <meta charset="utf-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1" />
      <title>Howdy from the Elixir Bandit!</title>
    </head>
    <body>
      <h1>Howdy, World!</h1>
    </body>
  </html>
  """

  get "/" do
    conn
    |> put_resp_content_type("text/html", "utf-8")
    |> send_resp(200, @html)
  end

  # TODO: Add health check endpoint
  # get "/healthz" do
  #  send_resp(conn, 200, "ok\n")
  # end

  match _ do
    send_resp(conn, 404, "not found\n")
  end
end

