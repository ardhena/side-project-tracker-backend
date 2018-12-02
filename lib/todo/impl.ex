defmodule Todo.Impl do
  @default_columns [
    %{
      key: "to-do",
      name: "To do",
      tasks: [
        %{name: "some task", key: 1},
        %{name: "another task", key: 2}
      ]
    },
    %{
      key: "doing",
      name: "Doing",
      tasks: [
        %{name: "working on it now", key: 3}
      ]
    },
    %{
      key: "done",
      name: "Done",
      tasks: [
        %{name: "already done task", key: 4}
      ]
    }
  ]

  def default_columns, do: @default_columns

  def get_all_columns(columns), do: columns

  def get_tasks_from_column(columns, column_key) do
    case Enum.find(columns, fn col -> col.key == column_key end) do
      %{tasks: tasks} -> tasks
      nil -> []
    end
  end

  def create_task_in_column(columns, task_key, column_key) do
    with %{} = col <- Enum.find(columns, fn col -> col.key == column_key end),
         {key, _} = Integer.parse(task_key) do
      [%{key: key, name: nil} | col.tasks]
      |> build_column(col)
      |> replace_in_collection(columns)
    else
      _ -> columns
    end
  end

  def update_task(columns, task_key, new_task_name) do
    with {key, _} <- Integer.parse(task_key),
         {%{} = col, %{} = tsk} <-
           Enum.find(tasks_with_columns(columns), fn {_, tsk} -> tsk.key == key end) do
      new_task_name
      |> build_task(tsk)
      |> replace_in_collection(col.tasks)
      |> build_column(col)
      |> replace_in_collection(columns)
    else
      _ -> columns
    end
  end

  def move_task_to_column(columns, task_key, column_key) do
    with {key, _} <- Integer.parse(task_key),
         {%{} = col, %{} = tsk} <-
           Enum.find(tasks_with_columns(columns), fn {_, tsk} -> tsk.key == key end) do
      Enum.map(columns, fn c ->
        case {c.key == col.key, c.key == column_key} do
          {true, false} -> build_column(Enum.reject(c.tasks, fn t -> t.key == tsk.key end), c)
          {false, true} -> build_column([tsk | c.tasks], c)
          {_, _} -> c
        end
      end)
    else
      _ -> columns
    end
  end

  def delete_task(columns, task_key) do
    with {key, _} <- Integer.parse(task_key),
         {%{} = col, %{} = tsk} <-
           Enum.find(tasks_with_columns(columns), fn {_, tsk} -> tsk.key == key end) do
      columns
      |> Enum.map(fn c ->
        if c.key == col.key do
          build_column(Enum.reject(c.tasks, fn t -> t.key == tsk.key end), c)
        else
          c
        end
      end)
    else
      _ -> columns
    end
  end

  def delete_all_tasks(columns) do
    Enum.map(columns, fn column -> %{column | tasks: []} end)
  end

  defp tasks_with_columns(columns) do
    Enum.flat_map(columns, fn col ->
      Enum.map(col.tasks, fn tsk -> {col, tsk} end)
    end)
  end

  defp build_task(name, task), do: %{task | name: name}

  defp build_column(tasks, column), do: %{column | tasks: tasks}

  defp replace_in_collection(new_map, collection) do
    Enum.map(collection, fn m -> if m.key == new_map.key, do: new_map, else: m end)
  end
end
