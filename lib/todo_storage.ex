defmodule Todo.Storage do
  use GenServer

  # Client

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def fetch_from_column(server, key) do
    GenServer.call(server, {:fetch_from_column, key})
  end

  def fetch(server) do
    GenServer.call(server, {:fetch})
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
      },
    ]
    {:ok, columns}
  end

  def handle_call({:fetch_from_column, key}, _from, columns) do
    with %{} = col <- Enum.find(columns, fn(col) -> col.key == key end) do
      {:reply, col.tasks, columns}
    else
      nil -> {:reply, [], columns}
    end
  end

  def handle_call({:fetch,}, _from, columns) do
    tasks = Enum.flat_map(columns, fn(col) -> col.tasks end)
    {:reply, tasks, columns}
  end
end
