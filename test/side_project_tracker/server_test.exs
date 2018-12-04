defmodule SideProjectTracker.ServerTest do
  use ExUnit.Case, async: false

  alias SideProjectTracker.Projects.{Column, Project, Task}

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

  def assert_equal_agent_storage(project) do
    assert project == SideProjectTracker.Storage.get()
  end

  setup do
    SideProjectTracker.Storage.update(Project.new())
    {:ok, pid} = GenServer.start_link(SideProjectTracker.Server, :ok, [])
    %{server: pid}
  end

  describe "fetch_tasks/1" do
    test "returns tasks from genserver storage", %{server: server} do
      assert SideProjectTracker.Server.fetch_tasks(server) == %Project{
               columns: [
                 %Column{key: :todo, name: "To do"},
                 %Column{key: :doing, name: "Doing"},
                 %Column{key: :done, name: "Done"}
               ],
               tasks: [
                 %Task{column_key: :todo, key: :"1", name: "some task"},
                 %Task{column_key: :todo, key: :"2", name: "another task"},
                 %Task{column_key: :doing, key: :"3", name: "working on it now"},
                 %Task{column_key: :done, key: :"4", name: "already done task"}
               ]
             }

      GenServer.stop(server)
    end
  end

  describe "create_task/3" do
    test "creates task in genserver storage and storage agent", %{server: server} do
      assert SideProjectTracker.Server.create_task(server, :"6", :todo) == :ok

      server
      |> SideProjectTracker.Server.fetch_tasks()
      |> assert_task_in_column(%{key: :"6", name: nil}, :todo)
      |> assert_equal_agent_storage()

      GenServer.stop(server)
    end
  end

  describe "update_task/3" do
    test "updates task in genserver storage and storage agent", %{server: server} do
      assert SideProjectTracker.Server.update_task(server, :"1", "new task name") == :ok

      server
      |> SideProjectTracker.Server.fetch_tasks()
      |> assert_task_in_column(%{key: :"1", name: "new task name"}, :todo)
      |> assert_task_not_in_column(%{key: :"1", name: "some task"}, :todo)
      |> assert_equal_agent_storage()

      assert SideProjectTracker.Server.update_task(server, :"2", "another updated name") == :ok

      server
      |> SideProjectTracker.Server.fetch_tasks()
      |> assert_task_in_column(%{key: :"2", name: "another updated name"}, :todo)
      |> assert_task_not_in_column(%{key: :"2", name: "another task"}, :todo)
      |> assert_equal_agent_storage()

      assert SideProjectTracker.Server.update_task(server, :"0", "this task does not exist") ==
               :ok

      server
      |> SideProjectTracker.Server.fetch_tasks()
      |> assert_task_not_in_column(%{key: :"0", name: "this task does not exist"}, :todo)
      |> assert_task_not_in_column(%{key: :"0", name: "this task does not exist"}, :doing)
      |> assert_task_not_in_column(%{key: :"0", name: "this task does not exist"}, :done)
      |> assert_equal_agent_storage()

      GenServer.stop(server)
    end
  end

  describe "move_task/3" do
    test "moves task in genserver storage and storage agent", %{server: server} do
      assert SideProjectTracker.Server.move_task(server, :"1", :done) == :ok

      server
      |> SideProjectTracker.Server.fetch_tasks()
      |> assert_task_not_in_column(%{key: :"1", name: "some task"}, :todo)
      |> assert_task_in_column(%{key: :"1", name: "some task"}, :done)
      |> assert_equal_agent_storage()

      assert SideProjectTracker.Server.move_task(server, :"3", :doing) == :ok

      server
      |> SideProjectTracker.Server.fetch_tasks()
      |> assert_task_in_column(%{key: :"3", name: "working on it now"}, :doing)
      |> assert_equal_agent_storage()

      GenServer.stop(server)
    end
  end

  describe "delete_tasks/1" do
    test "deletes all tasks from genserver storage and storage agent", %{server: server} do
      assert SideProjectTracker.Server.delete_tasks(server) == :ok

      data = SideProjectTracker.Server.fetch_tasks(server)

      assert data == %Project{
               columns: [
                 %Column{key: :todo, name: "To do"},
                 %Column{key: :doing, name: "Doing"},
                 %Column{key: :done, name: "Done"}
               ],
               tasks: []
             }

      assert_equal_agent_storage(data)

      GenServer.stop(server)
    end
  end

  describe "delete_task/2" do
    test "deletes one task from genserver storage and storage agent", %{server: server} do
      assert SideProjectTracker.Server.delete_task(server, :"1") == :ok

      server
      |> SideProjectTracker.Server.fetch_tasks()
      |> assert_task_not_in_column(%{key: :"1", name: "some task"}, :todo)
      |> assert_task_not_in_column(%{key: :"1", name: "some task"}, :doing)
      |> assert_task_not_in_column(%{key: :"1", name: "some task"}, :done)
      |> assert_equal_agent_storage()

      GenServer.stop(server)
    end
  end
end
