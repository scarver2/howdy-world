# elixir-phoenix/lib/elixir_phoenix_web/endpoint.ex
defmodule ElixirPhoenixWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :elixir_phoenix

  plug Plug.RequestId
  plug ElixirPhoenixWeb.Router
end
