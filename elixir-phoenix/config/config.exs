# elixir-phoenix/config/config.exs
import Config

config :elixir_phoenix, ElixirPhoenix.Endpoint,
  server: true,
  url: [host: "localhost"],
  http: [ip: {0, 0, 0, 0}, port: 4000],
  secret_key_base: String.duplicate("a", 64)

config :phoenix, :json_library, Jason
