defmodule SideProjectTracker.Storage do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> SideProjectTracker.Impl.default_columns() end, name: __MODULE__)
  end

  def get() do
    Agent.get(__MODULE__, fn data -> data end)
  end

  def update(new_columns) do
    Agent.update(__MODULE__, fn _data -> new_columns end)
  end
end
