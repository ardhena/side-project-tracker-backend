defmodule SideProjectTracker.OTP.Projects.StorageTest do
  use ExUnit.Case, async: false
  import SideProjectTracker.Factory

  alias SideProjectTracker.OTP.Projects.Storage

  describe "get and update" do
    test "updates data in agent storage" do
      {:ok, server} = GenServer.start_link(Storage, build(:project), [])

      storage = Storage.get(server)

      assert is_map(storage)

      assert Storage.update(server, []) == :ok
      assert Storage.get(server) == []

      assert Storage.update(server, storage) == :ok
      assert Storage.get(server) == storage
    end
  end
end
