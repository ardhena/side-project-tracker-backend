defmodule SideProjectTrackerWeb.Api.ErrorView do
  use SideProjectTrackerWeb, :view

  def render("bad_request.json", _), do: %{code: "400", message: "Bad Request"}
end
