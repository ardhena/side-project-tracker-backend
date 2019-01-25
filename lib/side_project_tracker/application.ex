defmodule SideProjectTracker.Application do
  @moduledoc false
  use Application
  alias SideProjectTracker.OTP.{PeriodicServer, ProjectSupervisor}

  def start(_type, _args) do
    [
      {ProjectSupervisor, [name: SideProjectTracker.OTP.ProjectSupervisor]},
      {PeriodicServer, [name: SideProjectTracker.OTP.PeriodicServer]}
    ]
    |> Supervisor.start_link(name: SideProjectTracker.OTP.Supervisor, strategy: :one_for_one)
  end
end
