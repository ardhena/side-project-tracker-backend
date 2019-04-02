defmodule SideProjectTrackerWeb.Api.V1.TaskController do
  use SideProjectTrackerWeb, :controller

  def index(conn, %{"project_id" => project_key}) do
    conn
    |> assign(:columns, MainServer.get_tasks(project_key))
    |> render(:columns)
  end

  def create(conn, %{
        "project_id" => project_key,
        "column_key" => column_key,
        "task_key" => task_key,
        "position" => position
      }) do
    :ok = MainServer.perform(project_key, :new_task, {task_key, column_key, position})

    render_ok(conn)
  end

  def create(conn, _params), do: render_400(conn)

  def update(conn, %{
        "project_id" => project_key,
        "id" => task_key,
        "task_name" => name,
        "task_version" => version
      }) do
    :ok = MainServer.perform(project_key, :update_task, {task_key, name, version})

    render_ok(conn)
  end

  def update(conn, %{"project_id" => project_key, "id" => task_key, "task_name" => name}) do
    :ok = MainServer.perform(project_key, :update_task, {task_key, name, nil})

    render_ok(conn)
  end

  def update(conn, _params), do: render_400(conn)

  def move(conn, %{"project_id" => project_key, "id" => task_key, "column_key" => column_key}) do
    :ok = MainServer.perform(project_key, :move_task, {task_key, column_key})

    render_ok(conn)
  end

  def move(conn, _params), do: render_400(conn)

  def delete(conn, %{"project_id" => project_key, "id" => task_key}) do
    :ok = MainServer.perform(project_key, :delete_task, {task_key})

    render_ok(conn)
  end
end
