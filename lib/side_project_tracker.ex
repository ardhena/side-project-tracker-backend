defmodule SideProjectTracker do
  def fetch_tasks do
    SideProjectTracker.Server
    |> SideProjectTracker.Server.fetch_tasks()
    |> SideProjectTracker.Projects.Project.to_old_format()
  end

  def create_task(task_key, column_key) do
    SideProjectTracker.Server.create_task(SideProjectTracker.Server, task_key, column_key)
  end

  def update_task(task_key, task_name) do
    SideProjectTracker.Server.update_task(SideProjectTracker.Server, task_key, task_name)
  end

  def move_task(task_key, column_key) do
    SideProjectTracker.Server.move_task(SideProjectTracker.Server, task_key, column_key)
  end

  def delete_tasks() do
    SideProjectTracker.Server.delete_tasks(SideProjectTracker.Server)
  end

  def delete_task(task_key) do
    SideProjectTracker.Server.delete_task(SideProjectTracker.Server, task_key)
  end
end
