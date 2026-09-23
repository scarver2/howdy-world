# elixir-hologram/config/config.exs
import Config

config :elixir_hologram, ElixirHologramWeb.Endpoint,
  adapter: Bandit.PhoenixAdapter,
  http: [ip: {0, 0, 0, 0}, port: 4000],
  secret_key_base: "howdy-world-hologram-development-secret-key-base-keep-local-only-0123456789",
  server: true,
  url: [host: "localhost"]

config :phoenix, :json_library, Jason
