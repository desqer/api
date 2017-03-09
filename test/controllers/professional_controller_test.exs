defmodule Desqer.ProfessionalControllerTest do
  use Desqer.ConnCase, async: true

  setup %{conn: conn} do
    session = insert(:session)
    {:ok, jwt, _claims} = Guardian.encode_and_sign(session)

    conn = put_req_header(conn, "accept", "application/json")
    signed_conn = put_req_header(conn, "authorization", "Bearer #{jwt}")

    {:ok, conn: conn, signed_conn: signed_conn, user: session.user}
  end

  test "creates professional and renders user and venue", %{signed_conn: conn, user: user} do
    Desqer.Repo.update change(user, professional: false)

    user_params = %{
      email: "john@doe.com",
      bio: "An awesome professional"
    }
    venue_params = %{
      name: "John's Way",
      lat: -27.216093,
      lon: -49.643502,
      address: "Sete de setembro, 123 - Rio do Sul - SC",
      phone: "554735421234",
      website: "http://johnsway.com"
    }

    conn = post conn, professional_path(conn, :create), user: user_params, venue: venue_params
    data = json_response(conn, 200)["data"]

    refute Enum.empty?(data["user"])
    refute Enum.empty?(data["venue"])
    refute Enum.empty?(data["professional"])
  end

  test "renders errors on create when data is invalid", %{signed_conn: conn} do
    conn = post conn, professional_path(conn, :create), user: %{}, venue: %{}
    errors = json_response(conn, 422)["errors"]

    refute Enum.empty?(errors)
  end
end
