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
      json(conn, SideProjectTracker.fetch_tasks())
    end

    ## DELETE /tasks ##
    delete do
      json(conn, SideProjectTracker.delete_tasks())
    end

    ## POST /tasks ##
    params do
      requires(:column_key, type: String)
      requires(:task_key, type: String)
    end

    post do
      json(
        conn,
        SideProjectTracker.create_task(
          String.to_atom(params[:task_key]),
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
      json(conn, SideProjectTracker.delete_task(String.to_atom(params[:key])))
    end

    ## PATCH /tasks/:key ##
    params do
      requires(:key, type: String)
      requires(:task_name, type: String)
    end

    patch ":key" do
      json(conn, SideProjectTracker.update_task(String.to_atom(params[:key]), params[:task_name]))
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
        SideProjectTracker.move_task(
          String.to_atom(params[:key]),
          String.to_atom(params[:column_key])
        )
      )
    end
  end
end
