# elixir-hologram/lib/elixir_hologram_web/endpoint.ex
defmodule ElixirHologramWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :elixir_hologram

  plug Plug.Static,
    at: "/",
    from: :elixir_hologram,
    only: ["hologram" | ElixirHologramWeb.static_paths()]

  plug Plug.RequestId
  plug Hologram.Router
  plug ElixirHologramWeb.Router
end
