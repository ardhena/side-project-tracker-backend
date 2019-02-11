defmodule SideProjectTrackerWeb.Api.V1.VersionControllerTest do
  use SideProjectTrackerWeb.ConnCase

  describe "POST create" do
    test "returns 400", %{conn: conn} do
      conn = post(conn, api_v1_project_version_path(conn, :create, "default", %{}))

      assert %{"code" => "400", "message" => "Bad Request"} == json_response(conn, 400)
    end

    test "returns ok", %{conn: conn} do
      conn = post(conn, api_v1_project_version_path(conn, :create, "default", %{code: "v1.0.0"}))

      assert %{"status" => "ok"} == json_response(conn, 204)
    end
  end
end
