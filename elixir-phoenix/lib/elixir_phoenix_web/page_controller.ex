# elixir-phoenix/lib/elixir_phoenix_web/page_controller.ex
defmodule ElixirPhoenixWeb.PageController do
  use Phoenix.Controller
  import Plug.Conn

  def home(conn, _params) do
    html = """
    <!doctype html>
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Howdy from Phoenix</title>
      </head>
      <body>
        <h1>Howdy, World!</h1>
      </body>
    </html>
    """

    conn
    |> put_resp_content_type("text/html; charset=utf-8")
    |> send_resp(200, html)
  end

  def favicon(conn, _params), do: send_resp(conn, 204, "")
end
