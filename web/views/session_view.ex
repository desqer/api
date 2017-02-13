defmodule Desqer.SessionView do
  use Desqer.Web, :view

  def render("show.json", %{user: user, jwt: jwt, exp: exp}) do
    %{data: render_one(user, Desqer.UserView, "user.json"),
      jwt: jwt,
      exp: exp}
  end
end
