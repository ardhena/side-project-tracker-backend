defmodule SideProjectTracker.OTP.ProjectServer do
  @moduledoc """
  `ProjectServer` module is responsible for performing operations on `ProjectStorage` data.
  It has two main functions: `get/1` - using call and `perform/3` - using cast. All call
  functions return data from the storage, all cast functions transform and save data in the
  storage.
  """
  use GenServer
  alias SideProjectTracker.{Projects.Project, OTP.ProjectStorage}
  import SideProjectTracker.OTP.ServerNaming, only: [name: 2]

  # API

  def start_link(name: name, project: %Project{key: key}) do
    GenServer.start_link(__MODULE__, name(:storage, key), name: name)
  end

  @doc """
  Gets project data from project storage
  """
  @spec get(server :: atom()) :: Project.t()
  def get(server) do
    GenServer.call(server, :get)
  end

  @type actions ::
          :new_task | :update_task | :move_task | :delete_task | :delete_tasks | :new_version

  @doc """
  Perfoms some operation on project data and updates the storage
  """
  @spec perform(server :: atom(), action :: actions(), arguments :: tuple()) :: :ok
  def perform(server, _action, _arguments \\ nil)

  def perform(server, :new_task, {task_key, column_key}) do
    GenServer.cast(server, {:new_task, task_key, column_key})
  end

  def perform(server, :update_task, {task_key, task_name}) do
    GenServer.cast(server, {:update_task, task_key, task_name})
  end

  def perform(server, :move_task, {task_key, column_key}) do
    GenServer.cast(server, {:move_task, task_key, column_key})
  end

  def perform(server, :delete_task, {task_key}) do
    GenServer.cast(server, {:delete_task, task_key})
  end

  def perform(server, :delete_tasks, _arguments) do
    GenServer.cast(server, {:delete_tasks})
  end

  def perform(server, :new_version, {version_code}) do
    GenServer.cast(server, {:new_version, version_code})
  end

  # Server

  def init(args) do
    {:ok, args}
  end

  def handle_call(:get, _from, storage_name) do
    {:reply, ProjectStorage.get(storage_name), storage_name}
  end

  def handle_cast({:new_task, task_key, column_key}, storage_name) do
    updated_data =
      storage_name
      |> ProjectStorage.get()
      |> Project.add_task_to_column(task_key, column_key)

    ProjectStorage.update(storage_name, updated_data)

    {:noreply, storage_name}
  end

  def handle_cast({:update_task, task_key, new_task_name}, storage_name) do
    updated_data =
      storage_name
      |> ProjectStorage.get()
      |> Project.update_task(task_key, new_task_name)

    ProjectStorage.update(storage_name, updated_data)

    {:noreply, storage_name}
  end

  def handle_cast({:move_task, task_key, column_key}, storage_name) do
    updated_data =
      storage_name
      |> ProjectStorage.get()
      |> Project.move_task_to_column(task_key, column_key)

    ProjectStorage.update(storage_name, updated_data)

    {:noreply, storage_name}
  end

  def handle_cast({:delete_task, task_key}, storage_name) do
    updated_data =
      storage_name
      |> ProjectStorage.get()
      |> Project.delete_task(task_key)

    ProjectStorage.update(storage_name, updated_data)

    {:noreply, storage_name}
  end

  def handle_cast({:delete_tasks}, storage_name) do
    updated_data =
      storage_name
      |> ProjectStorage.get()
      |> Project.delete_all_tasks()

    ProjectStorage.update(storage_name, updated_data)

    {:noreply, storage_name}
  end

  def handle_cast({:new_version, version_code}, storage_name) do
    updated_data =
      storage_name
      |> ProjectStorage.get()
      |> Project.add_version(version_code)

    ProjectStorage.update(storage_name, updated_data)

    {:noreply, storage_name}
  end
end
