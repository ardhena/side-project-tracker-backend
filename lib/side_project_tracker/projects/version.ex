defmodule SideProjectTracker.Projects.Version do
  @derive Jason.Encoder

  defstruct [:code]

  def new(%{"code" => code}) do
    %__MODULE__{code: code}
  end

  def new(%{code: code}) do
    %__MODULE__{code: code}
  end
end
