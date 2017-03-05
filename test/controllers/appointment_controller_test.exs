defmodule Desqer.AppointmentControllerTest do
  use Desqer.ConnCase, async: true

  setup %{conn: conn} do
    session = insert(:session)
    {:ok, jwt, _claims} = Guardian.encode_and_sign(session)

    conn = put_req_header(conn, "accept", "application/json")
    signed_conn = put_req_header(conn, "authorization", "Bearer #{jwt}")

    {:ok, conn: conn, signed_conn: signed_conn, user: session.user}
  end

  test "creates and renders appointments", %{signed_conn: conn, user: user} do
    professional = insert(:professional, user: user)
    service = insert(:service, professional: professional)
    other_user = insert(:user, phone: "5547999871234")

    params = %{service_id: service.id, starts_at: "2017-03-10T14:30:00", ends_at: "2017-03-10T15:20:00"}
    conn = post conn, appointment_path(conn, :create), user_ids: [other_user.id], appointment: params
    data = json_response(conn, 200)["data"]

    assert List.first(data["appointments"])["starts_at"] == params.starts_at
  end

  test "creates and renders appointment", %{signed_conn: conn} do
    other_user = insert(:user, phone: "5547999871234")
    professional = insert(:professional, user: other_user)
    service = insert(:service, professional: professional)

    params = %{service_id: service.id, starts_at: "2017-03-10T14:30:00", ends_at: "2017-03-10T15:20:00"}
    conn = post conn, appointment_path(conn, :create), appointment: params
    data = json_response(conn, 200)["data"]

    assert data["appointment"]["starts_at"] == params.starts_at
  end

  test "renders errors on create appointments when data is invalid", %{signed_conn: conn, user: user} do
    professional = insert(:professional, user: user)
    service = insert(:service, professional: professional)
    other_user = insert(:user, phone: "5547999871234")

    conn = post conn, appointment_path(conn, :create), user_ids: [other_user.id], appointment: %{service_id: service.id}
    errors = json_response(conn, 422)["errors"]

    refute Enum.empty?(errors)
  end

  test "renders errors on create appointment when data is invalid", %{signed_conn: conn} do
    other_user = insert(:user, phone: "5547999871234")
    professional = insert(:professional, user: other_user)
    service = insert(:service, professional: professional)

    conn = post conn, appointment_path(conn, :create), appointment: %{service_id: service.id}
    errors = json_response(conn, 422)["errors"]

    refute Enum.empty?(errors)
  end

  test "updates and renders appointment", %{signed_conn: conn, user: user} do
    other_user = insert(:user, phone: "5547999871234")
    professional = insert(:professional, user: other_user)
    service = insert(:service, professional: professional)
    appointment = insert(:appointment, user: user, service: service)

    params = %{starts_at: "2017-03-10T17:00:00", ends_at: "2017-03-10T18:20:00"}
    conn = put conn, appointment_path(conn, :update, appointment), appointment: params
    data = json_response(conn, 200)["data"]

    assert data["appointment"]["starts_at"] == params.starts_at
  end

  test "renders errors on update when data is invalid", %{signed_conn: conn, user: user} do
    other_user = insert(:user, phone: "5547999871234")
    professional = insert(:professional, user: other_user)
    service = insert(:service, professional: professional)
    appointment = insert(:appointment, user: user, service: service)

    conn = put conn, appointment_path(conn, :update, appointment), appointment: %{status: "foo"}
    errors = json_response(conn, 422)["errors"]

    refute Enum.empty?(errors)
  end
end
