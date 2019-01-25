defmodule SideProjectTracker.OTP.ProjectStorage do
  @moduledoc """
  `ProjectStorage` module acts as a storage for project struct and data.
  """
  use GenServer
  alias SideProjectTracker.{Projects.Project, OTP.StorageAdapter}

  def start_link(name: name, project: project) do
    GenServer.start_link(__MODULE__, StorageAdapter.load(project), name: name)
  end

  # API

  @doc """
  Returns data stored in a storage
  """
  @spec get(server :: atom()) :: Project.t()
  def get(server) do
    GenServer.call(server, :get)
  end

  @doc """
  Updates data stored in a storage
  """
  @spec update(server :: atom(), updated_project :: Project.t()) :: :ok
  def update(server, updated_project) do
    GenServer.cast(server, {:update, updated_project})
  end

  # Client

  def init(args) do
    {:ok, args}
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:update, updated_state}, _state) do
    {:noreply, updated_state}
  end

  def terminate(_reason, state) do
    StorageAdapter.save(state)
  end
end
