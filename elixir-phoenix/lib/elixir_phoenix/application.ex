# elixir-phoenix/lib/elixir_phoenix/application.ex
defmodule ElixirPhoenix.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ElixirPhoenixWeb.Endpoint
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: ElixirPhoenix.Supervisor)
  end
end
