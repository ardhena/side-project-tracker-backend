defmodule SideProjectTracker.Projects.Column do
  defstruct [:key, :name]

  def all() do
    [
      %__MODULE__{key: :todo, name: "To do"},
      %__MODULE__{key: :doing, name: "Doing"},
      %__MODULE__{key: :done, name: "Done"}
    ]
  end

  def new(%{"key" => key, "name" => name}) do
    %__MODULE__{
      key: String.to_atom(key),
      name: name
    }
  end
end
