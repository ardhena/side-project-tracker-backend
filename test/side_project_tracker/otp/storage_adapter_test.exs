defmodule SideProjectTracker.OTP.StorageAdapterTest do
  use ExUnit.Case, async: false
  alias SideProjectTracker.{OTP.StorageAdapter, Projects.Project}

  describe "save/1" do
    test "saves project in a default file" do
      project = Project.new()

      assert {:ok, file_path} = StorageAdapter.save(project)

      json =
        "{\"columns\":[{\"key\":\"todo\",\"name\":\"To do\"},{\"key\":\"doing\",\"name\":\"Doing\"},{\"key\":\"done\",\"name\":\"Done\"}],\"key\":\"default\",\"tasks\":[{\"column_key\":\"todo\",\"key\":\"1\",\"name\":\"some task\"},{\"column_key\":\"todo\",\"key\":\"2\",\"name\":\"another task\"},{\"column_key\":\"doing\",\"key\":\"3\",\"name\":\"working on it now\"},{\"column_key\":\"done\",\"key\":\"4\",\"name\":\"already done task\"}]}"

      assert {:ok, json} == File.read(file_path)

      File.rm!(file_path)
    end
  end

  describe "load/1" do
    test "loads project from default file" do
      project = Project.new()
      {:ok, file_path} = StorageAdapter.save(project)

      assert project == StorageAdapter.load(project)

      File.rm!(file_path)
    end
  end

  describe "list_projects/0" do
    test "returns names of project file from directory" do
      project = Project.new()
      assert {:ok, _file_path} = StorageAdapter.save(project)

      assert [
              %SideProjectTracker.Projects.Project{
                columns: [
                  %SideProjectTracker.Projects.Column{key: :todo, name: "To do"},
                  %SideProjectTracker.Projects.Column{
                    key: :doing,
                    name: "Doing"
                  },
                  %SideProjectTracker.Projects.Column{key: :done, name: "Done"}
                ],
                key: "default",
                tasks: nil
              }
            ] = StorageAdapter.list_projects()
    end
  end

  describe "load_projects/0" do
    test "returns loaded projects from directory" do
      project = Project.new()
      assert {:ok, _file_path} = StorageAdapter.save(project)

      assert [
               %SideProjectTracker.Projects.Project{
                 columns: [
                   %SideProjectTracker.Projects.Column{key: :todo, name: "To do"},
                   %SideProjectTracker.Projects.Column{
                     key: :doing,
                     name: "Doing"
                   },
                   %SideProjectTracker.Projects.Column{key: :done, name: "Done"}
                 ],
                 key: "default",
                 tasks: [
                   %SideProjectTracker.Projects.Task{
                     column_key: :todo,
                     key: "1",
                     name: "some task"
                   },
                   %SideProjectTracker.Projects.Task{
                     column_key: :todo,
                     key: "2",
                     name: "another task"
                   },
                   %SideProjectTracker.Projects.Task{
                     column_key: :doing,
                     key: "3",
                     name: "working on it now"
                   },
                   %SideProjectTracker.Projects.Task{
                     column_key: :done,
                     key: "4",
                     name: "already done task"
                   }
                 ]
               }
             ] = StorageAdapter.load_projects()
    end
  end
end
