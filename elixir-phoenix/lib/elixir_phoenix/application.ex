# elixir-phoenix/lib/elixir_phoenix/application.ex
defmodule ElixirPhoenix.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ElixirPhoenix.Endpoint
    ]

    opts = [strategy: :one_for_one, name: ElixirPhoenix.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
