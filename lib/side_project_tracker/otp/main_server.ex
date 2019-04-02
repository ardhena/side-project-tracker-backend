defmodule SideProjectTracker.OTP.MainServer do
  @moduledoc """
  `MainServer` acts as bridge between individual project servers. It can call any project
  server and perform any available action in it.
  """
  alias SideProjectTracker.{
    Projects.Project,
    OTP.ProjectServer,
    OTP.ProjectSupervisor,
    OTP.StorageAdapter
  }

  import SideProjectTracker.OTP.ServerNaming, only: [name: 2]

  @doc """
  Gets project data from individual project storage
  """
  @spec get_project(key :: String.t()) :: Project.t()
  def get_project(key) do
    :server
    |> name(key)
    |> ProjectServer.get()
    |> Map.from_struct()
    |> Map.take([:key, :versions])
  end

  @doc """
  Gets tasks from individual project storage
  """
  @spec get_project_tasks(key :: String.t()) :: list()
  def get_project_tasks(key) do
    :server
    |> name(key)
    |> ProjectServer.get()
    |> Project.to_old_format()
  end

  @doc """
  Perfoms some operation on idividual project data and updates the storage
  """
  @spec perform_in_project(key :: String.t(), action :: atom(), arguments :: tuple()) :: :ok
  def perform_in_project(key, action, arguments) do
    :server
    |> name(key)
    |> ProjectServer.perform(action, arguments)
  end

  @doc """
  Gets all keys of projects
  """
  @spec get_projects() :: list(Project.t())
  def get_projects do
    StorageAdapter.list_projects()
    |> Enum.map(fn project ->
      project
      |> Map.from_struct()
      |> Map.take([:key])
    end)
  end

  @doc """
  Creates new project
  """
  @spec new_project(key :: String.t()) :: :ok
  def new_project(key) do
    project = Project.new(%{key: key})

    StorageAdapter.save(project)

    ProjectSupervisor.add_child(project)

    :ok
  end
end
