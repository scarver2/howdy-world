# elixir-hologram/lib/elixir_hologram/application.ex
defmodule ElixirHologram.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [ElixirHologramWeb.Endpoint]
    Supervisor.start_link(children, strategy: :one_for_one, name: ElixirHologram.Supervisor)
  end
end
