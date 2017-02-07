defmodule Desqer.UserView do
  use Desqer.Web, :view

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Desqer.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      bio: user.bio,
      professional: user.professional,
      confirmed: user.confirmed,
      deleted: user.deleted}
  end
end
