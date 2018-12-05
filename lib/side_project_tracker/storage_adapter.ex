defmodule SideProjectTracker.StorageAdapter do
  @moduledoc """
  `StorageAdapter` module takes care of persistence of what `Storage` agent keeps in memory.
  The project struct is serialized to json during save and parsed from json to struct during
  load.
  """
  alias SideProjectTracker.Projects.Project

  @doc """
  Saves project in a file, serialized to json.
  Right now every project is saved in a `defult.json` file. The base path for file is set in
  configuration.
  """
  @spec save(project :: Project.t()) :: {:ok, String.t()} | {:error, any()}
  def save(%Project{} = project) do
    json = project |> Jason.encode!()

    case File.write(file_path(), json) do
      :ok ->
        {:ok, file_path()}

      _ = error ->
        error
    end
  end

  @doc """
  Loads project from a json file.
  Right now every project is loaded from a `defult.json` file. The base path for file is set in
  configuration.
  """
  @spec load() :: {:ok, Project.t()} | {:error, any()}
  def load do
    case File.read(file_path()) do
      {:ok, json} ->
        json |> Jason.decode!() |> Project.new()

      {:error, :enoent} ->
        Project.new()
    end
  end

  defp file_path, do: Application.get_env(:side_project_tracker, :storage_path) <> "/default.json"
end
