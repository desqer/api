defmodule Desqer.GuardianHandlerTest do
  use Desqer.ConnCase, async: true

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "renders errors on unauthenticated", %{conn: conn} do
    conn = Desqer.GuardianHandler.unauthenticated(conn, %{})
    errors = json_response(conn, 401)["errors"]

    assert errors["detail"] == "Resource not authorized"
  end

  test "renders errors on no_resource", %{conn: conn} do
    conn = Desqer.GuardianHandler.no_resource(conn, %{})
    errors = json_response(conn, 401)["errors"]

    assert errors["detail"] == "Resource not authorized"
  end
end
