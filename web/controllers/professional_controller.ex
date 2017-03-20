defmodule Desqer.ProfessionalController do
  @moduledoc """
  Endpoints for professionals.
  """

  use Desqer.Web, :controller

  plug :scrub_params, "user" when action in [:create]
  plug :scrub_params, "venue" when action in [:create]

  @doc """
  Creates `professional`.

  Endpoint example:

      POST /professionals

  Request headers example:

      authorization: Bearer eyJhbGciOiJIUzUxMiI5c...

  Params example:

      {
        "user": {
          "email": "john@doe.com",
          "bio": "An awesome professional"
        },
        "venue": {
          "name": "John's Way",
          "lat": "-27.216093",
          "lon": "-49.643502",
          "address": "Sete de setembro, 123 - Rio do Sul - SC",
          "phone": "554735421234",
          "website": "http://johnsway.com"
        }
      }

  Success response `code 200` example:

      {
        "data": {
          "user": {
            "id": "2050ea22-a273-4bef-93e9-ce9df0e73ddc",
            "name": "John Doe",
            "phone": "55479995874321",
            "email": "john@doe.com",
            "bio": "An awesome professional",
            "professional": true,
            "confirmed": false,
            "deleted": false
          },
          "venue": {
            "id": "32fce658-4df6-415f-8355-ded35085ad3e",
            "name": "John's Way",
            "lat": -27.216093,
            "lon": -49.643502,
            "address": "Sete de setembro, 123 - Rio do Sul - SC",
            "phones": [{
              "id": "bf3adb47-df19-4eb3-90b7-36538518a5e5",
              "type": "main",
              "value": "554735421234",
              "deleted": false
            }],
            "links": [{
              "id": "fd3d939e-7b85-4f20-87a3-251942ca3619",
              "type": "website",
              "name": null,
              "url": "http://johnsway.com",
              "deleted": false
            }],
            "deleted": false
          },
          "professional": {
            "id": "9df526b4-dba8-4064-8c72-b22934ecdffc",
            "role": "Hair stylist",
            "owner": true,
            "deleted": "false"
          }
        }
      }

  Error response `code 422` example:

      {
        "errors": {
          "professional": ["has already been set up"]
        }
      }

  Error response `code 401` example:

      {
        "errors": {
          "detail": "Not authorized"
        }
      }
  """
  def create(conn, %{"user" => user_params, "venue" => venue_params}) do
    case Desqer.Action.CreateProfessional.run(current_user(conn), user_params, venue_params) do
      {:ok, %{user: user, venue: venue, professional: professional}} ->
        render(conn, "show.json", user: user, venue: venue, professional: professional)
      {:error, _operation, changeset, _changes} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Desqer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  defp current_user(conn) do
    Guardian.Plug.current_resource(conn).user
  end
end
