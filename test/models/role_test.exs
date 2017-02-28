defmodule Desqer.RoleTest do
  use Desqer.ModelCase, async: true

  test "#by_id" do
    insert(:role)
    user = insert(:user, name: "Fulano", phone: "5547999871234")
    role = insert(:role, user: user)

    result = Desqer.Role.by_id(Desqer.Role, role.id) |> Desqer.Repo.all

    assert length(result) == 1
    assert List.first(result).user_id == user.id
  end

  test "#by_owner" do
    role = insert(:role)
    other_role = insert(:role, user: role.user, venue: role.venue, owner: false)
    insert(:role, user: role.user, owner: false)

    result = Desqer.Role.by_owner(Desqer.Role, role.user_id) |> Desqer.Repo.all
    result_ids = Enum.map(result, fn (r) -> r.id end)

    assert length(result) == 2
    assert role.id in result_ids
    assert other_role.id in result_ids
  end
end
