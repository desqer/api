defmodule Desqer.Link do
  use Desqer.Web, :model

  schema "links" do
    belongs_to :venue, Desqer.Venue

    field :type, Desqer.Collection.LinkType
    field :name, Desqer.Type.String
    field :url, Desqer.Type.String
    field :deleted, :boolean, default: false

    timestamps()
  end
end
