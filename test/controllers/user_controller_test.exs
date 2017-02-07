defmodule Desqer.UserControllerTest do
  use Desqer.ConnCase, async: true

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "shows user", %{conn: conn} do
    user = insert(:user)
    conn = get conn, user_path(conn, :show, user)
    data = json_response(conn, 200)["data"]

    assert data["id"] == user.id
  end

  test "renders not found when user does not exist", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "creates and renders user", %{conn: conn} do
    user_params = %{name: "Johnny Doe", phone: "5547999554321", password: "123456"}
    conn = post conn, user_path(conn, :create), user: user_params
    data = json_response(conn, 200)["data"]

    assert data["phone"] == user_params.phone
  end

  test "renders errors on create when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: %{}
    errors = json_response(conn, 422)["errors"]

    refute Enum.empty?(errors)
  end

  test "updates and renders user", %{conn: conn} do
    user = insert(:user)
    conn = put conn, user_path(conn, :update, user), user: %{current_password: "1234", phone: "5547999551234"}
    data = json_response(conn, 200)["data"]

    assert data["id"] == user.id
    assert data["phone"] == "5547999551234"
  end

  test "renders errors on update when data is invalid", %{conn: conn} do
    user = insert(:user)
    conn = put conn, user_path(conn, :update, user), user: %{}
    errors = json_response(conn, 422)["errors"]

    refute Enum.empty?(errors)
  end

  test "deletes and renders user", %{conn: conn} do
    user = insert(:user)
    conn = delete conn, user_path(conn, :delete, user)
    data = json_response(conn, 200)["data"]

    assert data["id"] == user.id
    assert data["deleted"] == true
  end
end