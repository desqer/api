defmodule Desqer.SessionController do
  @moduledoc """
  Endpoints for sessions.
  """
  use Desqer.Web, :controller

  plug :scrub_params, "user" when action in [:create]

  @doc """
  Signs in `user`.

  Endpoint example:

      POST /sessions

  Params example:

      {
        "user": {
          "phone": "+55 47 99987-4321",
          "password": "foo123"
        }
      }

  Success response `code 200` example:

      {
        "jwt": "eyJhbGciOiJIUzUxMiI5c...",
        "exp": 1489573943,
        "data": {
          "id": "2050ea22-a273-4bef-93e9-ce9df0e73ddc",
          "name": "John Doe",
          "phone": "55479995874321",
          "email": "john@doe.com",
          "bio": "An awesome professional"
          "professional": true,
          "confirmed": true,
          "deleted": false,
        }
      }

  Error response `code 422` example:

      {
        "errors": {
          "phone": ["can't be blank"],
          "password": ["can't be blank"]
        }
      }
  """
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

  @doc """
  Signs out `user`.

  Endpoint example:

      DELETE /sessions

  Request headers example:

      authorization: Bearer eyJhbGciOiJIUzUxMiI5c...


  Success response `code 200` example:

      {
        "detail": "Logged out"
      }

  Error response `code 401` example:

      {
        "errors": {
          "detail": "Resource not authorized"
        }
      }
  """
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
