defmodule SideProjectTracker.API.V1 do
  use Maru.Router
  alias SideProjectTracker.{OTP.MainServer, Projects.Project}

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

    route_param :project_key do
      namespace "tasks" do
        ## OPTIONS /tasks ##
        options do
        end

        ## GET /tasks ##
        get do
          json(conn, params[:project_key] |> MainServer.get() |> Project.to_old_format())
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
              {params[:task_key], String.to_atom(params[:column_key])}
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
        end

        patch ":key" do
          json(
            conn,
            MainServer.perform(
              params[:project_key],
              :update_task,
              {params[:key], params[:task_name]}
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
              {params[:key], String.to_atom(params[:column_key])}
            )
          )
        end
      end
    end
  end
end
