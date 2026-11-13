# elixir-hologram/mix.exs
defmodule ElixirHologram.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_hologram,
      version: "0.1.0",
      elixir: "~> 1.19",
      compilers: Mix.compilers() ++ [:hologram],
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {ElixirHologram.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:hologram, "~> 0.11.1"},
      {:phoenix, "~> 1.8"},
      {:bandit, "~> 1.0"}
    ]
  end
end
