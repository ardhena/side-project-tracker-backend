defmodule SideProjectTracker.OTP.ProjectSupervisor do
  use Supervisor
  alias SideProjectTracker.OTP.{ProjectServer, ProjectStorage}

  def start_link(name: name) do
    Supervisor.start_link(__MODULE__, name: name)
  end

  def init(_init_args) do
    [
      {ProjectStorage, [name: SideProjectTracker.OTP.ProjectStorage]},
      {ProjectServer, [name: SideProjectTracker.OTP.ProjectServer]}
    ]
    |> Supervisor.init(strategy: :one_for_one)
  end
end
