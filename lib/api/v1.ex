defmodule SideProjectTracker.API.V1 do
  use Maru.Router
  alias SideProjectTracker.OTP.MainServer

  get do
    json(conn, %{message: "API V1"})
  end

  namespace "projects" do
    ## OPTIONS /projects ##
    options do
    end

    ## GET /projects ##
    get do
      json(conn, MainServer.get_projects())
    end

    ## POST /projects ##
    params do
      requires(:key, type: String)
    end

    post do
      json(conn, MainServer.new_project(params[:key]))
    end

    route_param :project_key do
      ## OPTIONS /:project_key ##
      options do
      end

      ## GET /:project_key
      get do
        json(conn, params[:project_key] |> MainServer.get())
      end

      namespace "versions" do
        ## OPTIONS /versions ##
        options do
        end

        ## POST /versions ##
        params do
          requires(:code, type: String)
        end

        post do
          json(
            conn,
            MainServer.perform(params[:project_key], :new_version, {params[:code]})
          )
        end
      end

      namespace "tasks" do
        ## OPTIONS /tasks ##
        options do
        end

        ## GET /tasks ##
        get do
          json(conn, params[:project_key] |> MainServer.get_tasks())
        end

        ## DELETE /tasks ##
        delete do
          json(conn, MainServer.perform(params[:project_key], :delete_tasks, {}))
        end

        ## POST /tasks ##
        params do
          requires(:column_key, type: String)
          requires(:task_key, type: String)
        end

        post do
          json(
            conn,
            MainServer.perform(
              params[:project_key],
              :new_task,
              {params[:task_key], params[:column_key]}
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
          json(conn, MainServer.perform(params[:project_key], :delete_task, {params[:key]}))
        end

        ## PATCH /tasks/:key ##
        params do
          requires(:key, type: String)
          requires(:task_name, type: String)
          requires(:task_version, type: String)
        end

        patch ":key" do
          json(
            conn,
            MainServer.perform(
              params[:project_key],
              :update_task,
              {params[:key], params[:task_name], params[:task_version]}
            )
          )
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
            MainServer.perform(
              params[:project_key],
              :move_task,
              {params[:key], params[:column_key]}
            )
          )
        end
      end
    end
  end
end
