defmodule Desqer.UserController do
  @moduledoc """
  Always returns `user` data. Example:

      {
        "data": {
          "id": "6610856f-23e6-499d-b7fd-eeba168a756b",
          "phone": "5547999553565",
          "name": "John",
          "email": "john@doe.com",
          "professional": true,
          "bio": "An awesome teacher",
          "confirmed": true,
          "deleted": false
        }
      }
  """
  use Desqer.Web, :controller

  plug :scrub_params, "user" when action in [:create, :update]

  @doc """
  Fetches `user`.

  Expects `user id`. Example:

      GET /users/6610856f-23e6-499d-b7fd-eeba168a756b
  """
  def show(conn, %{"id" => id}) do
    user = Desqer.Repo.get!(Desqer.User, id)
    render(conn, "show.json", user: user)
  end

  @doc """
  Creates `user`.

  Expects `user key` with params. Example:

      POST /users

      {
        "user": {
          "name": "John",
          "phone": "5547999553565",
          "password": "foo123"
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

  Expects `user id` and `user key` with params. Example:

      PUT /users/6610856f-23e6-499d-b7fd-eeba168a756b

      {
        "user": {
          "name": "Jane",
          "phone": "5547999443464",
          "password": "bar456",
          "current_password": "foo123"
        }
      }
  """
  def update(conn, %{"id" => id, "user" => user_params}) do
    id
    |> Desqer.Action.UpdateUser.run(user_params)
    |> render_response(conn)
  end

  @doc """
  Deletes `user`.

  Expects `user id`. Example:

      DELETE /users/6610856f-23e6-499d-b7fd-eeba168a756b
  """
  def delete(conn, %{"id" => id}) do
    id
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
end
