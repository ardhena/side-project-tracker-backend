defmodule TodoTest do
  use ExUnit.Case

  test "application is already running" do
    assert {:error, {:already_started, _}} = Todo.start(%{}, %{})
  end
end
