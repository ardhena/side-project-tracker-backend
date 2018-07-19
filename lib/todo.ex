defmodule Todo do
  use Application

  def start(_type, _args) do
    Todo.Supervisor.start_link(name: Todo.Supervisor)
  end
end
