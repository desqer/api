defmodule Desqer.Action.UpdateUserTest do
  use Desqer.ModelCase, async: true

  test "returns error when current_password is absent" do
    user = insert(:user)
    {:error, changeset} = Desqer.Action.UpdateUser.run(user, %{})

    assert {:current_password, {"can't be blank", [validation: :required]}} in changeset.errors
    refute changeset.valid?
  end

  test "returns error when password is too short" do
    user = insert(:user)
    {:error, changeset} = Desqer.Action.UpdateUser.run(user, %{password: "123"})

    assert {:password, {"should be at least %{count} character(s)", [count: 6, validation: :length, min: 6]}} in changeset.errors
    refute changeset.valid?
  end

  test "returns error when email is invalid" do
    user = insert(:user)
    {:error, changeset} = Desqer.Action.UpdateUser.run(user, %{email: "johndoe.com"})

    assert {:email, {"has invalid format", [validation: :format]}} in changeset.errors
    refute changeset.valid?
  end

  test "lowercases email" do
    user = insert(:user)
    {:error, changeset} = Desqer.Action.UpdateUser.run(user, %{email: "JOHN@DOE.COM"})

    assert {:email, "john@doe.com"} in changeset.changes
  end

  test "puts password hash" do
    user = insert(:user)
    {:error, changeset} = Desqer.Action.UpdateUser.run(user, %{password: "foobar"})

    assert String.length(changeset.changes[:password_hash]) == 60
  end

  test "returns error when phone is taked" do
    insert(:user, phone: "5547999551234")
    user = insert(:user)
    {:error, changeset} = Desqer.Action.UpdateUser.run(user, %{current_password: "1234", phone: "5547999551234"})

    assert {:phone, {"has already been taken", []}} in changeset.errors
    refute changeset.valid?
  end

  test "updates user" do
    user = insert(:user)
    params = %{
      name: "Johnny Doe",
      phone: "5547999551234",
      email: "johnny@doe.com",
      password: "654321",
      current_password: "1234"
    }

    {:ok, user} = Desqer.Action.UpdateUser.run(user, params)

    assert user.phone.full_number == params.phone
    assert user.name == params.name
    assert user.email == params.email
    assert Desqer.Password.check("654321", user.password_hash)
  end
end
