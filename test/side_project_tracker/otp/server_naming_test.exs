defmodule SideProjectTracker.OTP.ServerNamingTest do
  use ExUnit.Case, async: false
  alias SideProjectTracker.{OTP.ServerNaming, Projects.Project}

  describe "name/2" do
    test "returns storage name" do
      assert :default_storage = ServerNaming.name(:storage, Project.new())

      assert :default_storage = ServerNaming.name(:storage, "default")
    end

    test "returns server name" do
      assert :default_server = ServerNaming.name(:server, Project.new())

      assert :default_server = ServerNaming.name(:server, "default")
    end
  end
end
