defmodule Desqer.Action.DeleteServiceTest do
  use Desqer.ModelCase, async: true

  test "raises error when service is not found on user owned venues" do
    role = insert(:role, owner: false)
    service = insert(:service, role: role)

    assert_raise Ecto.NoResultsError, fn ->
      Desqer.Action.DeleteService.run(service.role.user, service.id)
    end
  end

  test "deletes service logically" do
    service = insert(:service)
    {:ok, service} = Desqer.Action.DeleteService.run(service.role.user, service.id)

    assert service.deleted
  end
end
