defmodule SideProjectTrackerWeb.Api.V1.TaskView do
  use SideProjectTrackerWeb, :view

  def render("columns.json", %{columns: columns}) do
    render_many(columns, __MODULE__, "column.json", as: :column)
  end

  def render("column.json", %{column: %{key: key, name: name, tasks: tasks}}) do
    %{
      key: key,
      name: name,
      tasks: tasks
    }
  end
end
