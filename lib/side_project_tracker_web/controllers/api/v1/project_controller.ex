defmodule SideProjectTrackerWeb.Api.V1.ProjectController do
  use SideProjectTrackerWeb, :controller

  def index(conn, _params) do
    conn
    |> assign(:projects, Projects.get_projects())
    |> render(:projects)
  end

  def sync(conn, _params) do
    with %{saved: _, archived: _} <- Projects.sync_projects() do
      render_ok(conn)
    end
  end

  def show(conn, %{"id" => project_key}) do
    conn
    |> assign(:project, Projects.get_project(project_key))
    |> render(:project)
  end

  def delete(conn, %{"id" => project_key}) do
    with :ok <- Projects.delete_project(project_key) do
      render_ok(conn)
    end
  end

  def create(conn, %{"key" => project_key}) do
    with :ok <- Projects.new_project(project_key) do
      render_ok(conn)
    end
  end

  def create(conn, _params), do: render_400(conn)
end
