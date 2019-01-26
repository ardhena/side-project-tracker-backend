defmodule SideProjectTracker.OTP.StorageAdapter do
  @moduledoc """
  `StorageAdapter` module takes care of persistence of what single `ProjectStorage` agent keeps
  in memory. The project struct is serialized to json during save and parsed from json to struct
  during load.
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

    project
    |> file_path()
    |> File.write(json)
    |> case do
      :ok ->
        {:ok, file_path(project)}

      _ = error ->
        error
    end
  end

  @doc """
  Loads project from a json file.
  Right now every project is loaded from a `defult.json` file. The base path for file is set in
  configuration.
  """
  @spec load(project :: Project.t()) :: {:ok, Project.t()} | {:error, any()}
  def load(%Project{} = project) do
    project
    |> file_path()
    |> File.read()
    |> case do
      {:ok, json} ->
        json |> Jason.decode!() |> Project.new()

      {:error, :enoent} ->
        project
    end
  end

  @doc """
  Lists all the projects that have a save file
  """
  @spec list_projects() :: list(Project.t())
  def list_projects do
    base_path()
    |> File.ls()
    |> case do
      {:ok, files} ->
        files
        |> Enum.map(&filter_project(&1))
        |> Enum.reject(&is_nil(&1))

      _ = error ->
        error
    end
  end

  @doc """
  Loads all projects
  """
  @spec load_projects() :: list(Project.t())
  def load_projects do
    list_projects()
    |> Enum.map(&load(&1))
  end

  defp filter_project(file_name) do
    file_name
    |> String.split(".json")
    |> case do
      [key, ""] ->
        Project.new(%{key: key})

      _ ->
        nil
    end
  end

  defp base_path, do: Application.get_env(:side_project_tracker, :storage_path)
  defp file_path(%Project{key: key}), do: base_path() <> "/#{key}.json"
end
