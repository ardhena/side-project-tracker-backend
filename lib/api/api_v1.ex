defmodule Todo.API.V1 do
  use Maru.Router

  resources do
    get do
      json(conn, %{hello: :world})
    end
  end
end
