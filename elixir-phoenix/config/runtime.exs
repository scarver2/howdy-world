# elixir-phoenix/config/runtime.exs
import Config

if config_env() == :prod do
  port =
    System.get_env("PORT", "4000")
    |> String.to_integer()

  config :elixir_phoenix, ElixirPhoenix.Endpoint,
    http: [ip: {0, 0, 0, 0}, port: port],
    server: true
end
