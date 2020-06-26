defmodule Queueex.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Queueex, [7, 13, 27]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Queueex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
