defmodule Todo.API.V1Test do
  use ExUnit.Case, async: false
  use Maru.Test
  import Mock

  test "GET /api/v1" do
    assert get("/api/v1") |> json_response == %{"message" => "API V1"}
  end

  test "GET /api/v1/tasks" do
    with_mocks([
      {Todo, [:passthrough], [fetch_tasks: fn -> Todo.Impl.default_columns() end]}
    ]) do
      assert get("/api/v1/tasks") |> json_response == [
               %{
                 "key" => "to-do",
                 "name" => "To do",
                 "tasks" => [
                   %{"key" => 1, "name" => "some task"},
                   %{"key" => 2, "name" => "another task"}
                 ]
               },
               %{
                 "key" => "doing",
                 "name" => "Doing",
                 "tasks" => [%{"key" => 3, "name" => "working on it now"}]
               },
               %{
                 "key" => "done",
                 "name" => "Done",
                 "tasks" => [%{"key" => 4, "name" => "already done task"}]
               }
             ]
    end
  end

  test "GET /api/v1/tasks/:column_key" do
    with_mocks([
      {Todo, [:passthrough],
       [
         fetch_tasks: fn key ->
           %{tasks: tasks} =
             Todo.Impl.default_columns() |> Enum.find(fn col -> col.key == key end)

           tasks
         end
       ]}
    ]) do
      assert get("/api/v1/tasks/done") |> json_response == [
               %{"key" => 4, "name" => "already done task"}
             ]
    end
  end

  test "POST /api/v1/tasks/:key" do
    assert post("/api/v1/tasks") |> json_response == %{
             "code" => 400,
             "message" => "Bad Request"
           }

    assert build_conn()
           |> put_body_or_params(%{column_key: "doing", task_key: "6"})
           |> post("/api/v1/tasks")
           |> json_response == "ok"
  end

  test "PUT /api/v1/tasks/:key" do
    assert put("/api/v1/tasks/1") |> json_response == %{
             "code" => 400,
             "message" => "Bad Request"
           }

    assert build_conn()
           |> put_body_or_params(%{task_name: "new name"})
           |> put("/api/v1/tasks/1")
           |> json_response == "ok"
  end

  test "POST /api/v1/tasks/:key/move" do
    assert post("/api/v1/tasks/1/move") |> json_response == %{
             "code" => 400,
             "message" => "Bad Request"
           }

    assert build_conn()
           |> put_body_or_params(%{column_key: "doing"})
           |> post("/api/v1/tasks/1/move")
           |> json_response == "ok"
  end

  test "DELETE /api/v1/tasks" do
    assert delete("/api/v1/tasks") |> json_response == "ok"
  end

  test "DELETE /api/v1/tasks/:key" do
    assert delete("/api/v1/tasks/1") |> json_response == "ok"
  end
end
