defmodule SideProjectTrackerWeb.Api.V1.TaskControllerTest do
  use SideProjectTrackerWeb.ConnCase
  alias SideProjectTracker.{OTP.MainServer, Projects.Project}

  describe "GET index" do
    test "returns projects", %{conn: conn} do
      with_mocks([
        {MainServer, [:passthrough],
         [get_project_tasks: fn _arg -> build(:project) |> Project.to_old_format() end]}
      ]) do
        conn = get(conn, api_v1_project_task_path(conn, :index, "default"))

        assert [
                 %{
                   "key" => "todo",
                   "name" => "To do",
                   "tasks" => [
                     %{"key" => "1", "name" => "some task", "version" => nil},
                     %{"key" => "2", "name" => "another task", "version" => nil}
                   ]
                 },
                 %{
                   "key" => "doing",
                   "name" => "Doing",
                   "tasks" => [%{"key" => "3", "name" => "working on it now", "version" => nil}]
                 },
                 %{
                   "key" => "done",
                   "name" => "Done",
                   "tasks" => [%{"key" => "4", "name" => "already done task", "version" => nil}]
                 }
               ] == json_response(conn, 200)
      end
    end
  end

  describe "POST create" do
    test "returns 400 without any body", %{conn: conn} do
      conn = post(conn, api_v1_project_task_path(conn, :create, "default", %{}))

      assert %{"code" => "400", "message" => "Bad Request"} == json_response(conn, 400)
    end

    test "returns 400 without position", %{conn: conn} do
      conn =
        post(
          conn,
          api_v1_project_task_path(conn, :create, "default", %{column_key: "doing", task_key: "6"})
        )

      assert %{"code" => "400", "message" => "Bad Request"} == json_response(conn, 400)
    end

    test "returns ok", %{conn: conn} do
      conn =
        post(
          conn,
          api_v1_project_task_path(conn, :create, "default", %{
            column_key: "doing",
            task_key: "6",
            position: "top"
          })
        )

      assert %{"status" => "ok"} == json_response(conn, 204)
    end
  end

  describe "PATCH update" do
    test "returns 400", %{conn: conn} do
      conn = patch(conn, api_v1_project_task_path(conn, :update, "default", "1", %{}))

      assert %{"code" => "400", "message" => "Bad Request"} == json_response(conn, 400)
    end

    test "returns ok", %{conn: conn} do
      conn =
        patch(
          conn,
          api_v1_project_task_path(conn, :update, "default", "1", %{task_name: "new name"})
        )

      assert %{"status" => "ok"} == json_response(conn, 204)

      conn =
        patch(
          conn,
          api_v1_project_task_path(conn, :update, "default", "1", %{
            task_name: "new name",
            task_version: "v1.0.0"
          })
        )

      assert %{"status" => "ok"} == json_response(conn, 204)
    end
  end

  describe "POST move" do
    test "returns 400", %{conn: conn} do
      conn = post(conn, api_v1_project_task_path(conn, :move, "default", "1", %{}))

      assert %{"code" => "400", "message" => "Bad Request"} == json_response(conn, 400)
    end

    test "returns ok", %{conn: conn} do
      conn =
        post(conn, api_v1_project_task_path(conn, :move, "default", "1", %{column_key: "doing"}))

      assert %{"status" => "ok"} == json_response(conn, 204)
    end
  end

  describe "DELETE delete" do
    test "returns ok", %{conn: conn} do
      conn = delete(conn, api_v1_project_task_path(conn, :delete, "default", "1"))

      assert %{"status" => "ok"} == json_response(conn, 204)
    end
  end
end
