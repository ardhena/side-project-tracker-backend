defmodule SideProjectTracker.Projects.Task do
  @derive Jason.Encoder

  defstruct [:column_key, :key, :name, :version]

  def new(%{"column_key" => column_key, "key" => key, "name" => name, "version" => version}) do
    %__MODULE__{
      column_key: column_key,
      key: key,
      name: name,
      version: version
    }
  end

  def new(%{"column_key" => column_key, "key" => key, "name" => name}) do
    %__MODULE__{
      column_key: column_key,
      key: key,
      name: name
    }
  end

  def new(%{column_key: column_key, key: key, name: name}) do
    %__MODULE__{
      column_key: column_key,
      key: key,
      name: name
    }
  end

  def update(task, name: new_name), do: %__MODULE__{task | name: new_name}
  def update(task, version: new_version), do: %__MODULE__{task | version: new_version}
  def update(task, column_key: new_column_key), do: %__MODULE__{task | column_key: new_column_key}
end
