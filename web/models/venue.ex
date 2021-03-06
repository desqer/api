defmodule Desqer.Venue do
  use Desqer.Web, :model

  schema "venues" do
    has_many :professionals, Desqer.Professional
    has_many :phones, Desqer.Phone
    has_many :links, Desqer.Link

    has_many :services, through: [:professionals, :services]

    field :name, Desqer.Type.String
    field :lat, :float
    field :lon, :float
    field :address, Desqer.Type.String
    field :deleted, :boolean, default: false

    timestamps()
  end
end
