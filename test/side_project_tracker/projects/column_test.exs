defmodule SideProjectTracker.Projects.ColumnTest do
  use ExUnit.Case, async: false

  alias SideProjectTracker.Projects.Column

  describe "all/0" do
    test "returns default columns" do
      assert Column.all() == [
               %Column{key: :todo, name: "To do"},
               %Column{key: :doing, name: "Doing"},
               %Column{key: :done, name: "Done"}
             ]
    end
  end
end
