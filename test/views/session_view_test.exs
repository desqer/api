defmodule Desqer.SessionViewTest do
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

  test "renders show.json" do
    user = struct(Desqer.User, @user_attrs)
    data = %{@user_attrs | phone: @user_attrs.phone.full_number}

    assert render(Desqer.SessionView, "show.json", user: user, jwt: "123", exp: 456) ==
           %{data: data, jwt: "123", exp: 456}
  end
end
