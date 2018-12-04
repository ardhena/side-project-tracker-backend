defmodule SideProjectTracker.API.V1 do
  use Maru.Router

  get do
    json(conn, %{message: "API V1"})
  end

  resources "tasks" do
    ## OPTIONS /tasks ##
    options do
    end

    ## GET /tasks ##
    get do
      json(
        conn,
        SideProjectTracker.Server.fetch_tasks()
        |> SideProjectTracker.Projects.Project.to_old_format()
      )
    end

    ## DELETE /tasks ##
    delete do
      json(conn, SideProjectTracker.Server.delete_tasks())
    end

    ## POST /tasks ##
    params do
      requires(:column_key, type: String)
      requires(:task_key, type: String)
    end

    post do
      json(
        conn,
        SideProjectTracker.Server.create_task(
          params[:task_key],
          String.to_atom(params[:column_key])
        )
      )
    end

    ## OPTIONS /tasks/:key ##
    options ":key" do
    end

    ## DELETE /tasks/:key ##
    params do
      requires(:key, type: String)
    end

    delete ":key" do
      json(conn, SideProjectTracker.Server.delete_task(params[:key]))
    end

    ## PATCH /tasks/:key ##
    params do
      requires(:key, type: String)
      requires(:task_name, type: String)
    end

    patch ":key" do
      json(conn, SideProjectTracker.Server.update_task(params[:key], params[:task_name]))
    end

    ## OPTIONS /tasks/:key/move ##
    options ":key/move" do
    end

    ## POST /tasks/:key/move ##
    params do
      requires(:key, type: String)
      requires(:column_key, type: String)
    end

    post ":key/move" do
      json(
        conn,
        SideProjectTracker.Server.move_task(
          params[:key],
          String.to_atom(params[:column_key])
        )
      )
    end
  end
end
