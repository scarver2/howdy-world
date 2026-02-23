# elixir-phoenix/config/dev.exs
import Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we can use it
# to bundle .js and .css sources.
config :elixir_phoenix, ElixirPhoenixWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4000],
  server: true,
  check_origin: false,
  debug_errors: true,
  secret_key_base: "3LZak7P1mEmrNfPXIDyG52O3P/n2nzsJr6EMqsaotR6TTyyyomETxKDm9ga1rIgx",
  watchers: []

# Enable dev routes for dashboard and mailbox
config :elixir_phoenix, dev_routes: true

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
