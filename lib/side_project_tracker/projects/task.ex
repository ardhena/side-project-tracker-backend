defmodule SideProjectTracker.Projects.Task do
  defstruct [:column_key, :key, :name]

  def new(column_key, key, name) do
    %__MODULE__{
      column_key: column_key,
      key: key,
      name: name
    }
  end

  def new(%{"column_key" => column_key, "key" => key, "name" => name}) do
    %__MODULE__{
      column_key: String.to_atom(column_key),
      key: key,
      name: name
    }
  end

  def update(task, name: new_name), do: %__MODULE__{task | name: new_name}

  def update(task, column_key: new_column_key), do: %__MODULE__{task | column_key: new_column_key}
end
