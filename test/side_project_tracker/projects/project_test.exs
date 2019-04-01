defmodule SideProjectTracker.Projects.ProjectTest do
  use ExUnit.Case, async: false
  import SideProjectTracker.Factory

  alias SideProjectTracker.Projects.{Column, Project, Task, Version}

  setup do
    %{project: build(:project)}
  end

  describe "new/1" do
    test "returns project from key", %{project: project} do
      assert Project.new(%{key: project.key}) == %Project{
               key: "default",
               columns: [
                 %Column{key: "todo", name: "To do"},
                 %Column{key: "doing", name: "Doing"},
                 %Column{key: "done", name: "Done"}
               ],
               tasks: [],
               versions: []
             }
    end

    test "returns project from key, columns, tasks", %{project: project} do
      assert Project.new(%{
               "key" => project.key,
               "columns" => project.columns,
               "tasks" => project.tasks,
               "versions" => project.versions
             }) == %Project{
               key: "default",
               columns: [
                 %Column{key: "todo", name: "To do"},
                 %Column{key: "doing", name: "Doing"},
                 %Column{key: "done", name: "Done"}
               ],
               tasks: [
                 %Task{column_key: "todo", key: "1", name: "some task"},
                 %Task{column_key: "todo", key: "2", name: "another task"},
                 %Task{column_key: "doing", key: "3", name: "working on it now"},
                 %Task{column_key: "done", key: "4", name: "already done task"}
               ],
               versions: [
                 %Version{code: "v1.0.0"},
                 %Version{code: "v1.1.0"},
                 %Version{code: "v1.2.0"}
               ]
             }
    end
  end

  describe "put/3" do
    test "replaces tasks in a project", %{project: project} do
      assert Project.put(project, :tasks, []).tasks == []
    end
  end

  describe "add_task_to_column/3" do
    test "adds new task to list of tasks - bottom", %{project: project} do
      assert Project.add_task_to_column(project, "5", "todo", "bottom").tasks == [
               %Task{column_key: "todo", key: "1", name: "some task"},
               %Task{column_key: "todo", key: "2", name: "another task"},
               %Task{column_key: "doing", key: "3", name: "working on it now"},
               %Task{column_key: "done", key: "4", name: "already done task"},
               %Task{column_key: "todo", key: "5", name: nil}
             ]
    end

    test "adds new task to list of tasks - top", %{project: project} do
      assert Project.add_task_to_column(project, "5", "todo", "top").tasks == [
               %Task{column_key: "todo", key: "5", name: nil},
               %Task{column_key: "todo", key: "1", name: "some task"},
               %Task{column_key: "todo", key: "2", name: "another task"},
               %Task{column_key: "doing", key: "3", name: "working on it now"},
               %Task{column_key: "done", key: "4", name: "already done task"}
             ]
    end
  end

  describe "update_task/3" do
    test "updates task name in list of tasks", %{project: project} do
      assert Project.update_task(project, "4", "new name", "new version").tasks == [
               %Task{column_key: "todo", key: "1", name: "some task", version: nil},
               %Task{column_key: "todo", key: "2", name: "another task", version: nil},
               %Task{column_key: "doing", key: "3", name: "working on it now", version: nil},
               %Task{column_key: "done", key: "4", name: "new name", version: "new version"}
             ]
    end
  end

  describe "delete_task/2" do
    test "removes task from list of tasks", %{project: project} do
      assert Project.delete_task(project, "3").tasks == [
               %Task{column_key: "todo", key: "1", name: "some task"},
               %Task{column_key: "todo", key: "2", name: "another task"},
               %Task{column_key: "done", key: "4", name: "already done task"}
             ]
    end
  end

  describe "move_task_to_column/3" do
    test "updates task column key in list of tasks and moves task to the beginning", %{
      project: project
    } do
      assert Project.move_task_to_column(project, "2", "doing").tasks == [
               %Task{column_key: "doing", key: "2", name: "another task"},
               %Task{column_key: "todo", key: "1", name: "some task"},
               %Task{column_key: "doing", key: "3", name: "working on it now"},
               %Task{column_key: "done", key: "4", name: "already done task"}
             ]
    end
  end

  describe "delete_all_tasks/1" do
    test "removes all tasks", %{project: project} do
      assert Project.delete_all_tasks(project).tasks == []
    end
  end

  describe "add_version/2" do
    test "adds new version at the end", %{project: project} do
      assert Project.add_version(project, "v2.0.0").versions == [
               %Version{code: "v1.0.0"},
               %Version{code: "v1.1.0"},
               %Version{code: "v1.2.0"},
               %Version{code: "v2.0.0"}
             ]
    end
  end

  describe "to_old_format/1" do
    test "returns project formatted in an old way", %{project: project} do
      assert Project.to_old_format(project) == [
               %{
                 key: "todo",
                 name: "To do",
                 tasks: [
                   %{name: "some task", key: "1", version: nil},
                   %{name: "another task", key: "2", version: nil}
                 ]
               },
               %{
                 key: "doing",
                 name: "Doing",
                 tasks: [
                   %{name: "working on it now", key: "3", version: nil}
                 ]
               },
               %{
                 key: "done",
                 name: "Done",
                 tasks: [
                   %{name: "already done task", key: "4", version: nil}
                 ]
               }
             ]
    end
  end
end
