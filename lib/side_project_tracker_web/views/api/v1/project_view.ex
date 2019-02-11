defmodule SideProjectTrackerWeb.Api.V1.ProjectView do
  use SideProjectTrackerWeb, :view

  def render("projects.json", %{projects: projects}) do
    render_many(projects, __MODULE__, "project.json")
  end

  def render("project.json", %{project: %{key: key, versions: versions}}) do
    %{
      key: key,
      versions: versions
    }
  end

  def render("project.json", %{project: %{key: key}}) do
    %{
      key: key
    }
  end
end
