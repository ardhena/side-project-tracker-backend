defmodule SideProjectTracker.ServerTest do
  use ExUnit.Case, async: false

  setup do
    storage = start_supervised!(SideProjectTracker.Server)
    %{storage: storage}
  end

  test "fetch_tasks/1", %{storage: storage} do
    assert SideProjectTracker.Server.fetch_tasks(storage) == [
             %{
               key: "to-do",
               name: "To do",
               tasks: [%{key: 1, name: "some task"}, %{key: 2, name: "another task"}]
             },
             %{key: "doing", name: "Doing", tasks: [%{key: 3, name: "working on it now"}]},
             %{key: "done", name: "Done", tasks: [%{key: 4, name: "already done task"}]}
           ]
  end

  test "fetch_tasks/2", %{storage: storage} do
    assert SideProjectTracker.Server.fetch_tasks(storage, "to-do") == [
             %{key: 1, name: "some task"},
             %{key: 2, name: "another task"}
           ]

    assert SideProjectTracker.Server.fetch_tasks(storage, "doing") == [%{key: 3, name: "working on it now"}]
    assert SideProjectTracker.Server.fetch_tasks(storage, "done") == [%{key: 4, name: "already done task"}]
    assert SideProjectTracker.Server.fetch_tasks(storage, "nonexistingcolumnkey") == []
  end

  test "create_task/3", %{storage: storage} do
    SideProjectTracker.Server.create_task(storage, "6", "to-do")

    assert SideProjectTracker.Server.fetch_tasks(storage, "to-do") == [
             %{key: 6, name: nil},
             %{key: 1, name: "some task"},
             %{key: 2, name: "another task"}
           ]
  end

  test "update_task/3", %{storage: storage} do
    SideProjectTracker.Server.update_task(storage, "1", "new task name")

    assert SideProjectTracker.Server.fetch_tasks(storage) == [
             %{
               key: "to-do",
               name: "To do",
               tasks: [%{key: 1, name: "new task name"}, %{key: 2, name: "another task"}]
             },
             %{key: "doing", name: "Doing", tasks: [%{key: 3, name: "working on it now"}]},
             %{key: "done", name: "Done", tasks: [%{key: 4, name: "already done task"}]}
           ]

    SideProjectTracker.Server.update_task(storage, "2", "another updated name")

    assert SideProjectTracker.Server.fetch_tasks(storage) == [
             %{
               key: "to-do",
               name: "To do",
               tasks: [%{key: 1, name: "new task name"}, %{key: 2, name: "another updated name"}]
             },
             %{key: "doing", name: "Doing", tasks: [%{key: 3, name: "working on it now"}]},
             %{key: "done", name: "Done", tasks: [%{key: 4, name: "already done task"}]}
           ]

    SideProjectTracker.Server.update_task(storage, "0", "this task does not exist")

    assert SideProjectTracker.Server.fetch_tasks(storage) == [
             %{
               key: "to-do",
               name: "To do",
               tasks: [%{key: 1, name: "new task name"}, %{key: 2, name: "another updated name"}]
             },
             %{key: "doing", name: "Doing", tasks: [%{key: 3, name: "working on it now"}]},
             %{key: "done", name: "Done", tasks: [%{key: 4, name: "already done task"}]}
           ]
  end

  test "move_task/3", %{storage: storage} do
    SideProjectTracker.Server.move_task(storage, "1", "done")

    assert SideProjectTracker.Server.fetch_tasks(storage, "to-do") == [%{key: 2, name: "another task"}]

    assert SideProjectTracker.Server.fetch_tasks(storage, "done") == [
             %{key: 1, name: "some task"},
             %{key: 4, name: "already done task"}
           ]

    SideProjectTracker.Server.move_task(storage, "3", "doing")
    assert SideProjectTracker.Server.fetch_tasks(storage, "doing") == [%{key: 3, name: "working on it now"}]
  end

  test "delete_tasks/1", %{storage: storage} do
    SideProjectTracker.Server.delete_tasks(storage)

    assert SideProjectTracker.Server.fetch_tasks(storage) == [
             %{key: "to-do", name: "To do", tasks: []},
             %{key: "doing", name: "Doing", tasks: []},
             %{key: "done", name: "Done", tasks: []}
           ]

    assert SideProjectTracker.Server.fetch_tasks(storage, "to-do") == []
    assert SideProjectTracker.Server.fetch_tasks(storage, "doing") == []
    assert SideProjectTracker.Server.fetch_tasks(storage, "done") == []
  end

  test "delete_task/2", %{storage: storage} do
    SideProjectTracker.Server.delete_task(storage, "1")

    assert SideProjectTracker.Server.fetch_tasks(storage) == [
             %{
               key: "to-do",
               name: "To do",
               tasks: [%{key: 2, name: "another task"}]
             },
             %{key: "doing", name: "Doing", tasks: [%{key: 3, name: "working on it now"}]},
             %{key: "done", name: "Done", tasks: [%{key: 4, name: "already done task"}]}
           ]
  end
end
