defmodule Todo.API.V1 do
  use Maru.Router

  get do
    json(conn, %{message: "API V1"})
  end

  resources "tasks" do
    ## /tasks ##
    options do
    end

    ## get all tasks ##
    get do
      json(conn, Todo.fetch_tasks())
    end

    ## delete all tasks ##
    delete do
      json(conn, Todo.delete_tasks())
    end

    ## create task ##
    params do
      requires(:column_key, type: String)
      requires(:task_key, type: String)
    end

    post do
      Todo.create_task(params[:task_key], params[:column_key])
      json(conn, :ok)
    end

    ## /tasks/:key ##
    options ":key" do
    end

    ## get tasks for column ##
    params do
      requires(:key, type: String)
    end

    get ":key" do
      json(conn, Todo.fetch_tasks(params[:key]))
    end

    ## delete task ##
    params do
      requires(:key, type: String)
    end

    delete ":key" do
      json(conn, Todo.delete_task(params[:key]))
    end

    ## update task ##
    params do
      requires(:key, type: String)
      requires(:task_name, type: String)
    end

    put ":key" do
      Todo.update_task(params[:key], params[:task_name])
      json(conn, :ok)
    end

    ## /tasks/:key/move ##
    options ":key/move" do
    end

    ## move task ##
    params do
      requires(:key, type: String)
      requires(:column_key, type: String)
    end

    post ":key/move" do
      Todo.move_task(params[:key], params[:column_key])
      json(conn, :ok)
    end
  end
end
