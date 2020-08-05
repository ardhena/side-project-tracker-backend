defmodule SideProjectTrackerWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use SideProjectTrackerWeb, :controller
      use SideProjectTrackerWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: SideProjectTrackerWeb

      import Plug.Conn
      alias SideProjectTrackerWeb.Router.Helpers, as: Routes

      alias SideProjectTracker.Projects

      def render_ok(conn) do
        conn
        |> put_status(:no_content)
        |> render(:ok)
      end

      def render_400(conn) do
        conn
        |> put_status(:bad_request)
        |> put_view(SideProjectTrackerWeb.ErrorView)
        |> render(:"400")
      end
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/side_project_tracker_web/templates",
        namespace: SideProjectTrackerWeb

      use Phoenix.HTML

      alias SideProjectTrackerWeb.Router.Helpers, as: Routes

      def render("ok.json", _assigns) do
        %{status: :ok}
      end
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
