defmodule Desqer.Action.DeleteServiceTest do
  use Desqer.ModelCase, async: true

  test "raises error when service is not found on user owned venues" do
    professional = insert(:professional, owner: false)
    service = insert(:service, professional: professional)

    assert_raise Ecto.NoResultsError, fn ->
      Desqer.Action.DeleteService.run(service.professional.user, service.id)
    end
  end

  test "deletes service logically" do
    service = insert(:service)
    {:ok, service} = Desqer.Action.DeleteService.run(service.professional.user, service.id)

    assert service.deleted
  end
end
