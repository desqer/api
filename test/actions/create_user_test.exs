defmodule Desqer.Action.CreateUserTest do
  use Desqer.ModelCase, async: true

  test "returns error when name, phone, password are absent" do
    {:error, changeset} = Desqer.Action.CreateUser.run(%{})

    assert {:name, {"can't be blank", [validation: :required]}} in changeset.errors
    assert {:phone, {"can't be blank", [validation: :required]}} in changeset.errors
    assert {:password, {"can't be blank", [validation: :required]}} in changeset.errors

    refute changeset.valid?
  end

  test "returns error when password is too short" do
    {:error, changeset} = Desqer.Action.CreateUser.run(%{password: "123"})

    assert {:password, {"should be at least %{count} character(s)", [count: 6, validation: :length, min: 6]}} in changeset.errors
    refute changeset.valid?
  end

  test "puts password hash" do
    {:error, changeset} = Desqer.Action.CreateUser.run(%{password: "foobar"})

    assert String.length(changeset.changes[:password_hash]) == 60
  end

  test "returns error when phone is taked" do
    insert(:user, phone: "5547999551234")
    {:error, changeset} = Desqer.Action.CreateUser.run(%{name: "Johnny Doe", phone: "5547999551234", password: "654321"})

    assert {:phone, {"has already been taken", []}} in changeset.errors
    refute changeset.valid?
  end

  test "creates user" do
    params = %{
      name: "Johnny Doe",
      phone: "5547999551234",
      password: "654321"
    }

    {:ok, user} = Desqer.Action.CreateUser.run(params)

    assert user.name == params.name
    assert user.phone.full_number == params.phone
    assert Desqer.Password.check("654321", user.password_hash)

    refute user.professional
    refute user.confirmed
    refute user.deleted
  end
end
