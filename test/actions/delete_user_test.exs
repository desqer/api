defmodule Desqer.Action.DeleteUserTest do
  use Desqer.ModelCase, async: true

  test "deletes user logically" do
    user = insert(:user)
    {:ok, user} = Desqer.Action.DeleteUser.run(user)

    assert user.deleted
  end
end
