# elixir-bandit/mix.exs
defmodule HowdyBandit.MixProject do
  use Mix.Project

  def project do
    [
      app: :howdy_bandit,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {HowdyBandit.Application, []}
    ]
  end

  defp deps do
    [
      {:bandit, "~> 1.0"},
      {:plug, "~> 1.15"}
    ]
  end
end

