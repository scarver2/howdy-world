# elixir-bandit/config/runtime.exs

import Config

port =
  System.get_env("PORT", "4000")
  |> String.to_integer()

config :howdy_bandit, port: port

