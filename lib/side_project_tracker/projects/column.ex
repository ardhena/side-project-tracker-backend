defmodule SideProjectTracker.Projects.Column do
  defstruct [:key, :name]

  def all() do
    [
      %__MODULE__{key: :todo, name: "To do"},
      %__MODULE__{key: :doing, name: "Doing"},
      %__MODULE__{key: :done, name: "Done"}
    ]
  end
end
