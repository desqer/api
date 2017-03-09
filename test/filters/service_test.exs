defmodule Desqer.Filter.ServiceTest do
  use Desqer.ModelCase, async: true

  test "lists services" do
    service = insert(:service)

    result = Desqer.Filter.Service.list(service.professional.user, %{})
    result_ids = Enum.map(result, fn (r) -> r.id end)

    assert length(result) == 1
    assert service.id in result_ids
  end

  test "#by_professional" do
    professional = insert(:professional, user: build(:user, phone: "554799871234"))
    other_professional = insert(:professional, venue: professional.venue)
    service = insert(:service, professional: professional)
    insert(:service, professional: other_professional)

    result = Desqer.Filter.Service.by_professional(Desqer.Service, service.professional.user_id) |> Desqer.Repo.all
    result_ids = Enum.map(result, fn (r) -> r.id end)

    assert length(result) == 1
    assert service.id in result_ids
  end

  test "#by_venue_owner" do
    professional = insert(:professional)
    other_professional = insert(:professional, user: professional.user, venue: professional.venue, owner: false)
    invalid_professional = insert(:professional, user: professional.user, owner: false)
    service = insert(:service, professional: professional)
    other_service = insert(:service, professional: other_professional)
    insert(:service, professional: invalid_professional)

    result = Desqer.Filter.Service.by_venue_owner(Desqer.Service, service.professional.user_id) |> Desqer.Repo.all
    result_ids = Enum.map(result, fn (r) -> r.id end)

    assert length(result) == 2
    assert service.id in result_ids
    assert other_service.id in result_ids
  end
end
