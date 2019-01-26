defmodule SideProjectTracker.Projects.Column do
  @derive Jason.Encoder

  defstruct [:key, :name]

  def all() do
    [
      %__MODULE__{key: "todo", name: "To do"},
      %__MODULE__{key: "doing", name: "Doing"},
      %__MODULE__{key: "done", name: "Done"}
    ]
  end

  def new(%{"key" => key, "name" => name}) do
    %__MODULE__{
      key: key,
      name: name
    }
  end

  def new(%{key: key, name: name}) do
    %__MODULE__{
      key: key,
      name: name
    }
  end
end
