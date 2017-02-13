defmodule Desqer.SessionController do
  use Desqer.Web, :controller

  plug :scrub_params, "user" when action in [:create]

  def create(conn, %{"user" => user_params}) do
    case Desqer.Action.CreateSession.run(user_params, user_agent(conn), conn.remote_ip) do
      {:ok, user, jwt, exp} ->
        conn
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> put_resp_header("x-expires", "#{exp}")
        |> render("show.json", user: user, jwt: jwt, exp: exp)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Desqer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    conn
    |> Guardian.Plug.current_resource
    |> Ecto.Changeset.change(revoked: true)
    |> Desqer.Repo.update

    json conn, %{detail: "Logged out"}
  end

  defp user_agent(conn) do
    get_req_header(conn, "user-agent") |> List.first
  end
end
