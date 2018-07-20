defmodule Todo.Storage do
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

  def update_task(server, task_key, task_name) do
    GenServer.cast(server, {:update_task, task_key, task_name})
  end

  def move_task(server, task_key, column_key) do
    GenServer.cast(server, {:move_task, task_key, column_key})
  end

  # Server

  def init(:ok) do
    columns = [
      %{
        key: "to-do",
        tasks: [
          %{name: "some task", key: 1},
          %{name: "another task", key: 2}
        ]
      },
      %{
        key: "doing",
        tasks: [
          %{name: "working on it now", key: 3}
        ]
      },
      %{
        key: "done",
        tasks: [
          %{name: "already done task", key: 4}
        ]
      }
    ]

    {:ok, columns}
  end

  def handle_call({:fetch_tasks}, _from, columns) do
    tasks = Enum.flat_map(columns, fn col -> col.tasks end)
    {:reply, tasks, columns}
  end

  def handle_call({:fetch_tasks, column_key}, _from, columns) do
    with %{} = col <- Enum.find(columns, fn col -> col.key == column_key end) do
      {:reply, col.tasks, columns}
    else
      nil -> {:reply, [], columns}
    end
  end

  def handle_cast({:update_task, task_key, task_name}, columns) do
    with {%{} = col, %{} = tsk} <-
           Enum.find(tasks_with_columns(columns), fn {_, tsk} -> tsk.key == task_key end) do
      collection =
        task_name
        |> build_task(tsk)
        |> replace_in_collection(col.tasks)
        |> build_column(col)
        |> replace_in_collection(columns)

      {:noreply, collection}
    else
      _ -> {:noreply, columns}
    end
  end

  def handle_cast({:move_task, task_key, column_key}, columns) do
    with {%{} = col, %{} = tsk} <-
           Enum.find(tasks_with_columns(columns), fn {_, tsk} -> tsk.key == task_key end) do
      collection =
        Enum.map(columns, fn c ->
          case {c.key == col.key, c.key == column_key} do
            {true, false} -> build_column(Enum.reject(c.tasks, fn t -> t.key == tsk.key end), c)
            {false, true} -> build_column([tsk | c.tasks], c)
            {_, _} -> c
          end
        end)

      {:noreply, collection}
    else
      _ -> {:noreply, columns}
    end
  end

  defp tasks_with_columns(columns) do
    Enum.flat_map(columns, fn col ->
      Enum.map(col.tasks, fn tsk -> {col, tsk} end)
    end)
  end

  defp build_task(name, task), do: %{task | name: name}

  defp build_column(tasks, column), do: %{column | tasks: tasks}

  defp replace_in_collection(new_map, collection) do
    Enum.map(collection, fn m -> if m.key == new_map.key, do: new_map, else: m end)
  end
end
