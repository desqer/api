defmodule Desqer.Filter.UserTest do
  use Desqer.ModelCase, async: true

  test "#get when phone is invalid" do
    assert {:error, %Ecto.Changeset{}} = Desqer.Filter.User.get("123")
  end

  test "#get" do
    user = insert(:user, phone: "5547999871234")
    insert(:user, phone: "554798761235")

    {:ok, result} = Desqer.Filter.User.get("5547999871234")

    assert result.id == user.id
  end
end
