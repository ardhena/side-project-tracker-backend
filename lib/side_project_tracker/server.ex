defmodule SideProjectTracker.Server do
  use GenServer

  alias SideProjectTracker.Projects.Project

  # Client

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def fetch_tasks(server) do
    GenServer.call(server, {:fetch_tasks})
  end

  def create_task(server, task_key, column_key) do
    server
    |> GenServer.call({:create_task, task_key, column_key})
    |> SideProjectTracker.Storage.update()
  end

  def update_task(server, task_key, task_name) do
    server
    |> GenServer.call({:update_task, task_key, task_name})
    |> SideProjectTracker.Storage.update()
  end

  def move_task(server, task_key, column_key) do
    server
    |> GenServer.call({:move_task, task_key, column_key})
    |> SideProjectTracker.Storage.update()
  end

  def delete_tasks(server) do
    server
    |> GenServer.call({:delete_tasks})
    |> SideProjectTracker.Storage.update()
  end

  def delete_task(server, task_key) do
    server
    |> GenServer.call({:delete_task, task_key})
    |> SideProjectTracker.Storage.update()
  end

  # Server

  def init(:ok) do
    {:ok, SideProjectTracker.Storage.get()}
  end

  def handle_call({:fetch_tasks}, _from, project) do
    {:reply, project, project}
  end

  def handle_call({:create_task, task_key, column_key}, _from, project) do
    updated_project = Project.add_task_to_column(project, task_key, column_key)
    {:reply, updated_project, updated_project}
  end

  def handle_call({:update_task, task_key, new_task_name}, _from, project) do
    updated_project = Project.update_task(project, task_key, new_task_name)
    {:reply, updated_project, updated_project}
  end

  def handle_call({:move_task, task_key, column_key}, _from, project) do
    updated_project = Project.move_task_to_column(project, task_key, column_key)
    {:reply, updated_project, updated_project}
  end

  def handle_call({:delete_tasks}, _from, project) do
    updated_project = Project.delete_all_tasks(project)
    {:reply, updated_project, updated_project}
  end

  def handle_call({:delete_task, task_key}, _from, project) do
    updated_project = Project.delete_task(project, task_key)
    {:reply, updated_project, updated_project}
  end

  def terminate(_reason, project) do
    SideProjectTracker.Storage.update(project)
  end
end
