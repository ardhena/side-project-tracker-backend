defmodule Todo.ServerTest do
  use ExUnit.Case, async: false

  setup do
    storage = start_supervised!(Todo.Server)
    %{storage: storage}
  end

  test "fetch_tasks/1", %{storage: storage} do
    assert Todo.Server.fetch_tasks(storage) == [
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
    assert Todo.Server.fetch_tasks(storage, "to-do") == [
             %{key: 1, name: "some task"},
             %{key: 2, name: "another task"}
           ]

    assert Todo.Server.fetch_tasks(storage, "doing") == [%{key: 3, name: "working on it now"}]
    assert Todo.Server.fetch_tasks(storage, "done") == [%{key: 4, name: "already done task"}]
    assert Todo.Server.fetch_tasks(storage, "nonexistingcolumnkey") == []
  end

  test "create_task/3", %{storage: storage} do
    Todo.Server.create_task(storage, "6", "to-do")

    assert Todo.Server.fetch_tasks(storage, "to-do") == [
             %{key: 6, name: nil},
             %{key: 1, name: "some task"},
             %{key: 2, name: "another task"}
           ]
  end

  test "update_task/3", %{storage: storage} do
    Todo.Server.update_task(storage, "1", "new task name")

    assert Todo.Server.fetch_tasks(storage) == [
             %{
               key: "to-do",
               name: "To do",
               tasks: [%{key: 1, name: "new task name"}, %{key: 2, name: "another task"}]
             },
             %{key: "doing", name: "Doing", tasks: [%{key: 3, name: "working on it now"}]},
             %{key: "done", name: "Done", tasks: [%{key: 4, name: "already done task"}]}
           ]

    Todo.Server.update_task(storage, "2", "another updated name")

    assert Todo.Server.fetch_tasks(storage) == [
             %{
               key: "to-do",
               name: "To do",
               tasks: [%{key: 1, name: "new task name"}, %{key: 2, name: "another updated name"}]
             },
             %{key: "doing", name: "Doing", tasks: [%{key: 3, name: "working on it now"}]},
             %{key: "done", name: "Done", tasks: [%{key: 4, name: "already done task"}]}
           ]

    Todo.Server.update_task(storage, "0", "this task does not exist")

    assert Todo.Server.fetch_tasks(storage) == [
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
    Todo.Server.move_task(storage, "1", "done")

    assert Todo.Server.fetch_tasks(storage, "to-do") == [%{key: 2, name: "another task"}]

    assert Todo.Server.fetch_tasks(storage, "done") == [
             %{key: 1, name: "some task"},
             %{key: 4, name: "already done task"}
           ]

    Todo.Server.move_task(storage, "3", "doing")
    assert Todo.Server.fetch_tasks(storage, "doing") == [%{key: 3, name: "working on it now"}]
  end

  test "delete_tasks/1", %{storage: storage} do
    Todo.Server.delete_tasks(storage)

    assert Todo.Server.fetch_tasks(storage) == [
             %{key: "to-do", name: "To do", tasks: []},
             %{key: "doing", name: "Doing", tasks: []},
             %{key: "done", name: "Done", tasks: []}
           ]

    assert Todo.Server.fetch_tasks(storage, "to-do") == []
    assert Todo.Server.fetch_tasks(storage, "doing") == []
    assert Todo.Server.fetch_tasks(storage, "done") == []
  end

  test "delete_task/2", %{storage: storage} do
    Todo.Server.delete_task(storage, "1")

    assert Todo.Server.fetch_tasks(storage) == [
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
