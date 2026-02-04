# elixir-phoenix/lib/elixir_phoenix/root_controller.ex
defmodule ElixirPhoenix.RootController do
  import Plug.Conn

  def index(conn, _params) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Howdy, World!\n")
  end

  # def healthz(conn, _params) do
  #   conn
  #   |> put_resp_content_type("text/plain")
  #   |> send_resp(200, "ok\n")
  # end
end
