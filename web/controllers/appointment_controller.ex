defmodule Desqer.AppointmentController do
  @moduledoc """
  Endpoints for appointments.
  """

  use Desqer.Web, :controller

  plug :scrub_params, "appointment" when action in [:create, :update]

  @doc """
  Creates `appointments` by professional.

  Endpoint example:

      POST /appointments

  Request headers example:

      authorization: Bearer eyJhbGciOiJIUzUxMiI5c...

  Params example:

      {
        "appointment": {
          "service_id": "80e9863b-61bc-45be-9f0e-9aebfb2dcec6",
          "name": "Haircut",
          "description": "The perfect hair style for your type of face",
          "price": 4900,
          "starts_at": "2017-03-10 15:30:00",
          "ends_at": "2017-03-10 16:00:00",
          "notes": "Hair massage bonus"
        },
        "user_ids": [
          "69f06156-7fc2-4c7f-abde-fc20204627e1"
        ]
      }

  Params details:

  - `price` in cents

  Success response `code 200` example:

      {
        "data": {
          "appointments": [
            {
              "id": "2050ea22-a273-4bef-93e9-ce9df0e73ddc",
              "user_id": "69f06156-7fc2-4c7f-abde-fc20204627e1",
              "service_id": "9c1c0135-9cb7-41d6-9991-9c8042d31bc8",
              "name": "Haircut",
              "description": "The perfect hair style for your type of face",
              "price": 4900,
              "starts_at": "2017-03-10T15:30:00",
              "ends_at": "2017-03-10T16:00:00",
              "notes": "Hair massage bonus",
              "status": "active"
            }
          ]
        }
      }

  Error response `code 422` example:

      {
        "errors": {
          "starts_at": ["can't be blank"],
          "ends_at": ["can't be blank"]
        }
      }

  Error response `code 401` example:

      {
        "errors": {
          "detail": "Resource not authorized"
        }
      }
  """
  def create(conn, %{"user_ids" => user_ids, "appointment" => appointment_params}) do
    case Desqer.Action.CreateAppointmentByProfessional.run(current_user(conn), user_ids, appointment_params) do
      {:ok, appointments} -> render(conn, "show.json", appointments: Map.values(appointments))
      {:error, _operation, changeset, _changes} -> render_error(conn, changeset)
    end
  end

  @doc """
  Creates `appointment`.

  Endpoint example:

      POST /appointments

  Request headers example:

      authorization: Bearer eyJhbGciOiJIUzUxMiI5c...

  Params example:

      {
        "appointment": {
          "service_id": "80e9863b-61bc-45be-9f0e-9aebfb2dcec6",
          "starts_at": "2017-03-10 15:30:00",
          "ends_at": "2017-03-10 16:00:00",
          "notes": "Hair massage needed"
        }
      }

  Params details:

  - `price` in cents

  Success response `code 200` example:

      {
        "data": {
          "appointment": {
            "id": "2050ea22-a273-4bef-93e9-ce9df0e73ddc",
            "user_id": "69f06156-7fc2-4c7f-abde-fc20204627e1",
            "service_id": "9c1c0135-9cb7-41d6-9991-9c8042d31bc8",
            "name": "Haircut",
            "description": "The perfect hair style for your type of face",
            "price": 4900,
            "starts_at": "2017-03-10T15:30:00",
            "ends_at": "2017-03-10T16:00:00",
            "notes": "Hair massage needed",
            "status": "active"
          }
        }
      }

  Error response `code 422` example:

      {
        "errors": {
          "starts_at": ["can't be blank"],
          "ends_at": ["can't be blank"]
        }
      }

  Error response `code 401` example:

      {
        "errors": {
          "detail": "Resource not authorized"
        }
      }
  """
  def create(conn, %{"appointment" => appointment_params}) do
    case Desqer.Action.CreateAppointment.run(current_user(conn), appointment_params) do
      {:ok, appointment} -> render(conn, "show.json", appointment: appointment)
      {:error, changeset} -> render_error(conn, changeset)
    end
  end

  @doc """
  Updates `appointment`.

  Endpoint example:

      PUT /appointments/2050ea22-a273-4bef-93e9-ce9df0e73ddc

  Request headers example:

      authorization: Bearer eyJhbGciOiJIUzUxMiI5c...

  Params example:

      {
        "appointment": {
          "starts_at": "2017-03-09 13:00",
          "ends_at": "2017-03-09 13:30",
          "notes": "Hair massage bonus and others",
          "status": "canceled"
        }
      }

  Params details:

  - `status` in [active, canceled]

  Success response `code 200` example:

      {
        "data": {
          "appointment": {
            "id": "2050ea22-a273-4bef-93e9-ce9df0e73ddc",
            "user_id": "69f06156-7fc2-4c7f-abde-fc20204627e1",
            "service_id": "9c1c0135-9cb7-41d6-9991-9c8042d31bc8",
            "name": "Haircut",
            "description": "The perfect hair style for your type of face",
            "price": 4900,
            "starts_at": "2017-03-09 13:00",
            "ends_at": "2017-03-09 13:30",
            "notes": "Hair massage bonus and others",
            "status": "canceled"
          }
        }
      }

  Error response `code 422` example:

      {
        "errors": {
          "status": ["is invalid"]
        }
      }

  Error response `code 401` example:

      {
        "errors": {
          "detail": "Resource not authorized"
        }
      }
  """
  def update(conn, %{"id" => id, "appointment" => appointment_params}) do
    case Desqer.Action.UpdateAppointment.run(current_user(conn), id, appointment_params) do
      {:ok, appointment} -> render(conn, "show.json", appointment: appointment)
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
