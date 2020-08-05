defmodule SideProjectTracker.Application do
  @moduledoc false
  use Application
  alias SideProjectTracker.OTP.{PeriodicServer, Projects}

  def start(_type, _args) do
    [
      SideProjectTrackerWeb.Endpoint,
      {Projects.Supervisor, [name: SideProjectTracker.OTP.Projects.Supervisor]},
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
