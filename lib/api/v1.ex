defmodule Todo.API.V1 do
  use Maru.Router

  get do
    json(conn, %{message: "API V1"})
  end

  resources "tasks" do
    ## get all tasks ##
    get do
      json(conn, Todo.Storage.Adapter.fetch_tasks())
    end

    ## get tasks for column ##
    params do
      requires(:key, type: String)
    end

    get ":key" do
      json(conn, Todo.Storage.Adapter.fetch_tasks(params[:key]))
    end

    ## create task ##
    params do
      requires(:column_key, type: String)
      requires(:task_key, type: String)
    end

    post do
      Todo.Storage.Adapter.create_task(params[:task_key], params[:column_key])
      json(conn, :ok)
    end

    options do
    end

    ## update task ##
    params do
      requires(:key, type: String)
      requires(:task_name, type: String)
    end

    put ":key" do
      Todo.Storage.Adapter.update_task(params[:key], params[:task_name])
      json(conn, :ok)
    end

    options ":key" do
    end

    ## move task ##
    params do
      requires(:key, type: String)
      requires(:column_key, type: String)
    end

    post ":key/move" do
      Todo.Storage.Adapter.move_task(params[:key], params[:column_key])
      json(conn, :ok)
    end

    options ":key/move" do
    end

    ## delete all tasks ##
    delete do
      json(conn, Todo.Storage.Adapter.delete_tasks())
    end
  end
end
