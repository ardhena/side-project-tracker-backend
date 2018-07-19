defmodule Todo.API do
  use Maru.Router

  before do
    plug(Plug.Logger)
  end

  plug(
    Plug.Parsers,
    pass: ["*/*"],
    json_decoder: Jason,
    parsers: [:urlencoded, :json, :multipart]
  )

  mount(Todo.API.V1)

  rescue_from([MatchError, RuntimeError], with: :custom_error)

  rescue_from :all, as: e do
    conn
    |> put_status(Plug.Exception.status(e))
    |> text(error_message(Plug.Exception.status(e)))
  end

  defp custom_error(conn, exception) do
    conn
    |> put_status(500)
    |> text(exception.message)
  end

  defp error_message(400), do: "Bad Request"
  defp error_message(401), do: "Unauthorized"
  defp error_message(404), do: "Not Found"
  defp error_message(code), do: code
end
