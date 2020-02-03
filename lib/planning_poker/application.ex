defmodule PlanningPoker.Application do
  import Supervisor.Spec, warn: false
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: Registry.PlanningPoker},
      PlanningPokerWeb.Endpoint,
      PlanningPokerWeb.Presence,
    ]

    opts = [strategy: :one_for_one, name: PlanningPoker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    PlanningPokerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
