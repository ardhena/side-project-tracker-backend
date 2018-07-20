defmodule Todo.SupervisorTest do
  use ExUnit.Case

  test "supervisor is already running with children" do
    assert [{Todo.Storage, _, :worker, [Todo.Storage]}] = Supervisor.which_children(Todo.Supervisor)
  end
end


