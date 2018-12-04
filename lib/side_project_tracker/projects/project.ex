defmodule SideProjectTracker.Projects.Project do
  alias SideProjectTracker.Projects.{Column, Task}
  defstruct [:columns, :tasks]

  def new() do
    %__MODULE__{
      columns: Column.all(),
      tasks: [
        Task.new(:todo, :"1", "some task"),
        Task.new(:todo, :"2", "another task"),
        Task.new(:doing, :"3", "working on it now"),
        Task.new(:done, :"4", "already done task")
      ]
    }
  end

  def put(%__MODULE__{} = project, :tasks, tasks), do: %__MODULE__{project | tasks: tasks}

  def add_task_to_column(%__MODULE__{tasks: tasks} = project, task_key, column_key)
      when is_atom(task_key) and is_atom(column_key) do
    project
    |> put(:tasks, [Task.new(column_key, task_key, nil) | tasks])
  end

  def update_task(%__MODULE__{tasks: tasks} = project, task_key, task_name)
      when is_atom(task_key) do
    project
    |> put(
      :tasks,
      update_task_from_collection(tasks, task_key, fn task ->
        Task.update(task, name: task_name)
      end)
    )
  end

  def delete_task(%__MODULE__{tasks: tasks} = project, task_key) when is_atom(task_key) do
    project
    |> put(:tasks, Enum.reject(tasks, fn %Task{key: key} -> key == task_key end))
  end

  def move_task_to_column(%__MODULE__{tasks: tasks} = project, task_key, column_key)
      when is_atom(task_key) and is_atom(column_key) do
    project
    |> put(
      :tasks,
      update_task_from_collection(tasks, task_key, fn task ->
        Task.update(task, column_key: column_key)
      end)
    )
  end

  def delete_all_tasks(%__MODULE__{} = project) do
    project
    |> put(:tasks, [])
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
