defmodule SideProjectTracker.Projects.VersionTest do
  use ExUnit.Case, async: false
  alias SideProjectTracker.Projects.Version

  describe "new/1" do
    test "returns version" do
      assert Version.new(%{"code" => "v1.0.0"}) == %Version{code: "v1.0.0"}
      assert Version.new(%{code: "v1.0.0"}) == %Version{code: "v1.0.0"}
    end
  end
end
