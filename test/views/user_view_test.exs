defmodule Desqer.UserViewTest do
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

  test "renders preview.json" do
    user = struct(Desqer.User, @user_attrs)
    data = %{name: user.name, phone: user.phone.full_number}

    assert render(Desqer.UserView, "preview.json", user: user) == %{data: data}
  end

  test "renders show.json" do
    user = struct(Desqer.User, @user_attrs)
    data = %{@user_attrs | phone: @user_attrs.phone.full_number}

    assert render(Desqer.UserView, "show.json", user: user) == %{data: data}
  end
end
