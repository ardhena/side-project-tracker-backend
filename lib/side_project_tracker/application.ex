defmodule SideProjectTracker.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    children = [
      {SideProjectTracker.ProjectStorage, [name: SideProjectTracker.ProjectStorage]},
      {SideProjectTracker.ProjectServer, [name: SideProjectTracker.ProjectServer]},
      {SideProjectTracker.PeriodicServer, [name: SideProjectTracker.PeriodicServer]}
    ]

    Supervisor.start_link(children, name: SideProjectTracker.Supervisor, strategy: :rest_for_one)
  end
end
