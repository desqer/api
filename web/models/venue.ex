defmodule Desqer.Venue do
  use Desqer.Web, :model

  schema "venues" do
    has_many :roles, Desqer.Role
    has_many :services, Desqer.Service
    has_many :phones, Desqer.Phone
    has_many :links, Desqer.Link

    field :name, :string
    field :lat, :float
    field :lon, :float
    field :address, :string
    field :deleted, :boolean, default: false

    timestamps()
  end
end
