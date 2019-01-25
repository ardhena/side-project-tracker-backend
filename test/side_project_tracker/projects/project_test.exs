defmodule SideProjectTracker.Projects.ProjectTest do
  use ExUnit.Case, async: false

  alias SideProjectTracker.Projects.{Column, Project, Task}

  describe "new/0" do
    test "returns default project columns and tasks" do
      assert Project.new() == %Project{
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
    end
  end

  describe "put/3" do
    test "replaces tasks in a project" do
      project = Project.new()

      assert Project.put(project, :tasks, []).tasks == []
    end
  end

  describe "add_task_to_column/3" do
    test "adds new task to list of tasks" do
      project = Project.new()

      assert Project.add_task_to_column(project, "5", :todo).tasks == [
               %Task{column_key: :todo, key: "5", name: nil},
               %Task{column_key: :todo, key: "1", name: "some task"},
               %Task{column_key: :todo, key: "2", name: "another task"},
               %Task{column_key: :doing, key: "3", name: "working on it now"},
               %Task{column_key: :done, key: "4", name: "already done task"}
             ]
    end
  end

  describe "update_task/3" do
    test "updates task name in list of tasks" do
      project = Project.new()

      assert Project.update_task(project, "4", "new name").tasks == [
               %Task{column_key: :todo, key: "1", name: "some task"},
               %Task{column_key: :todo, key: "2", name: "another task"},
               %Task{column_key: :doing, key: "3", name: "working on it now"},
               %Task{column_key: :done, key: "4", name: "new name"}
             ]
    end
  end

  describe "delete_task/2" do
    test "removes task from list of tasks" do
      project = Project.new()

      assert Project.delete_task(project, "3").tasks == [
               %Task{column_key: :todo, key: "1", name: "some task"},
               %Task{column_key: :todo, key: "2", name: "another task"},
               %Task{column_key: :done, key: "4", name: "already done task"}
             ]
    end
  end

  describe "move_task_to_column/3" do
    test "updates task column key in list of tasks and moves task to the beginning" do
      project = Project.new()

      assert Project.move_task_to_column(project, "2", :doing).tasks == [
               %Task{column_key: :doing, key: "2", name: "another task"},
               %Task{column_key: :todo, key: "1", name: "some task"},
               %Task{column_key: :doing, key: "3", name: "working on it now"},
               %Task{column_key: :done, key: "4", name: "already done task"}
             ]
    end
  end

  describe "delete_all_tasks/1" do
    test "removes all tasks" do
      project = Project.new()

      assert Project.delete_all_tasks(project).tasks == []
    end
  end

  describe "to_old_format/1" do
    test "returns project formatted in an old way" do
      project = Project.new()

      assert Project.to_old_format(project) == [
               %{
                 key: :todo,
                 name: "To do",
                 tasks: [
                   %{name: "some task", key: "1"},
                   %{name: "another task", key: "2"}
                 ]
               },
               %{
                 key: :doing,
                 name: "Doing",
                 tasks: [
                   %{name: "working on it now", key: "3"}
                 ]
               },
               %{
                 key: :done,
                 name: "Done",
                 tasks: [
                   %{name: "already done task", key: "4"}
                 ]
               }
             ]
    end
  end
end
