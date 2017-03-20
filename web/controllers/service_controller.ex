defmodule Desqer.ServiceController do
  @moduledoc """
  Endpoints for services.
  """

  use Desqer.Web, :controller

  plug :scrub_params, "service" when action in [:create, :update]
  plug :scrub_params, "professional_ids" when action in [:create]

  @doc """
  List `services`.

  Endpoint example:

      GET /services

  Request headers example:

      authorization: Bearer eyJhbGciOiJIUzUxMiI5c...

  Success response `code 200` example:

      {
        "data": [
          {
            "id": "2050ea22-a273-4bef-93e9-ce9df0e73ddc",
            "professional_id": "9c1c0135-9cb7-41d6-9991-9c8042d31bc8",
            "name": "Haircut",
            "description": "The perfect hair style for your type of face.",
            "price": 4900,
            "duration": 40,
            "in_advance": 1,
            "status": "active",
            "need_approval": false,
            "online_scheduling": true,
            "sunday": [],
            "monday": ["13:00-18:00"],
            "tuesday": ["08:00-12:00", "13:00-18:00"],
            "wednesday": ["08:00-12:00", "13:00-18:00"],
            "thursday": ["08:00-12:00", "13:00-18:00"],
            "friday": ["08:00-12:00"],
            "saturday": [],
            "deleted": false
          }
        ]
      }

  Error response `code 401` example:

      {
        "errors": {
          "detail": "Not authorized"
        }
      }
  """
  def index(conn, params) do
    services = Desqer.Filter.Service.list(current_user(conn), params)

    render(conn, "index.json", services: services)
  end

  @doc """
  Creates `service`.

  Endpoint example:

      POST /services

  Request headers example:

      authorization: Bearer eyJhbGciOiJIUzUxMiI5c...

  Params example:

      {
        "service": {
          "name": "Haircut",
          "description": "The perfect hair style for your type of face.",
          "price": 4900,
          "duration": 40,
          "in_advance": 1,
          "status": "active",
          "need_approval": false,
          "online_scheduling": true,
          "sunday": [],
          "monday": ["13:00-18:00"],
          "tuesday": ["08:00-12:00", "13:00-18:00"],
          "wednesday": ["08:00-12:00", "13:00-18:00"],
          "thursday": ["08:00-12:00", "13:00-18:00"],
          "friday": ["08:00-12:00"],
          "saturday": []
        },
        "professional_ids": [
          "9c1c0135-9cb7-41d6-9991-9c8042d31bc8"
        ]
      }

  Params details:

  - `price` in cents
  - `duration` in minutes
  - `in_advance` in days
  - `status` in [active, paused]

  Success response `code 200` example:

      {
        "data": {
          "services": [
            {
              "id": "2050ea22-a273-4bef-93e9-ce9df0e73ddc",
              "professional_id": "9c1c0135-9cb7-41d6-9991-9c8042d31bc8",
              "name": "Haircut",
              "description": "The perfect hair style for your type of face.",
              "price": 4900,
              "duration": 40,
              "in_advance": 1,
              "status": "active",
              "need_approval": false,
              "online_scheduling": true,
              "sunday": [],
              "monday": ["13:00-18:00"],
              "tuesday": ["08:00-12:00", "13:00-18:00"],
              "wednesday": ["08:00-12:00", "13:00-18:00"],
              "thursday": ["08:00-12:00", "13:00-18:00"],
              "friday": ["08:00-12:00"],
              "saturday": [],
              "deleted": false
            }
          ]
        }
      }

  Error response `code 422` example:

      {
        "errors": {
          "name": ["can't be blank"],
          "description": ["can't be blank"],
          "duration": ["can't be blank"],
          "status": ["can't be blank"]
        }
      }

  Error response `code 401` example:

      {
        "errors": {
          "detail": "Not authorized"
        }
      }
  """
  def create(conn, %{"professional_ids" => professional_ids, "service" => service_params}) do
    case Desqer.Action.CreateService.run(current_user(conn), professional_ids, service_params) do
      {:ok, services} -> render(conn, "show.json", services: Map.values(services))
      {:error, _operation, changeset, _changes} -> render_error(conn, changeset)
    end
  end

  @doc """
  Updates `service`.

  Endpoint example:

      PUT /services/2050ea22-a273-4bef-93e9-ce9df0e73ddc

  Request headers example:

      authorization: Bearer eyJhbGciOiJIUzUxMiI5c...

  Params example:

      {
        "service": {
          "name": "Haircut Reloaded",
          "description": "The hair style made for you.",
          "price": 4500,
          "duration": 50,
          "in_advance": 3,
          "status": "paused",
          "need_approval": true,
          "online_scheduling": true,
          "sunday": [],
          "monday": ["13:00-17:00"],
          "tuesday": ["08:00-12:00", "13:00-17:00"],
          "wednesday": ["08:00-12:00", "13:00-17:00"],
          "thursday": ["08:00-12:00", "13:00-17:00"],
          "friday": ["08:00-12:00"],
          "saturday": []
        }
      }

  Params details:

  - `price` in cents
  - `duration` in minutes
  - `in_advance` in days
  - `status` in [active, paused]

  Success response `code 200` example:

      {
        "data": {
          "service": {
            "id": "2050ea22-a273-4bef-93e9-ce9df0e73ddc",
            "professional_id": "9c1c0135-9cb7-41d6-9991-9c8042d31bc8",
            "name": "Haircut Reloaded",
            "description": "The hair style made for you.",
            "price": 4500,
            "duration": 50,
            "in_advance": 3,
            "status": "paused",
            "need_approval": true,
            "online_scheduling": true,
            "sunday": [],
            "monday": ["13:00-17:00"],
            "tuesday": ["08:00-12:00", "13:00-17:00"],
            "wednesday": ["08:00-12:00", "13:00-17:00"],
            "thursday": ["08:00-12:00", "13:00-17:00"],
            "friday": ["08:00-12:00"],
            "saturday": [],
            "deleted": false
          }
        }
      }

  Error response `code 422` example:

      {
        "errors": {
          "name": ["can't be blank"],
          "description": ["can't be blank"],
          "duration": ["can't be blank"],
          "status": ["can't be blank"]
        }
      }

  Error response `code 401` example:

      {
        "errors": {
          "detail": "Not authorized"
        }
      }
  """
  def update(conn, %{"id" => id, "service" => service_params}) do
    conn
    |> current_user
    |> Desqer.Action.UpdateService.run(id, service_params)
    |> render_response(conn)
  end

  @doc """
  Deletes `service`.

  Endpoint example:

      DELETE /services/2050ea22-a273-4bef-93e9-ce9df0e73ddc

  Request headers example:

      authorization: Bearer eyJhbGciOiJIUzUxMiI5c...

  Success response `code 200` example:

      {
        "data": {
          "service": {
            "id": "2050ea22-a273-4bef-93e9-ce9df0e73ddc",
            "professional_id": "9c1c0135-9cb7-41d6-9991-9c8042d31bc8",
            "name": "Haircut Reloaded",
            "description": "The hair style made for you.",
            "price": 4500,
            "duration": 50,
            "in_advance": 3,
            "status": "paused",
            "need_approval": true,
            "online_scheduling": true,
            "sunday": [],
            "monday": ["13:00-17:00"],
            "tuesday": ["08:00-12:00", "13:00-17:00"],
            "wednesday": ["08:00-12:00", "13:00-17:00"],
            "thursday": ["08:00-12:00", "13:00-17:00"],
            "friday": ["08:00-12:00"],
            "saturday": [],
            "deleted": true
          }
        }
      }

  Error response `code 401` example:

      {
        "errors": {
          "detail": "Not authorized"
        }
      }
  """
  def delete(conn, %{"id" => id}) do
    conn
    |> current_user
    |> Desqer.Action.DeleteService.run(id)
    |> render_response(conn)
  end

  defp render_response(result, conn) do
    case result do
      {:ok, service} -> render(conn, "show.json", service: service)
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
