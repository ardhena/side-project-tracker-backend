defmodule SideProjectTracker.Application do
  @moduledoc false
  use Application
  alias SideProjectTracker.OTP.{PeriodicServer, ProjectSupervisor}

  def start(_type, _args) do
    [
      SideProjectTrackerWeb.Endpoint,
      {ProjectSupervisor, [name: SideProjectTracker.OTP.ProjectSupervisor]},
      {PeriodicServer, [name: SideProjectTracker.OTP.PeriodicServer]}
    ]
    |> Supervisor.start_link(name: SideProjectTracker.OTP.Supervisor, strategy: :one_for_one)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SideProjectTrackerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
