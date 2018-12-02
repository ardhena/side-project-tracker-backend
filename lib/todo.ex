defmodule Todo do
  def fetch_tasks do
    Todo.Server.fetch_tasks(Todo.Server)
  end

  def fetch_tasks(column_key) do
    Todo.Server.fetch_tasks(Todo.Server, column_key)
  end

  def create_task(task_key, column_key) do
    Todo.Server.create_task(Todo.Server, task_key, column_key)
  end

  def update_task(task_key, task_name) do
    Todo.Server.update_task(Todo.Server, task_key, task_name)
  end

  def move_task(task_key, column_key) do
    Todo.Server.move_task(Todo.Server, task_key, column_key)
  end

  def delete_tasks() do
    Todo.Server.delete_tasks(Todo.Server)
  end

  def delete_task(task_key) do
    Todo.Server.delete_task(Todo.Server, task_key)
  end

  def break() do
    Todo.Server.break(Todo.Server)
  end
end
