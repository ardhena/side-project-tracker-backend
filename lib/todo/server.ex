defmodule Todo.Server do
  use GenServer

  # Client

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def fetch_tasks(server) do
    GenServer.call(server, {:fetch_tasks})
  end

  def fetch_tasks(server, column_key) do
    GenServer.call(server, {:fetch_tasks, column_key})
  end

  def create_task(server, task_key, column_key) do
    GenServer.cast(server, {:create_task, task_key, column_key})
  end

  def update_task(server, task_key, task_name) do
    GenServer.cast(server, {:update_task, task_key, task_name})
  end

  def move_task(server, task_key, column_key) do
    GenServer.cast(server, {:move_task, task_key, column_key})
  end

  def delete_tasks(server) do
    GenServer.cast(server, {:delete_tasks})
  end

  def delete_task(server, task_key) do
    GenServer.cast(server, {:delete_task, task_key})
  end

  # Server

  def init(:ok) do
    {:ok, Todo.Impl.default_columns()}
  end

  def handle_call({:fetch_tasks}, _from, columns) do
    {:reply, Todo.Impl.get_all_columns(columns), columns}
  end

  def handle_call({:fetch_tasks, column_key}, _from, columns) do
    {:reply, Todo.Impl.get_tasks_from_column(columns, column_key), columns}
  end

  def handle_cast({:create_task, task_key, column_key}, columns) do
    {:noreply, Todo.Impl.create_task_in_column(columns, task_key, column_key)}
  end

  def handle_cast({:update_task, task_key, new_task_name}, columns) do
    {:noreply, Todo.Impl.update_task(columns, task_key, new_task_name)}
  end

  def handle_cast({:move_task, task_key, column_key}, columns) do
    {:noreply, Todo.Impl.move_task_to_column(columns, task_key, column_key)}
  end

  def handle_cast({:delete_tasks}, columns) do
    {:noreply, Todo.Impl.delete_all_tasks(columns)}
  end

  def handle_cast({:delete_task, task_key}, columns) do
    {:noreply, Todo.Impl.delete_task(columns, task_key)}
  end
end
