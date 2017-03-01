defmodule Desqer.UserController do
  @moduledoc """
  Endpoints for users.
  """

  use Desqer.Web, :controller

  plug :scrub_params, "user" when action in [:create, :update]

  @doc """
  Previews `user`.

  Endpoint example:

      GET /users/5547999874321

  Success response `code 200` example:

      {
        "data": {
          "user": {
            "name": "John Doe",
            "phone": "55479995874321"
          }
        }
      }

  Error response `code 404` example:

      {
        "errors": {
          "detail": "Resource not found"
        }
      }
  """
  def preview(conn, %{"phone" => phone}) do
    user = Desqer.User |> Desqer.Repo.get_by!(phone: phone)
    render(conn, "preview.json", user: user)
  end

  @doc """
  Shows `user`.

  Endpoint example:

      GET /users

  Request headers example:

      authorization: Bearer eyJhbGciOiJIUzUxMiI5c...

  Success response `code 200` example:

      {
        "data": {
          "user": {
            "id": "2050ea22-a273-4bef-93e9-ce9df0e73ddc",
            "name": "John Doe",
            "phone": "55479995874321",
            "email": "john@doe.com",
            "bio": "An awesome professional"
            "professional": true,
            "confirmed": true,
            "deleted": false
          }
        }
      }

  Error response `code 401` example:

      {
        "errors": {
          "detail": "Resource not authorized"
        }
      }
  """
  def show(conn, _params) do
    user = current_user(conn)
    render(conn, "show.json", user: user)
  end

  @doc """
  Creates `user`.

  Endpoint example:

      POST /users

  Params example:

      {
        "user": {
          "name": "John Doe",
          "phone": "5547999874321",
          "password": "foo123"
        }
      }

  Success response `code 200` example:

      {
        "data": {
          "user": {
            "id": "2050ea22-a273-4bef-93e9-ce9df0e73ddc",
            "name": "John Doe",
            "phone": "55479995874321",
            "email": null,
            "bio": null,
            "professional": false,
            "confirmed": false,
            "deleted": false
          }
        }
      }

  Error response `code 422` example:

      {
        "errors": {
          "phone": ["has already been taken"],
          "password": ["can't be blank"]
        }
      }
  """
  def create(conn, %{"user" => user_params}) do
    user_params
    |> Desqer.Action.CreateUser.run
    |> render_response(conn)
  end

  @doc """
  Updates `user`.

  Endpoint example:

      PUT /users

  Request headers example:

      authorization: Bearer eyJhbGciOiJIUzUxMiI5c...

  Params example:

      {
        "user": {
          "name": "Jane Doe",
          "phone": "5547999871234",
          "email": "jane@doe.com",
          "password": "bar456",
          "current_password": "foo123"
        }
      }

  Success response `code 200` example:

      {
        "data": {
          "user": {
            "id": "2050ea22-a273-4bef-93e9-ce9df0e73ddc",
            "name": "Jane Doe",
            "phone": "55479995871234",
            "email": "jane@doe.com",
            "bio": "An awesome professional",
            "professional": true,
            "confirmed": false,
            "deleted": false
          }
        }
      }

  Error response `code 422` example:

      {
        "errors": {
          "phone": ["has already been taken"],
          "current_password": ["can't be blank"]
        }
      }

  Error response `code 401` example:

      {
        "errors": {
          "detail": "Resource not authorized"
        }
      }
  """
  def update(conn, %{"user" => user_params}) do
    conn
    |> current_user
    |> Desqer.Action.UpdateUser.run(user_params)
    |> render_response(conn)
  end

  @doc """
  Deletes `user`.

  Endpoint example:

      DELETE /users

  Request headers example:

      authorization: Bearer eyJhbGciOiJIUzUxMiI5c...

  Success response `code 200` example:

      {
        "data": {
          "user": {
            "id": "2050ea22-a273-4bef-93e9-ce9df0e73ddc",
            "name": "Jane Doe",
            "phone": "55479995871234",
            "email": "jane@doe.com",
            "bio": "An awesome professional",
            "professional": true,
            "confirmed": false,
            "deleted": true
          }
        }
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
    |> current_user
    |> Desqer.Action.DeleteUser.run
    |> render_response(conn)
  end

  defp render_response(result, conn) do
    case result do
      {:ok, user} -> render(conn, "show.json", user: user)
      {:error, changeset} -> render_error(conn, changeset)
    end
  end

  defp render_error(conn, changeset) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(Desqer.ChangesetView, "error.json", changeset: changeset)
  end

  defp current_user(conn) do
    Guardian.Plug.current_resource(conn).user
  end
end
