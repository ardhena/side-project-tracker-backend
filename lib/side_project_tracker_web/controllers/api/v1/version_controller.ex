defmodule SideProjectTrackerWeb.Api.V1.VersionController do
  use SideProjectTrackerWeb, :controller

  def create(conn, %{"project_id" => project_key, "code" => code}) do
    :ok = MainServer.perform(project_key, :new_version, {code})

    render_ok(conn)
  end

  def create(conn, _params), do: render_400(conn)
end
