defmodule SideProjectTracker.Server do
  use GenServer

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

  def handle_call({:fetch_tasks}, _from, columns) do
    {:reply, SideProjectTracker.Impl.get_all_columns(columns), columns}
  end

  def handle_call({:create_task, task_key, column_key}, _from, columns) do
    new_columns = SideProjectTracker.Impl.create_task_in_column(columns, task_key, column_key)
    {:reply, new_columns, new_columns}
  end

  def handle_call({:update_task, task_key, new_task_name}, _from, columns) do
    new_columns = SideProjectTracker.Impl.update_task(columns, task_key, new_task_name)
    {:reply, new_columns, new_columns}
  end

  def handle_call({:move_task, task_key, column_key}, _from, columns) do
    new_columns = SideProjectTracker.Impl.move_task_to_column(columns, task_key, column_key)
    {:reply, new_columns, new_columns}
  end

  def handle_call({:delete_tasks}, _from, columns) do
    new_columns = SideProjectTracker.Impl.delete_all_tasks(columns)
    {:reply, new_columns, new_columns}
  end

  def handle_call({:delete_task, task_key}, _from, columns) do
    new_columns = SideProjectTracker.Impl.delete_task(columns, task_key)
    {:reply, new_columns, new_columns}
  end

  def terminate(_reason, columns) do
    SideProjectTracker.Storage.update(columns)
  end
end
