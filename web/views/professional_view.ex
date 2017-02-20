defmodule Desqer.ProfessionalView do
  use Desqer.Web, :view

  def render("show.json", %{user: user, venue: venue}) do
    %{data: %{user: render_one(user, Desqer.UserView, "user.json"),
              venue: render_one(venue, Desqer.VenueView, "venue.json")}}
  end
end
