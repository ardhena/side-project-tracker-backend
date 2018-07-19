defmodule Todo.Storage.Adapter do
  def fetch do
    Todo.Storage.fetch(Todo.Storage)
  end

  def fetch_from_column(key) do
    Todo.Storage.fetch_from_column(Todo.Storage, key)
  end
end
