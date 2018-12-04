defmodule SideProjectTracker.Storage do
  use Agent

  def start_link(opts) do
    Agent.start_link(fn -> SideProjectTracker.Projects.Project.new() end, opts)
  end

  def get() do
    Agent.get(__MODULE__, fn project -> project end)
  end

  def update(updated_project) do
    Agent.update(__MODULE__, fn _project -> updated_project end)
  end
end
