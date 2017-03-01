defmodule Desqer.UserView do
  use Desqer.Web, :view

  def render("preview.json", %{user: user}) do
    %{data: %{user: %{name: user.name, phone: user.phone.full_number}}}
  end

  def render("show.json", %{user: user}) do
    %{data: %{user: render_one(user, Desqer.UserView, "user.json")}}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone.full_number,
      bio: user.bio,
      professional: user.professional,
      confirmed: user.confirmed,
      deleted: user.deleted}
  end
end
