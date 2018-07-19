defmodule Todo.API.V1 do
  use Maru.Router

  get do
    json(conn, %{message: "API V1"})
  end

  resources "tasks" do
    get do
      json(conn, Todo.Storage.Adapter.fetch)
    end

    params do
      requires :key, type: String
    end
    get ":key" do
      json(conn, Todo.Storage.Adapter.fetch_from_column(params[:key]))
    end
  end
end
