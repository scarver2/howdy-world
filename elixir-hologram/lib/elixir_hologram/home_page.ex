# elixir-hologram/lib/elixir_hologram/home_page.ex
defmodule ElixirHologram.HomePage do
  use Hologram.Page

  route "/"
  layout ElixirHologram.MainLayout

  def template do
    ~HOLO"""
    <h1>Howdy, World!</h1>
    """
  end
end
