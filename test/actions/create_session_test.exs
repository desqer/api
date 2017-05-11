defmodule Desqer.Action.CreateSessionTest do
  use Desqer.ModelCase, async: true

  @valid_attrs %{
    "phone" => "5547999874321",
    "password" => "1234"
  }

  test "returns error when phone, password are absent" do
    {:error, changeset} = Desqer.Action.CreateSession.run(%{"phone" => "", "password" => ""}, nil, nil)

    assert {:phone, {"can't be blank", [validation: :required]}} in changeset.errors
    assert {:password, {"can't be blank", [validation: :required]}} in changeset.errors
    refute changeset.valid?
  end

  test "returns error when user does not exist" do
    {:error, changeset} = Desqer.Action.CreateSession.run(@valid_attrs, nil, nil)

    assert {:user, {"not authorized", []}} in changeset.errors
    refute changeset.valid?
  end

  test "returns error when password is incorrect" do
    insert(:user)

    {:error, changeset} = Desqer.Action.CreateSession.run(%{@valid_attrs | "password" => "4321"}, nil, nil)

    assert {:password, {"not authorized", []}} in changeset.errors
    refute changeset.valid?
  end

  test "creates session" do
    user = insert(:user)

    {:ok, session_user, jwt, exp} = Desqer.Action.CreateSession.run(@valid_attrs, "Mozilla/5.0 (Macintosh)", {172, 68, 29, 248})
    {:ok, claims} = Guardian.decode_and_verify(jwt)

    assert session_user == user
    assert claims["exp"] == exp
  end
end
