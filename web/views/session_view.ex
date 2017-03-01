defmodule Desqer.SessionView do
  use Desqer.Web, :view

  def render("show.json", %{user: user, jwt: jwt, exp: exp}) do
    %{jwt: jwt,
      exp: exp,
      data: %{user: render_one(user, Desqer.UserView, "user.json")}}
  end
end
