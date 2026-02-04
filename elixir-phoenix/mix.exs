# elixir-phoenix/mix.exs
defmodule ElixirPhoenix.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_phoenix,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {ElixirPhoenix.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:phoenix, "~> 1.7.21"},
      {:plug_cowboy, "~> 2.7"}
    ]
  end
end
