defmodule Todo.API do
  use Maru.Router

  before do
    plug(Plug.Logger)
  end

  plug(CORSPlug)
  plug(
    Plug.Parsers,
    pass: ["*/*"],
    json_decoder: Jason,
    parsers: [:urlencoded, :json, :multipart]
  )

  namespace :api do
    namespace :v1 do
      mount(Todo.API.V1)
    end
  end

  rescue_from([MatchError, RuntimeError], with: :custom_error)

  rescue_from :all, as: e do
    conn
    |> put_status(Plug.Exception.status(e))
    |> json(error_message(Plug.Exception.status(e)))
  end

  defp custom_error(conn, exception) do
    conn
    |> put_status(500)
    |> json(exception.message)
  end

  defp error_message(400), do: %{message: "Bad Request", code: 400}
  defp error_message(401), do: %{message: "Unauthorized", code: 401}
  defp error_message(404), do: %{message: "Not Found", code: 404}
  defp error_message(code), do: %{message: code, code: code}
end
