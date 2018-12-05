defmodule SideProjectTracker.ProjectStorageTest do
  use ExUnit.Case, async: false

  describe "get and update" do
    test "updates data in agent storage" do
      storage = SideProjectTracker.ProjectStorage.get()

      assert is_map(storage)

      assert SideProjectTracker.ProjectStorage.update([]) == :ok
      assert SideProjectTracker.ProjectStorage.get() == []

      assert SideProjectTracker.ProjectStorage.update(storage) == :ok
      assert SideProjectTracker.ProjectStorage.get() == storage
    end
  end
end
