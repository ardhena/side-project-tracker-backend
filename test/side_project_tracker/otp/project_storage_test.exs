defmodule SideProjectTracker.OTP.ProjectStorageTest do
  use ExUnit.Case, async: false
  import SideProjectTracker.Factory

  alias SideProjectTracker.OTP.ProjectStorage

  describe "get and update" do
    test "updates data in agent storage" do
      {:ok, server} = GenServer.start_link(ProjectStorage, build(:project), [])

      storage = ProjectStorage.get(server)

      assert is_map(storage)

      assert ProjectStorage.update(server, []) == :ok
      assert ProjectStorage.get(server) == []

      assert ProjectStorage.update(server, storage) == :ok
      assert ProjectStorage.get(server) == storage
    end
  end
end
