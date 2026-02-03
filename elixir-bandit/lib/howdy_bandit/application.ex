defmodule HowdyBandit.Application do
  use Application

  @impl true
  def start(_type, _args) do
    port = Application.get_env(:howdy_bandit, :port, 4000)

    children = [
      {Bandit,
       plug: HowdyBandit.Router,
       scheme: :http,
       options: [port: port]}
    ]

    opts = [strategy: :one_for_one, name: HowdyBandit.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

