defmodule Desqer.SessionControllerTest do
  use Desqer.ConnCase, async: true

  setup %{conn: conn} do
    session = insert(:session)
    {:ok, jwt, _claims} = Guardian.encode_and_sign(session)

    conn = put_req_header(conn, "accept", "application/json")
    signed_conn = put_req_header(conn, "authorization", "Bearer #{jwt}")

    {:ok, conn: conn, signed_conn: signed_conn, user: session.user}
  end

  test "creates session", %{conn: conn} do
    user_params = %{phone: "5547999874321", password: "1234"}
    conn = post conn, session_path(conn, :create), user: user_params
    jwt = json_response(conn, 200)["jwt"]
    data = json_response(conn, 200)["data"]

    assert ["Bearer " <> ^jwt] = get_resp_header(conn, "authorization")
    assert data["phone"] == user_params.phone
  end

  test "renders errors on create when data is invalid", %{conn: conn} do
    conn = post conn, session_path(conn, :create), user: %{}
    errors = json_response(conn, 422)["errors"]

    refute Enum.empty?(errors)
  end

  test "deletes session", %{signed_conn: conn} do
    conn = delete conn, session_path(conn, :delete)
    detail = json_response(conn, 200)["detail"]

    assert detail == "Logged out"
  end
end
