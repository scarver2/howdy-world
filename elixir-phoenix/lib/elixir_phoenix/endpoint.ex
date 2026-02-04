# elixir-phoenix/lib/elixir_phoenix/endpoint.ex
defmodule ElixirPhoenix.Endpoint do
  use Phoenix.Endpoint, otp_app: :elixir_phoenix

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason

  plug ElixirPhoenix.Router
end
