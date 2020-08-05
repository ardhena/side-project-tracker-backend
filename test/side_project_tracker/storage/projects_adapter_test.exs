defmodule SideProjectTracker.Storage.ProjectsAdapterTest do
  use ExUnit.Case, async: false
  import SideProjectTracker.Factory

  alias SideProjectTracker.Storage.ProjectsAdapter

  setup do
    project = build(:project)
    {:ok, file_path} = ProjectsAdapter.save(project)

    %{project: project, file_path: file_path}
  end

  describe "save/1" do
    test "saves project in a default file only if it's different than before", %{
      file_path: file_path,
      project: project
    } do
      json =
        "{\"columns\":[{\"key\":\"todo\",\"name\":\"To do\"},{\"key\":\"doing\",\"name\":\"Doing\"},{\"key\":\"done\",\"name\":\"Done\"}],\"key\":\"default\",\"tasks\":[{\"column_key\":\"todo\",\"key\":\"1\",\"name\":\"some task\",\"version\":null},{\"column_key\":\"todo\",\"key\":\"2\",\"name\":\"another task\",\"version\":null},{\"column_key\":\"doing\",\"key\":\"3\",\"name\":\"working on it now\",\"version\":null},{\"column_key\":\"done\",\"key\":\"4\",\"name\":\"already done task\",\"version\":null}],\"versions\":[{\"code\":\"v1.0.0\"},{\"code\":\"v1.1.0\"},{\"code\":\"v1.2.0\"}]}"

      assert {:ok, json} == File.read(file_path)

      {:ok, %{mtime: last_write_time}} = File.stat(file_path, time: :posix)

      # without changes in file - don't write to file
      :timer.sleep(1000)

      assert {:ok, ^file_path} = ProjectsAdapter.save(project)

      assert {:ok, json} == File.read(file_path)

      {:ok, %{mtime: new_last_write_time}} = File.stat(file_path, time: :posix)

      assert last_write_time == new_last_write_time

      # with changes in file - write to file
      :timer.sleep(1000)

      changed_project = build(:project, tasks: [build(:task_todo)])

      changed_json =
        "{\"columns\":[{\"key\":\"todo\",\"name\":\"To do\"},{\"key\":\"doing\",\"name\":\"Doing\"},{\"key\":\"done\",\"name\":\"Done\"}],\"key\":\"default\",\"tasks\":[{\"column_key\":\"todo\",\"key\":\"1\",\"name\":\"some task\",\"version\":null}],\"versions\":[{\"code\":\"v1.0.0\"},{\"code\":\"v1.1.0\"},{\"code\":\"v1.2.0\"}]}"

      assert {:ok, ^file_path} = ProjectsAdapter.save(changed_project)

      assert {:ok, changed_json} == File.read(file_path)

      {:ok, %{mtime: newest_last_write_time}} = File.stat(file_path, time: :posix)

      assert new_last_write_time != newest_last_write_time

      File.rm!(file_path)
    end
  end

  describe "load/1" do
    test "loads project from default file", %{project: project, file_path: file_path} do
      assert project == ProjectsAdapter.load(project)

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
             ] = ProjectsAdapter.list_projects()
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
             ] = ProjectsAdapter.load_projects()
    end
  end
end
