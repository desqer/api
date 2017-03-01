defmodule Desqer.UserControllerTest do
  use Desqer.ConnCase, async: true

  setup %{conn: conn} do
    session = insert(:session)
    {:ok, jwt, _claims} = Guardian.encode_and_sign(session)

    conn = put_req_header(conn, "accept", "application/json")
    signed_conn = put_req_header(conn, "authorization", "Bearer #{jwt}")

    {:ok, conn: conn, signed_conn: signed_conn, user: session.user}
  end

  test "previews user", %{conn: conn, user: user} do
    conn = get conn, user_path(conn, :preview, "5547999874321")
    data = json_response(conn, 200)["data"]

    assert data["user"]["name"] == user.name
  end

  test "renders not found when user does not exist", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_path(conn, :preview, "5547999871234")
    end
  end

  test "shows user", %{signed_conn: conn, user: user} do
    conn = get conn, user_path(conn, :show)
    data = json_response(conn, 200)["data"]

    assert data["user"]["id"] == user.id
  end

  test "creates and renders user", %{conn: conn} do
    user_params = %{name: "Johnny Doe", phone: "5547999554321", password: "123456"}
    conn = post conn, user_path(conn, :create), user: user_params
    data = json_response(conn, 200)["data"]

    assert data["user"]["phone"] == user_params.phone
  end

  test "renders errors on create when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: %{}
    errors = json_response(conn, 422)["errors"]

    refute Enum.empty?(errors)
  end

  test "updates and renders user", %{signed_conn: conn, user: user} do
    conn = put conn, user_path(conn, :update), user: %{current_password: "1234", phone: "5547999551234"}
    data = json_response(conn, 200)["data"]

    assert data["user"]["id"] == user.id
    assert data["user"]["phone"] == "5547999551234"
  end

  test "renders errors on update when data is invalid", %{signed_conn: conn} do
    conn = put conn, user_path(conn, :update), user: %{}
    errors = json_response(conn, 422)["errors"]

    refute Enum.empty?(errors)
  end

  test "deletes and renders user", %{signed_conn: conn, user: user} do
    conn = delete conn, user_path(conn, :delete)
    data = json_response(conn, 200)["data"]

    assert data["user"]["id"] == user.id
    assert data["user"]["deleted"] == true
  end
end
