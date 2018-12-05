defmodule SideProjectTracker.ProjectStorage do
  @moduledoc """
  `ProjectStorage` module acts as a storage for project struct and data.
  """
  use GenServer
  alias SideProjectTracker.{Projects.Project, StorageAdapter}

  def start_link(opts) do
    GenServer.start_link(__MODULE__, StorageAdapter.load(), opts)
  end

  # API

  @doc """
  Returns data stored in a storage
  """
  @spec get() :: Project.t()
  def get() do
    GenServer.call(__MODULE__, :get)
  end

  @doc """
  Updates data stored in a storage
  """
  @spec update(updated_project :: Project.t()) :: :ok
  def update(updated_project) do
    GenServer.cast(__MODULE__, {:update, updated_project})
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
