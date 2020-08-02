defmodule SideProjectTrackerWeb.Api.V1.ProjectController do
  use SideProjectTrackerWeb, :controller
  alias SideProjectTracker.OTP.StorageAdapter

  def index(conn, _params) do
    conn
    |> assign(:projects, MainServer.get_projects())
    |> render(:projects)
  end

  def sync(conn, _params) do
    with :ok <- StorageAdapter.save_server_memory() do
      render_ok(conn)
    end
  end

  def show(conn, %{"id" => project_key}) do
    conn
    |> assign(:project, MainServer.get_project(project_key))
    |> render(:project)
  end

  def create(conn, %{"key" => project_key}) do
    with :ok <- MainServer.new_project(project_key) do
      render_ok(conn)
    end
  end

  def create(conn, _params), do: render_400(conn)
end
