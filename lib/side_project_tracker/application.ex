defmodule SideProjectTracker.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    children = [
      {SideProjectTracker.Storage, []},
      {SideProjectTracker.Server, [name: SideProjectTracker.Server]}
    ]

    Supervisor.start_link(children, name: SideProjectTracker.Supervisor, strategy: :rest_for_one)
  end
end
