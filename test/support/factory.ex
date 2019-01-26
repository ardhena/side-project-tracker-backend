defmodule SideProjectTracker.Factory do
  use ExMachina

  def project_factory do
    %SideProjectTracker.Projects.Project{
      key: "default",
      columns: SideProjectTracker.Projects.Column.all(),
      tasks: [
        build(:task_todo),
        build(:task_todo, key: "2", name: "another task"),
        build(:task_doing),
        build(:task_done)
      ],
      versions: [
        %SideProjectTracker.Projects.Version{code: "v1.0.0"},
        %SideProjectTracker.Projects.Version{code: "v1.1.0"},
        %SideProjectTracker.Projects.Version{code: "v1.2.0"}
      ]
    }
  end

  def task_todo_factory do
    %SideProjectTracker.Projects.Task{column_key: "todo", key: "1", name: "some task"}
  end

  def task_doing_factory do
    %SideProjectTracker.Projects.Task{column_key: "doing", key: "3", name: "working on it now"}
  end

  def task_done_factory do
    %SideProjectTracker.Projects.Task{column_key: "done", key: "4", name: "already done task"}
  end
end
