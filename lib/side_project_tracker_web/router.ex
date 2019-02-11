defmodule SideProjectTrackerWeb.Router do
  use SideProjectTrackerWeb, :router

  pipeline :api do
    plug CORSPlug
    plug :accepts, ["json"]
  end

  scope "/api/v1", SideProjectTrackerWeb.Api.V1, as: :api_v1 do
    pipe_through :api

    resources("/projects", ProjectController, only: [:index, :create, :show]) do
      resources("/versions", VersionController, only: [:create])
      options("/versions", VersionController, :options)

      resources("/tasks", TaskController, only: [:index, :create, :update, :delete])
      delete("/tasks", TaskController, :delete_all)
      post("/tasks/:id/move", TaskController, :move)

      options("/move", TaskController, :options)
      options("/tasks", TaskController, :options)
      options("/tasks/:id", TaskController, :options)
    end

    options("/projects", ProjectController, :options)
    options("/projects/:id", ProjectController, :options)
  end
end
