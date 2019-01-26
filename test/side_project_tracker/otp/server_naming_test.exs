defmodule SideProjectTracker.OTP.ServerNamingTest do
  use ExUnit.Case, async: false
  import SideProjectTracker.Factory

  alias SideProjectTracker.OTP.ServerNaming

  setup do
    %{project: build(:project)}
  end

  describe "name/2" do
    test "returns storage name", %{project: project} do
      assert :default_storage = ServerNaming.name(:storage, project)

      assert :default_storage = ServerNaming.name(:storage, "default")
    end

    test "returns server name", %{project: project} do
      assert :default_server = ServerNaming.name(:server, project)

      assert :default_server = ServerNaming.name(:server, "default")
    end
  end
end
