defmodule SideProjectTracker.Projects.Project do
  alias SideProjectTracker.Projects.{Column, Task, Version}

  @derive Jason.Encoder

  defstruct [:key, :columns, :tasks, :versions]

  def new(%{key: key}) do
    %__MODULE__{
      key: key,
      columns: Column.all(),
      tasks: [],
      versions: []
    }
  end

  def new(%{"key" => key, "columns" => columns, "tasks" => tasks, "versions" => versions}) do
    %__MODULE__{
      key: key,
      columns: columns |> Enum.map(&Column.new(&1)),
      tasks: tasks |> Enum.map(&Task.new(&1)),
      versions: versions |> Enum.map(&Version.new(&1))
    }
  end

  def new(%{"key" => key, "columns" => columns, "tasks" => tasks}) do
    %__MODULE__{
      key: key,
      columns: columns |> Enum.map(&Column.new(&1)),
      tasks: tasks |> Enum.map(&Task.new(&1)),
      versions: []
    }
  end

  def put(%__MODULE__{} = project, :tasks, tasks), do: %__MODULE__{project | tasks: tasks}

  def put(%__MODULE__{} = project, :versions, versions),
    do: %__MODULE__{project | versions: versions}

  def add_task_to_column(%__MODULE__{tasks: tasks} = project, task_key, column_key, "top") do
    project
    |> put(:tasks, [Task.new(%{column_key: column_key, key: task_key, name: nil}) | tasks])
  end

  def add_task_to_column(%__MODULE__{tasks: tasks} = project, task_key, column_key, "bottom") do
    project
    |> put(:tasks, tasks ++ [Task.new(%{column_key: column_key, key: task_key, name: nil})])
  end

  def update_task(%__MODULE__{tasks: tasks} = project, task_key, task_name, task_version) do
    project
    |> put(
      :tasks,
      update_task_from_collection(tasks, task_key, fn task ->
        task
        |> Task.update(name: task_name)
        |> Task.update(version: task_version)
      end)
    )
  end

  def delete_task(%__MODULE__{tasks: tasks} = project, task_key) do
    project
    |> put(:tasks, Enum.reject(tasks, fn %Task{key: key} -> key == task_key end))
  end

  def move_task_to_column(%__MODULE__{tasks: tasks} = project, task_key, column_key) do
    moved_task = %Task{
      Enum.find(tasks, fn %Task{key: key} -> key == task_key end)
      | column_key: column_key
    }

    tasks_without_moved_task = Enum.reject(tasks, fn %Task{key: key} -> key == task_key end)

    project
    |> put(:tasks, [moved_task | tasks_without_moved_task])
  end

  def add_version(%__MODULE__{versions: versions} = project, version_code) do
    project
    |> put(:versions, versions ++ [Version.new(%{code: version_code})])
  end

  def to_old_format(%__MODULE__{columns: columns, tasks: tasks}) do
    columns
    |> Enum.map(fn %{key: key, name: name} ->
      column_tasks =
        tasks
        |> Enum.filter(fn %{column_key: column_key} -> column_key == key end)
        |> Enum.map(&Map.from_struct(&1))
        |> Enum.map(&Map.delete(&1, :column_key))

      %{key: key, name: name, tasks: column_tasks}
    end)
  end

  defp update_task_from_collection(collection, task_key, fun) do
    Enum.map(collection, fn
      %Task{key: ^task_key} = task -> fun.(task)
      %Task{} = task -> task
    end)
  end
end
