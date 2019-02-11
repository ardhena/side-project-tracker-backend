defmodule SideProjectTrackerWeb.Api.V1.ProjectControllerTest do
  use SideProjectTrackerWeb.ConnCase
  alias SideProjectTracker.OTP.{MainServer, ProjectServer, StorageAdapter}

  describe "GET index" do
    test "returns projects", %{conn: conn} do
      with_mocks([
        {StorageAdapter, [:passthrough], [list_projects: fn -> [build(:project)] end]}
      ]) do
        conn = get(conn, api_v1_project_path(conn, :index))

        assert [
                 %{"key" => "default"}
               ] == json_response(conn, 200)
      end
    end
  end

  describe "GET show" do
    test "returns project", %{conn: conn} do
      with_mocks([
        {ProjectServer, [:passthrough], [get: fn _arg -> build(:project) end]}
      ]) do
        conn = get(conn, api_v1_project_path(conn, :show, "default"))

        assert %{
                 "key" => "default",
                 "versions" => [
                   %{"code" => "v1.0.0"},
                   %{"code" => "v1.1.0"},
                   %{"code" => "v1.2.0"}
                 ]
               } == json_response(conn, 200)
      end
    end
  end

  describe "POST create" do
    test "returns 400", %{conn: conn} do
      conn = post(conn, api_v1_project_path(conn, :create, %{}))

      assert %{"code" => "400", "message" => "Bad Request"} == json_response(conn, 400)
    end

    test "returns ok", %{conn: conn} do
      with_mocks([
        {MainServer, [:passthrough], [new_project: fn _arg -> :ok end]}
      ]) do
        conn = post(conn, api_v1_project_path(conn, :create, %{key: "new project"}))

        assert %{"status" => "ok"} == json_response(conn, 204)
      end
    end
  end
end
