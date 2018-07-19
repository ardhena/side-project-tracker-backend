defmodule Todo.API.V1 do
  use Maru.Router

  resources do
    get do
      json(conn, %{message: "API V1"})
    end
  end
end
