defmodule Desqer.Filter.ProfessionalTest do
  use Desqer.ModelCase, async: true

  test "#by_id" do
    insert(:professional)
    user = insert(:user, name: "Fulano", phone: "5547999871234")
    professional = insert(:professional, user: user)

    result = Desqer.Filter.Professional.by_id(Desqer.Professional, professional.id) |> Desqer.Repo.all

    assert length(result) == 1
    assert List.first(result).user_id == user.id
  end

  test "#by_owner" do
    professional = insert(:professional)
    other_professional = insert(:professional, user: professional.user, venue: professional.venue, owner: false)
    insert(:professional, user: professional.user, owner: false)

    result = Desqer.Filter.Professional.by_owner(Desqer.Professional, professional.user_id) |> Desqer.Repo.all
    result_ids = Enum.map(result, fn (r) -> r.id end)

    assert length(result) == 2
    assert professional.id in result_ids
    assert other_professional.id in result_ids
  end
end
