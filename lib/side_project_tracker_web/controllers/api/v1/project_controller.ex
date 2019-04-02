defmodule SideProjectTrackerWeb.Api.V1.ProjectController do
  use SideProjectTrackerWeb, :controller

  def index(conn, _params) do
    conn
    |> assign(:projects, MainServer.get_projects())
    |> render(:projects)
  end

  def show(conn, %{"id" => project_key}) do
    conn
    |> assign(:project, MainServer.get_project(project_key))
    |> render(:project)
  end

  def create(conn, %{"key" => project_key}) do
    :ok = MainServer.new_project(project_key)

    render_ok(conn)
  end

  def create(conn, _params), do: render_400(conn)
end
