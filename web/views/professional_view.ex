defmodule Desqer.ProfessionalView do
  use Desqer.Web, :view

  def render("show.json", %{user: user, venue: venue, professional: professional}) do
    %{data: %{user: render_one(user, Desqer.UserView, "user.json"),
              venue: render_one(venue, Desqer.VenueView, "venue.json"),
              professional: render_one(professional, Desqer.ProfessionalView, "professional.json")}}
  end

  def render("professional.json", %{professional: professional}) do
    %{id: professional.id,
      role: professional.role,
      owner: professional.owner,
      deleted: professional.deleted}
  end
end
