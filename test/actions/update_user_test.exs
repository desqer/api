defmodule Desqer.Action.UpdateUserTest do
  use Desqer.ModelCase, async: true

  test "raises error when resource does not exist" do
    assert_raise Ecto.NoResultsError, fn ->
      Desqer.Action.UpdateUser.run("6610856f-23e6-499d-b7fd-eeba168a756b", %{})
    end
  end

  test "returns error when current_password is absent" do
    user = insert(:user)
    {:error, changeset} = Desqer.Action.UpdateUser.run(user.id, %{})

    assert {:current_password, {"can't be blank", [validation: :required]}} in changeset.errors
    refute changeset.valid?
  end

  test "returns error when password is too short" do
    user = insert(:user)
    {:error, changeset} = Desqer.Action.UpdateUser.run(user.id, %{password: "123"})

    assert {:password, {"should be at least %{count} character(s)", [count: 6, validation: :length, min: 6]}} in changeset.errors
    refute changeset.valid?
  end

  test "returns error when email is invalid" do
    user = insert(:user)
    {:error, changeset} = Desqer.Action.UpdateUser.run(user.id, %{email: "johndoe.com"})

    assert {:email, {"has invalid format", [validation: :format]}} in changeset.errors
    refute changeset.valid?
  end

  test "lowercases email" do
    user = insert(:user)
    {:error, changeset} = Desqer.Action.UpdateUser.run(user.id, %{email: "JOHN@DOE.COM"})

    assert {:email, "john@doe.com"} in changeset.changes
  end

  test "puts password hash" do
    user = insert(:user)
    {:error, changeset} = Desqer.Action.UpdateUser.run(user.id, %{password: "foobar"})

    assert String.length(changeset.changes[:password_hash]) == 60
  end

  test "returns error when phone is taked" do
    insert(:user, phone: "9991234")
    user = insert(:user)
    {:error, changeset} = Desqer.Action.UpdateUser.run(user.id, %{current_password: "1234", phone: "9991234"})

    assert {:phone, {"has already been taken", []}} in changeset.errors
    refute changeset.valid?
  end

  test "updates user" do
    params = %{
      current_password: "1234",
      phone: "9991234",
      password: "654321",
      name: "Johnny Doe",
      email: "johnny@doe.com",
      bio: "Adorable person",
      professional: false
    }
    user = insert(:user)
    {:ok, user} = Desqer.Action.UpdateUser.run(user.id, params)

    assert user.phone == params.phone
    assert user.name == params.name
    assert user.email == params.email
    assert user.bio == params.bio
    assert user.professional == params.professional
    assert Desqer.Password.check("654321", user)
  end
end
