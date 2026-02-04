# elixir-phoenix/lib/elixir_phoenix/root_plug.ex
defmodule ElixirPhoenix.RootPlug do
  @behaviour Plug
  import Plug.Conn

  @impl true
  def init(opts), do: opts

  @impl true
  def call(%Plug.Conn{request_path: "/"} = conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Howdy, World!\n")
  end

  # def call(%Plug.Conn{request_path: "/healthz"} = conn, _opts) do
  #   conn
  #   |> put_resp_content_type("text/plain")
  #   |> send_resp(200, "ok\n")
  # end

  def call(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(404, "not found\n")
  end
end
