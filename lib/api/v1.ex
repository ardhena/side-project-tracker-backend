defmodule Todo.API.V1 do
  use Maru.Router

  get do
    json(conn, %{message: "API V1"})
  end

  resources "tasks" do
    get do
      json(conn, Todo.Storage.Adapter.fetch_tasks())
    end

    params do
      requires(:key, type: String)
    end

    get ":key" do
      json(conn, Todo.Storage.Adapter.fetch_tasks(params[:key]))
    end

    params do
      requires(:key, type: String)

      group :task, type: Map do
        requires(:name, type: String)
      end
    end

    put ":key" do
      Todo.Storage.Adapter.update_task(params[:key], params[:task][:name])
      json(conn, :ok)
    end

    params do
      requires(:key, type: String)

      group :column, type: Map do
        requires(:name, type: String)
      end
    end

    post ":key/move" do
      Todo.Storage.Adapter.move_task(params[:key], params[:column][:name])
      json(conn, :ok)
    end
  end
end
