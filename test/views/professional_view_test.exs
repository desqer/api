defmodule Desqer.ProfessionalViewTest do
  use Desqer.ConnCase, async: true
  import Phoenix.View

  @user_attrs %{
    id: "123",
    name: "John Doe",
    email: "john@doe.com",
    phone: %{full_number: "5547999554433"},
    bio: "An awesome pro",
    professional: true,
    confirmed: true,
    deleted: false
  }

  @venue_attrs %{
    id: "456",
    name: "John's Way",
    lat: -27.216093,
    lon: -49.643502,
    address: "Sete de setembro, 123 - Rio do Sul - SC",
    deleted: false,
    phones: [%{
      id: "789",
      type: "main",
      value: %{full_number: "554735421234"},
      deleted: false}],
    links: [%{
      id: "987",
      type: "website",
      name: nil,
      url: "http://johnsway.com",
      deleted: false}]
  }

  @professional_attrs %{
    id: "789",
    role: "Hair slicer",
    owner: true,
    deleted: false
  }

  test "renders show.json" do
    user = struct(Desqer.User, @user_attrs)
    user_data = %{@user_attrs | phone: @user_attrs.phone.full_number}
    venue = struct(Desqer.Venue, @venue_attrs)
    venue_phone = List.first(@venue_attrs.phones)
    venue_phone_data = %{venue_phone | value: venue_phone.value.full_number}
    venue_data = %{@venue_attrs | phones: [venue_phone_data]}
    professional = struct(Desqer.Professional, @professional_attrs)

    assert render(Desqer.ProfessionalView, "show.json", user: user, venue: venue, professional: professional) ==
           %{data: %{user: user_data, venue: venue_data, professional: @professional_attrs}}
  end
end
