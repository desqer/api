defmodule Desqer.ServiceTest do
  use Desqer.ModelCase, async: true

  test "#by_role" do
    role = insert(:role, user: build(:user, phone: "554799871234"))
    other_role = insert(:role, venue: role.venue)
    service = insert(:service, role: role)
    insert(:service, role: other_role)

    result = Desqer.Service.by_role(Desqer.Service, service.role.user_id) |> Desqer.Repo.all
    result_ids = Enum.map(result, fn (r) -> r.id end)

    assert length(result) == 1
    assert service.id in result_ids
  end

  test "#by_venue_owner" do
    role = insert(:role)
    other_role = insert(:role, user: role.user, venue: role.venue, owner: false)
    invalid_role = insert(:role, user: role.user, owner: false)
    service = insert(:service, role: role)
    other_service = insert(:service, role: other_role)
    insert(:service, role: invalid_role)

    result = Desqer.Service.by_venue_owner(Desqer.Service, service.role.user_id) |> Desqer.Repo.all
    result_ids = Enum.map(result, fn (r) -> r.id end)

    assert length(result) == 2
    assert service.id in result_ids
    assert other_service.id in result_ids
  end
end
