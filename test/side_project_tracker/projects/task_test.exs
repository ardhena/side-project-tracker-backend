defmodule SideProjectTracker.Projects.TaskTest do
  use ExUnit.Case, async: false
  import SideProjectTracker.Factory

  alias SideProjectTracker.Projects.Task

  setup do
    %{task: build(:task_todo)}
  end

  describe "new/1" do
    test "returns task", %{task: task} do
      assert Task.new(%{"column_key" => task.column_key, "key" => task.key, "name" => task.name}) ==
               %Task{column_key: "todo", key: "1", name: "some task"}
    end
  end

  describe "update/2" do
    test "updates name", %{task: task} do
      assert Task.update(task, name: "updated name") == %Task{
               column_key: "todo",
               key: "1",
               name: "updated name"
             }
    end

    test "updates column key", %{task: task} do
      assert Task.update(task, column_key: "done") == %Task{
               column_key: "done",
               key: "1",
               name: "some task"
             }
    end
  end
end
