defmodule SideProjectTracker.OTP.ProjectStorageTest do
  use ExUnit.Case, async: false
  alias SideProjectTracker.OTP.ProjectStorage

  describe "get and update" do
    test "updates data in agent storage" do
      storage = ProjectStorage.get()

      assert is_map(storage)

      assert ProjectStorage.update([]) == :ok
      assert ProjectStorage.get() == []

      assert ProjectStorage.update(storage) == :ok
      assert ProjectStorage.get() == storage
    end
  end
end
