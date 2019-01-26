defmodule SideProjectTracker.OTP.StorageAdapterTest do
  use ExUnit.Case, async: false
  import SideProjectTracker.Factory

  alias SideProjectTracker.OTP.StorageAdapter

  setup do
    project = build(:project)
    {:ok, file_path} = StorageAdapter.save(project)

    %{project: project, file_path: file_path}
  end

  describe "save/1" do
    test "saves project in a default file", %{file_path: file_path} do
      json =
        "{\"columns\":[{\"key\":\"todo\",\"name\":\"To do\"},{\"key\":\"doing\",\"name\":\"Doing\"},{\"key\":\"done\",\"name\":\"Done\"}],\"key\":\"default\",\"tasks\":[{\"column_key\":\"todo\",\"key\":\"1\",\"name\":\"some task\"},{\"column_key\":\"todo\",\"key\":\"2\",\"name\":\"another task\"},{\"column_key\":\"doing\",\"key\":\"3\",\"name\":\"working on it now\"},{\"column_key\":\"done\",\"key\":\"4\",\"name\":\"already done task\"}],\"versions\":[{\"code\":\"v1.0.0\"},{\"code\":\"v1.1.0\"},{\"code\":\"v1.2.0\"}]}"

      assert {:ok, json} == File.read(file_path)

      File.rm!(file_path)
    end
  end

  describe "load/1" do
    test "loads project from default file", %{project: project, file_path: file_path} do
      assert project == StorageAdapter.load(project)

      File.rm!(file_path)
    end
  end

  describe "list_projects/0" do
    test "returns names of project file from directory" do
      assert [
               %SideProjectTracker.Projects.Project{
                 columns: [
                   %SideProjectTracker.Projects.Column{key: "todo", name: "To do"},
                   %SideProjectTracker.Projects.Column{
                     key: "doing",
                     name: "Doing"
                   },
                   %SideProjectTracker.Projects.Column{key: "done", name: "Done"}
                 ],
                 key: "default",
                 tasks: [],
                 versions: []
               }
             ] = StorageAdapter.list_projects()
    end
  end

  describe "load_projects/0" do
    test "returns loaded projects from directory" do
      assert [
               %SideProjectTracker.Projects.Project{
                 columns: [
                   %SideProjectTracker.Projects.Column{key: "todo", name: "To do"},
                   %SideProjectTracker.Projects.Column{
                     key: "doing",
                     name: "Doing"
                   },
                   %SideProjectTracker.Projects.Column{key: "done", name: "Done"}
                 ],
                 key: "default",
                 tasks: [
                   %SideProjectTracker.Projects.Task{
                     column_key: "todo",
                     key: "1",
                     name: "some task"
                   },
                   %SideProjectTracker.Projects.Task{
                     column_key: "todo",
                     key: "2",
                     name: "another task"
                   },
                   %SideProjectTracker.Projects.Task{
                     column_key: "doing",
                     key: "3",
                     name: "working on it now"
                   },
                   %SideProjectTracker.Projects.Task{
                     column_key: "done",
                     key: "4",
                     name: "already done task"
                   }
                 ]
               }
             ] = StorageAdapter.load_projects()
    end
  end
end
