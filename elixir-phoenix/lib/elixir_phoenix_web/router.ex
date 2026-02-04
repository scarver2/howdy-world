# elixir-phoenix/lib/elixir_phoenix_web/router.ex
defmodule ElixirPhoenixWeb.Router do
  use Phoenix.Router
  import Phoenix.Controller

  pipeline :browser do
    plug :accepts, ["html"]
  end

  scope "/", ElixirPhoenixWeb do
    pipe_through :browser
    get "/", PageController, :home
    get "/favicon.ico", PageController, :favicon
  end
end
