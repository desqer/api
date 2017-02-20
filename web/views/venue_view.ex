defmodule Desqer.VenueView do
  use Desqer.Web, :view

  def render("venue.json", %{venue: venue}) do
    %{id: venue.id,
      name: venue.name,
      lat: venue.lat,
      lon: venue.lon,
      address: venue.address,
      phones: render_many(venue.phones, Desqer.PhoneView, "phone.json"),
      links: render_many(venue.links, Desqer.LinkView, "link.json"),
      deleted: venue.deleted}
  end
end
