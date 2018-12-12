defmodule SideProjectTracker.StorageAdapterTest do
  use ExUnit.Case, async: false

  describe "save/1" do
    test "saves project in a default file" do
      project = SideProjectTracker.Projects.Project.new()

      assert {:ok, file_path} = SideProjectTracker.StorageAdapter.save(project)

      json =
        "{\"columns\":[{\"key\":\"todo\",\"name\":\"To do\"},{\"key\":\"doing\",\"name\":\"Doing\"},{\"key\":\"done\",\"name\":\"Done\"}],\"key\":\"default\",\"name\":\"Default\",\"tasks\":[{\"column_key\":\"todo\",\"key\":\"1\",\"name\":\"some task\"},{\"column_key\":\"todo\",\"key\":\"2\",\"name\":\"another task\"},{\"column_key\":\"doing\",\"key\":\"3\",\"name\":\"working on it now\"},{\"column_key\":\"done\",\"key\":\"4\",\"name\":\"already done task\"}]}"

      assert {:ok, json} == File.read(file_path)

      File.rm!(file_path)
    end
  end

  describe "load/0" do
    test "loads project from default file" do
      project = SideProjectTracker.Projects.Project.new()
      {:ok, file_path} = SideProjectTracker.StorageAdapter.save(project)

      assert project == SideProjectTracker.StorageAdapter.load()

      File.rm!(file_path)
    end
  end
end
