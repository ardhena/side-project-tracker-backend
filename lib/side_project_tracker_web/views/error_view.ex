defmodule SideProjectTrackerWeb.ErrorView do
  use SideProjectTrackerWeb, :view

  def render("400.json", _), do: %{code: "400", message: "Bad Request"}
  def render("500.json", _), do: %{code: "500", message: "Server Error"}
end
