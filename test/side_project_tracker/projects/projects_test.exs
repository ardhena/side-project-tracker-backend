defmodule SideProjectTracker.ProjectsTest do
  use ExUnit.Case, async: false
  import SideProjectTracker.Factory
  import Mock
  alias SideProjectTracker.Projects
  alias SideProjectTracker.Storage.ProjectsAdapter
  alias SideProjectTracker.OTP.Projects.{Server, Supervisor}

  describe "get_projects/0" do
    test "returns project keys" do
      with_mocks([
        {ProjectsAdapter, [:passthrough], [list_projects: fn -> [build(:project)] end]}
      ]) do
        assert [%{key: "default"}] == Projects.get_projects()
      end
    end
  end

  describe "sync_projects/0" do
    test "syncs memory into files" do
      with_mocks([
        {ProjectsAdapter, [:passthrough],
         [
           list_projects: fn -> [build(:project)] end,
           save: fn _arg -> {:ok, "filename.json"} end
         ]},
        {Server, [:passthrough], [get: fn _arg -> :ok end]}
      ]) do
        assert [ok: "filename.json"] == Projects.sync_projects()
      end
    end
  end

  describe "new_project/1" do
    test "creates new project" do
      with_mocks([
        {ProjectsAdapter, [:passthrough], [save: fn _arg -> {:ok, "filename.json"} end]},
        {Server, [:passthrough], [get: fn _arg -> :ok end]},
        {Supervisor, [:passthrough], [add_child: fn _arg -> {:ok, "pid"} end]}
      ]) do
        assert :ok = Projects.new_project("new_project_key")
      end
    end
  end

  describe "get_project/1" do
    test "gets project" do
      project = build(:project)

      with_mocks([
        {Server, [:passthrough], [get: fn _arg -> project end]}
      ]) do
        assert ^project = Projects.get_project("default")
      end
    end
  end

  describe "get_project_tasks/1" do
    test "gets project tasks" do
      project = build(:project)

      with_mocks([
        {Server, [:passthrough], [get: fn _arg -> project end]}
      ]) do
        assert [
                 %{
                   key: "todo",
                   name: "To do",
                   tasks: [
                     %{key: "1", name: "some task", version: nil},
                     %{key: "2", name: "another task", version: nil}
                   ]
                 },
                 %{
                   key: "doing",
                   name: "Doing",
                   tasks: [%{key: "3", name: "working on it now", version: nil}]
                 },
                 %{
                   key: "done",
                   name: "Done",
                   tasks: [%{key: "4", name: "already done task", version: nil}]
                 }
               ] = Projects.get_project_tasks("default")
      end
    end
  end

  describe "new_project_task/2" do
    test "creates new task in a project" do
      with_mocks([
        {Server, [:passthrough],
         [
           perform: fn
             :default_server, :new_task, {"7", "doing", "top"} -> :ok
             _, _, _ -> :error
           end
         ]}
      ]) do
        assert :ok = Projects.new_project_task("default", {"7", "doing", "top"})
      end
    end
  end

  describe "update_project_task/2" do
    test "updates task in a project" do
      with_mocks([
        {Server, [:passthrough],
         [
           perform: fn
             :default_server, :update_task, {"7", "task name", "v1.0.0"} -> :ok
             _, _, _ -> :error
           end
         ]}
      ]) do
        assert :ok = Projects.update_project_task("default", {"7", "task name", "v1.0.0"})
      end
    end
  end

  describe "move_project_task/2" do
    test "moves task to a column" do
      with_mocks([
        {Server, [:passthrough],
         [
           perform: fn
             :default_server, :move_task, {"7", "done"} -> :ok
             _, _, _ -> :error
           end
         ]}
      ]) do
        assert :ok = Projects.move_project_task("default", {"7", "done"})
      end
    end
  end

  describe "delete_project_task/2" do
    test "deletes task from a project" do
      with_mocks([
        {Server, [:passthrough],
         [
           perform: fn
             :default_server, :delete_task, {"7"} -> :ok
             _, _, _ -> :error
           end
         ]}
      ]) do
        assert :ok = Projects.delete_project_task("default", {"7"})
      end
    end
  end

  describe "new_project_version/2" do
    test "creates new version for a project" do
      with_mocks([
        {Server, [:passthrough],
         [
           perform: fn
             :default_server, :new_version, {"v0.0.1"} -> :ok
             _, _, _ -> :error
           end
         ]}
      ]) do
        assert :ok = Projects.new_project_version("default", {"v0.0.1"})
      end
    end
  end
end
