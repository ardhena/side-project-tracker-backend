defmodule SideProjectTracker.OTP.ProjectServerTest do
  use ExUnit.Case, async: false

  alias SideProjectTracker.Projects.{Column, Project, Task}
  alias SideProjectTracker.OTP.{ProjectServer, ProjectStorage}

  def assert_task_in_column(project, %{key: key, name: name}, column_key) do
    assert %Task{} =
             Enum.find(project.tasks, fn %{key: k, name: n, column_key: ck} ->
               k == key and n == name and ck == column_key
             end)

    project
  end

  def assert_task_not_in_column(project, %{key: key, name: name}, column_key) do
    assert nil ==
             Enum.find(project.tasks, fn %{key: k, name: n, column_key: ck} ->
               k == key and n == name and ck == column_key
             end)

    project
  end

  def assert_equal_agent_storage(project, storage) do
    assert project == ProjectStorage.get(storage)
  end

  setup do
    {:ok, storage} = GenServer.start_link(ProjectStorage, Project.new(), [])

    {:ok, server} = GenServer.start_link(ProjectServer, storage, [])

    %{server: server, storage: storage}
  end

  describe "get/1" do
    test "returns tasks from genserver storage", %{server: server} do
      assert ProjectServer.get(server) == %Project{
               key: "default",
               columns: [
                 %Column{key: :todo, name: "To do"},
                 %Column{key: :doing, name: "Doing"},
                 %Column{key: :done, name: "Done"}
               ],
               tasks: [
                 %Task{column_key: :todo, key: "1", name: "some task"},
                 %Task{column_key: :todo, key: "2", name: "another task"},
                 %Task{column_key: :doing, key: "3", name: "working on it now"},
                 %Task{column_key: :done, key: "4", name: "already done task"}
               ]
             }

      GenServer.stop(server)
    end
  end

  describe "perform/3" do
    test "new_task - creates task in genserver storage and storage agent", %{
      server: server,
      storage: storage
    } do
      assert ProjectServer.perform(server, :new_task, {"6", :todo}) == :ok

      server
      |> ProjectServer.get()
      |> assert_task_in_column(%{key: "6", name: nil}, :todo)
      |> assert_equal_agent_storage(storage)

      GenServer.stop(server)
    end

    test "update_task - updates task in genserver storage and storage agent", %{
      server: server,
      storage: storage
    } do
      assert ProjectServer.perform(
               server,
               :update_task,
               {"1", "new task name"}
             ) == :ok

      server
      |> ProjectServer.get()
      |> assert_task_in_column(%{key: "1", name: "new task name"}, :todo)
      |> assert_task_not_in_column(%{key: "1", name: "some task"}, :todo)
      |> assert_equal_agent_storage(storage)

      assert ProjectServer.perform(
               server,
               :update_task,
               {"2", "another updated name"}
             ) == :ok

      server
      |> ProjectServer.get()
      |> assert_task_in_column(%{key: "2", name: "another updated name"}, :todo)
      |> assert_task_not_in_column(%{key: "2", name: "another task"}, :todo)
      |> assert_equal_agent_storage(storage)

      assert ProjectServer.perform(
               server,
               :update_task,
               {"0", "this task does not exist"}
             ) == :ok

      server
      |> ProjectServer.get()
      |> assert_task_not_in_column(%{key: "0", name: "this task does not exist"}, :todo)
      |> assert_task_not_in_column(%{key: "0", name: "this task does not exist"}, :doing)
      |> assert_task_not_in_column(%{key: "0", name: "this task does not exist"}, :done)
      |> assert_equal_agent_storage(storage)

      GenServer.stop(server)
    end

    test "move_task - moves task in genserver storage and storage agent", %{
      server: server,
      storage: storage
    } do
      assert ProjectServer.perform(server, :move_task, {"1", :done}) == :ok

      server
      |> ProjectServer.get()
      |> assert_task_not_in_column(%{key: "1", name: "some task"}, :todo)
      |> assert_task_in_column(%{key: "1", name: "some task"}, :done)
      |> assert_equal_agent_storage(storage)

      assert ProjectServer.perform(server, :move_task, {"3", :doing}) == :ok

      server
      |> ProjectServer.get()
      |> assert_task_in_column(%{key: "3", name: "working on it now"}, :doing)
      |> assert_equal_agent_storage(storage)

      GenServer.stop(server)
    end

    test "delete_task - deletes one task from genserver storage and storage agent", %{
      server: server,
      storage: storage
    } do
      assert ProjectServer.perform(server, :delete_task, {"1"}) == :ok

      server
      |> ProjectServer.get()
      |> assert_task_not_in_column(%{key: "1", name: "some task"}, :todo)
      |> assert_task_not_in_column(%{key: "1", name: "some task"}, :doing)
      |> assert_task_not_in_column(%{key: "1", name: "some task"}, :done)
      |> assert_equal_agent_storage(storage)

      GenServer.stop(server)
    end

    test "delete_tasks - deletes all tasks from genserver storage and storage agent", %{
      server: server,
      storage: storage
    } do
      assert ProjectServer.perform(server, :delete_tasks, {}) == :ok

      data = ProjectServer.get(server)

      assert data == %Project{
               key: "default",
               columns: [
                 %Column{key: :todo, name: "To do"},
                 %Column{key: :doing, name: "Doing"},
                 %Column{key: :done, name: "Done"}
               ],
               tasks: []
             }

      assert_equal_agent_storage(data, storage)

      GenServer.stop(server)
    end
  end
end
