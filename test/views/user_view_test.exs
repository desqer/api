defmodule Desqer.UserViewTest do
  use Desqer.ConnCase, async: true
  import Phoenix.View

  @valid_attrs %{
    id: "123",
    name: "John Doe",
    email: "john@doe.com",
    phone: %{full_number: "5547999554433"},
    bio: "An awesome pro",
    professional: true,
    confirmed: true,
    deleted: false
  }

  test "renders show.json" do
    user = struct(Desqer.User, @valid_attrs)
    data = %{@valid_attrs | phone: @valid_attrs.phone.full_number}

    assert render(Desqer.UserView, "show.json", user: user) == %{data: data}
  end
end
