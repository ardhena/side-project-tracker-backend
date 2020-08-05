defmodule SideProjectTracker.Projects do
  @moduledoc """
  Projects domain module for performing operations on projects (via otp)
  """
  alias SideProjectTracker.Storage.ProjectsAdapter
  alias SideProjectTracker.Projects.Project
  alias SideProjectTracker.OTP.Projects.{Server, Supervisor}
  import SideProjectTracker.OTP.ServerNaming, only: [name: 2]

  @doc """
  Gets all keys of projects
  """
  @spec get_projects() :: list(%{key: String.t()})
  def get_projects do
    Supervisor.list_projects()
    |> Enum.map(fn project ->
      project
      |> Map.from_struct()
      |> Map.take([:key])
    end)
  end

  @doc """
  Saves content of `OTP.Projects.Storage` into files using storage adapter
  """
  @spec sync_projects() :: %{saved: list(ok: String.t()), removed: list(ok: String.t())}
  def sync_projects do
    %{
      saved: save_from_otp(),
      removed: remove_files()
    }
  end

  defp save_from_otp do
    Supervisor.list_projects()
    |> Enum.map(fn project ->
      :server
      |> name(project)
      |> Server.get()
      |> ProjectsAdapter.save()
    end)
  end

  defp remove_files do
    (ProjectsAdapter.list_projects() -- Supervisor.list_projects())
    |> Enum.map(fn project ->
      ProjectsAdapter.remove(project)
    end)
  end

  @doc """
  Creates new project
  """
  @spec new_project(key :: String.t()) :: :ok
  def new_project(key) do
    %{key: key}
    |> Project.new()
    |> Supervisor.add_child()
    |> case do
      {:ok, _pid} -> :ok
      result -> result
    end
  end

  @doc """
  Gets project data from individual project storage
  """
  @spec get_project(key :: String.t()) :: Project.t()
  def get_project(key) do
    :server
    |> name(key)
    |> Server.get()
  end

  @doc """
  Gets tasks from individual project storage
  """
  @spec get_project_tasks(key :: String.t()) ::
          list(%{key: String.t(), name: String.t(), tasks: []})
  def get_project_tasks(key) do
    :server
    |> name(key)
    |> Server.get()
    |> Project.get_tasks()
  end

  @doc """
  Adds new task to the project
  """
  @spec new_project_task(key :: String.t(), tuple()) :: :ok
  def new_project_task(key, {task_key, column_key, position}) do
    perform_in_project(:new_task, key, {task_key, column_key, position})
  end

  @doc """
  Updates task key, name or version
  """
  @spec update_project_task(key :: String.t(), tuple()) :: :ok
  def update_project_task(key, {task_key, name, version}) do
    perform_in_project(:update_task, key, {task_key, name, version})
  end

  @doc """
  Moves task to another column
  """
  @spec move_project_task(key :: String.t(), tuple()) :: :ok
  def move_project_task(key, {task_key, column_key}) do
    perform_in_project(:move_task, key, {task_key, column_key})
  end

  @doc """
  Deltes task from the project
  """
  @spec delete_project_task(key :: String.t(), tuple()) :: :ok
  def delete_project_task(key, {task_key}) do
    perform_in_project(:delete_task, key, {task_key})
  end

  @doc """
  Adds new version to the project
  """
  @spec new_project_version(key :: String.t(), tuple()) :: :ok
  def new_project_version(key, {code}) do
    perform_in_project(:new_version, key, {code})
  end

  @spec perform_in_project(action :: Server.actions(), key :: String.t(), arguments :: tuple()) ::
          :ok
  defp perform_in_project(action, key, arguments) do
    :server
    |> name(key)
    |> Server.perform(action, arguments)
  end
end
