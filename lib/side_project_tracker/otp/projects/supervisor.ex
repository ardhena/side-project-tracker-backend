defmodule SideProjectTracker.OTP.Projects.Supervisor do
  use Supervisor
  alias SideProjectTracker.Storage.ProjectsAdapter
  alias SideProjectTracker.Projects.Project
  alias SideProjectTracker.OTP.Projects.{Server, Storage}
  import SideProjectTracker.OTP.ServerNaming, only: [name: 2]

  def start_link(name: name) do
    Supervisor.start_link(__MODULE__, :ok, name: name)
  end

  def init(_init_args) do
    ProjectsAdapter.list_projects()
    |> Enum.flat_map(&build_servers_for_project(&1))
    |> Supervisor.init(strategy: :one_for_one)
  end

  def add_child(%Project{} = project) do
    Supervisor.start_child(__MODULE__, build_child_spec(:storage, project))
    Supervisor.start_child(__MODULE__, build_child_spec(:server, project))
  end

  defp build_servers_for_project(%Project{} = project) do
    [
      build_child_spec(:storage, project),
      build_child_spec(:server, project)
    ]
  end

  defp build_child_spec(:storage, project) do
    id = name(:storage, project)

    Supervisor.child_spec({Storage, [name: id, project: project]}, id: id)
  end

  defp build_child_spec(:server, project) do
    id = name(:server, project)

    Supervisor.child_spec({Server, [name: id, project: project]}, id: id)
  end
end
