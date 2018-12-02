defmodule Todo.Storage do
  use GenServer

  # Client

  def start_link(opts) do
    GenServer.start_link(__MODULE__, Todo.Impl.default_columns(), opts)
  end

  def get() do
    GenServer.call(Todo.Storage, {:get})
  end

  def update(new_columns) do
    GenServer.cast(Todo.Storage, {:update, new_columns})
  end

  # Server

  def init() do
    {:ok, Todo.Impl.default_columns()}
  end

  def handle_call({:get}, _from, columns) do
    {:reply, columns, columns}
  end

  def handle_cast({:update, new_columns}, _columns) do
    {:noreply, new_columns}
  end
end
