defmodule SideProjectTracker.Projects.TaskTest do
  use ExUnit.Case, async: false

  alias SideProjectTracker.Projects.Task

  describe "new/3" do
    test "returns task" do
      assert Task.new(:todo, 1, "test 1") == %Task{column_key: :todo, key: 1, name: "test 1"}
      assert Task.new(:doing, 2, "test 2") == %Task{column_key: :doing, key: 2, name: "test 2"}
      assert Task.new(:done, 3, "test 3") == %Task{column_key: :done, key: 3, name: "test 3"}
    end
  end

  describe "update/2" do
    test "updates name" do
      task = %Task{column_key: :todo, key: 1, name: "test 1"}

      assert Task.update(task, name: "updated name") == %Task{
               column_key: :todo,
               key: 1,
               name: "updated name"
             }
    end

    test "updates columnn key" do
      task = %Task{column_key: :todo, key: 1, name: "test 1"}

      assert Task.update(task, column_key: :done) == %Task{
               column_key: :done,
               key: 1,
               name: "test 1"
             }
    end
  end
end
