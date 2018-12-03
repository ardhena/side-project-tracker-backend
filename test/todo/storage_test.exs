defmodule SideProjectTracker.StorageTest do
  use ExUnit.Case, async: false

  describe "get and update" do
    test "updates data in agent storage" do
      storage = SideProjectTracker.Storage.get()

      assert is_list(storage)

      assert SideProjectTracker.Storage.update([]) == :ok
      assert SideProjectTracker.Storage.get() == []

      assert SideProjectTracker.Storage.update(storage) == :ok
      assert SideProjectTracker.Storage.get() == storage
    end
  end
end
