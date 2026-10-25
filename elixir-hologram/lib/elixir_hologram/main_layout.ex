# elixir-hologram/lib/elixir_hologram/main_layout.ex
defmodule ElixirHologram.MainLayout do
  use Hologram.Component

  alias Hologram.UI.Runtime

  def template do
    ~HOLO"""
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <title>Howdy from Hologram</title>
        <Runtime />
      </head>
      <body>
        <slot />
      </body>
    </html>
    """
  end
end
