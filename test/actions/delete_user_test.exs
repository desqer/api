defmodule Desqer.Action.DeleteUserTest do
  use Desqer.ModelCase, async: true

  test "raises error when user does not exist" do
    assert_raise Ecto.NoResultsError, fn ->
      Desqer.Action.DeleteUser.run("6610856f-23e6-499d-b7fd-eeba168a756b")
    end
  end

  test "deletes user logically" do
    user = insert(:user)
    {:ok, user} = Desqer.Action.DeleteUser.run(user.id)

    assert user.deleted
  end
end
