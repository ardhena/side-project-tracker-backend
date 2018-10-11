defmodule Todo.Storage.Adapter do
  def fetch_tasks do
    Todo.Storage.fetch_tasks(Todo.Storage)
  end

  def fetch_tasks(column_key) do
    Todo.Storage.fetch_tasks(Todo.Storage, column_key)
  end

  def create_task(task_key, column_key) do
    Todo.Storage.create_task(Todo.Storage, task_key, column_key)
  end

  def update_task(task_key, task_name) do
    Todo.Storage.update_task(Todo.Storage, task_key, task_name)
  end

  def move_task(task_key, column_key) do
    Todo.Storage.move_task(Todo.Storage, task_key, column_key)
  end

  def delete_tasks() do
    Todo.Storage.delete_tasks(Todo.Storage)
  end
end
