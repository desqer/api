defmodule Desqer.ServiceControllerTest do
  use Desqer.ConnCase, async: true

  setup %{conn: conn} do
    session = insert(:session)
    {:ok, jwt, _claims} = Guardian.encode_and_sign(session)

    conn = put_req_header(conn, "accept", "application/json")
    signed_conn = put_req_header(conn, "authorization", "Bearer #{jwt}")

    {:ok, conn: conn, signed_conn: signed_conn, user: session.user}
  end

  test "creates and renders services", %{signed_conn: conn, user: user} do
    professional = insert(:professional, user: user)
    params = %{name: "Haircut", description: "Best haircut in the world", duration: 30, status: "active"}
    conn = post conn, service_path(conn, :create), professional_ids: [professional.id], service: params
    data = json_response(conn, 200)["data"]

    assert List.first(data["services"])["name"] == params.name
  end

  test "renders errors on create when data is invalid", %{signed_conn: conn, user: user} do
    professional = insert(:professional, user: user)
    conn = post conn, service_path(conn, :create), professional_ids: [professional.id], service: %{}
    errors = json_response(conn, 422)["errors"]

    refute Enum.empty?(errors)
  end

  test "updates and renders service", %{signed_conn: conn, user: user} do
    professional = insert(:professional, user: user)
    service = insert(:service, professional: professional)
    params = %{name: "Haircut Reloaded"}
    conn = put conn, service_path(conn, :update, service), service: params
    data = json_response(conn, 200)["data"]

    assert data["service"]["id"] == service.id
    assert data["service"]["name"] == params.name
  end

  test "renders errors on update when data is invalid", %{signed_conn: conn, user: user} do
    professional = insert(:professional, user: user)
    service = insert(:service, professional: professional)
    conn = put conn, service_path(conn, :update, service), service: %{status: "foo"}
    errors = json_response(conn, 422)["errors"]

    refute Enum.empty?(errors)
  end

  test "deletes and renders user", %{signed_conn: conn, user: user} do
    professional = insert(:professional, user: user)
    service = insert(:service, professional: professional)
    conn = delete conn, service_path(conn, :delete, service)
    data = json_response(conn, 200)["data"]

    assert data["service"]["id"] == service.id
    assert data["service"]["deleted"] == true
  end
end
