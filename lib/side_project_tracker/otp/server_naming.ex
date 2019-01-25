defmodule SideProjectTracker.OTP.ServerNaming do
  alias SideProjectTracker.Projects.Project

  def name(:storage, %Project{key: key}), do: String.to_atom("#{key}_storage")
  def name(:storage, key), do: String.to_atom("#{key}_storage")

  def name(:server, %Project{key: key}), do: String.to_atom("#{key}_server")
  def name(:server, key), do: String.to_atom("#{key}_server")
end
