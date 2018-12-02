defmodule Todo.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    children = [
      {Todo.Server, [name: Todo.Server]}
    ]

    Supervisor.start_link(children, name: Todo.Supervisor, strategy: :one_for_one)
  end
end
