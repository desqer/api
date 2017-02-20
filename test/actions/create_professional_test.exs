defmodule Desqer.Action.CreateProfessionalTest do
  use Desqer.ModelCase, async: true

  test "returns error when already is a professional" do
    user = insert(:user)
    {:error, _, changeset, _} = Desqer.Action.CreateProfessional.run(user, %{}, %{})

    assert {:professional, {"has already been set up", []}} in changeset.errors
    refute changeset.valid?
  end

  test "lowercases email" do
    user = insert(:user)
    {:error, _, changeset, _} = Desqer.Action.CreateProfessional.run(user, %{email: "JOHN@DOE.COM"}, %{})

    assert {:email, "john@doe.com"} in changeset.changes
  end

  test "creates professional" do
    user = insert(:user, professional: false)

    user_params = %{
      "email" => "john@doe.com",
      "bio" => "An awesome professional"
    }
    venue_params = %{
      "name" => "John's Way",
      "lat" => -27.216093,
      "lon" => -49.643502,
      "address" => "Sete de setembro, 123 - Rio do Sul - SC",
      "phone" => "554735421234",
      "website" => "http://johnsway.com"
    }

    {:ok, %{user: user, venue: venue, role: role}} = Desqer.Action.CreateProfessional.run(user, user_params, venue_params)

    [%{value: %{full_number: phone}, type: "main"}] = venue.phones
    [%{url: website, type: :website}] = venue.links

    assert venue.name == venue_params["name"]
    assert venue.lat == venue_params["lat"]
    assert venue.lon == venue_params["lon"]
    assert venue.address == venue_params["address"]
    assert phone == venue_params["phone"]
    assert website == venue_params["website"]
    assert user.email == user_params["email"]
    assert user.bio == user_params["bio"]
    assert user.professional
    assert role.owner
  end
end
