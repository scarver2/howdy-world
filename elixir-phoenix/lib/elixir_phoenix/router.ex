# elixir-phoenix/lib/elixir_phoenix/router.ex
defmodule ElixirPhoenix.Router do
  use Phoenix.Router

  pipeline :api do
    plug :accepts, ["text", "json"]
  end

  scope "/", ElixirPhoenix do
    pipe_through :api

    # get "/", RootController, :index
    # get "/healthz", RootController, :healthz

    get "/", RootPlug, []
    # get "/healthz", RootPlug, []
  end
end
