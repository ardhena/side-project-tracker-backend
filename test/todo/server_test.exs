defmodule SideProjectTracker.ServerTest do
  use ExUnit.Case, async: false

  def assert_task_in_column(columns, task, column_key) do
    assert task in Enum.find(columns, fn %{key: key} -> key == column_key end).tasks
    columns
  end

  def assert_task_not_in_column(columns, task, column_key) do
    assert task not in Enum.find(columns, fn %{key: key} -> key == column_key end).tasks
    columns
  end

  def assert_equal_agent_storage(columns) do
    assert columns == SideProjectTracker.Storage.get()
  end

  setup do
    SideProjectTracker.Storage.update(SideProjectTracker.Impl.default_columns())
    {:ok, pid} = GenServer.start_link(SideProjectTracker.Server, :ok, [])
    %{server: pid}
  end

  describe "fetch_tasks/1" do
    test "returns tasks from genserver storage", %{server: server} do
      assert SideProjectTracker.Server.fetch_tasks(server) == [
               %{
                 key: "to-do",
                 name: "To do",
                 tasks: [%{key: 1, name: "some task"}, %{key: 2, name: "another task"}]
               },
               %{key: "doing", name: "Doing", tasks: [%{key: 3, name: "working on it now"}]},
               %{key: "done", name: "Done", tasks: [%{key: 4, name: "already done task"}]}
             ]

      GenServer.stop(server)
    end
  end

  describe "create_task/3" do
    test "creates task in genserver storage and storage agent", %{server: server} do
      assert SideProjectTracker.Server.create_task(server, "6", "to-do") == :ok

      server
      |> SideProjectTracker.Server.fetch_tasks()
      |> assert_task_in_column(%{key: 6, name: nil}, "to-do")
      |> assert_equal_agent_storage()

      GenServer.stop(server)
    end
  end

  describe "update_task/3" do
    test "updates task in genserver storage and storage agent", %{server: server} do
      assert SideProjectTracker.Server.update_task(server, "1", "new task name") == :ok

      server
      |> SideProjectTracker.Server.fetch_tasks()
      |> assert_task_in_column(%{key: 1, name: "new task name"}, "to-do")
      |> assert_task_not_in_column(%{key: 1, name: "some task"}, "to-do")
      |> assert_equal_agent_storage()

      assert SideProjectTracker.Server.update_task(server, "2", "another updated name") == :ok

      server
      |> SideProjectTracker.Server.fetch_tasks()
      |> assert_task_in_column(%{key: 2, name: "another updated name"}, "to-do")
      |> assert_task_not_in_column(%{key: 2, name: "another task"}, "to-do")
      |> assert_equal_agent_storage()

      assert SideProjectTracker.Server.update_task(server, "0", "this task does not exist") == :ok

      server
      |> SideProjectTracker.Server.fetch_tasks()
      |> assert_task_not_in_column(%{key: 0, name: "this task does not exist"}, "to-do")
      |> assert_task_not_in_column(%{key: 0, name: "this task does not exist"}, "doing")
      |> assert_task_not_in_column(%{key: 0, name: "this task does not exist"}, "done")
      |> assert_equal_agent_storage()

      GenServer.stop(server)
    end
  end

  describe "move_task/3" do
    test "moves task in genserver storage and storage agent", %{server: server} do
      assert SideProjectTracker.Server.move_task(server, "1", "done") == :ok

      server
      |> SideProjectTracker.Server.fetch_tasks()
      |> assert_task_not_in_column(%{key: 1, name: "some task"}, "to-do")
      |> assert_task_in_column(%{key: 1, name: "some task"}, "done")
      |> assert_equal_agent_storage()

      assert SideProjectTracker.Server.move_task(server, "3", "doing") == :ok

      server
      |> SideProjectTracker.Server.fetch_tasks()
      |> assert_task_in_column(%{key: 3, name: "working on it now"}, "doing")
      |> assert_equal_agent_storage()

      GenServer.stop(server)
    end
  end

  describe "delete_tasks/1" do
    test "deletes all tasks from genserver storage and storage agent", %{server: server} do
      assert SideProjectTracker.Server.delete_tasks(server) == :ok

      data = SideProjectTracker.Server.fetch_tasks(server)

      assert data == [
               %{key: "to-do", name: "To do", tasks: []},
               %{key: "doing", name: "Doing", tasks: []},
               %{key: "done", name: "Done", tasks: []}
             ]

      assert_equal_agent_storage(data)

      GenServer.stop(server)
    end
  end

  describe "delete_task/2" do
    test "deletes one task from genserver storage and storage agent", %{server: server} do
      assert SideProjectTracker.Server.delete_task(server, "1") == :ok

      server
      |> SideProjectTracker.Server.fetch_tasks()
      |> assert_task_not_in_column(%{key: 1, name: "some task"}, "to-do")
      |> assert_task_not_in_column(%{key: 1, name: "some task"}, "doing")
      |> assert_task_not_in_column(%{key: 1, name: "some task"}, "done")
      |> assert_equal_agent_storage()

      GenServer.stop(server)
    end
  end
end
