defmodule Desqer.Link do
  use Desqer.Web, :model

  schema "links" do
    belongs_to :venue, Desqer.Venue

    field :type, Desqer.Collection.LinkType
    field :name, :string
    field :url, :string
    field :deleted, :boolean, default: false

    timestamps()
  end
end
