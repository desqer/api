defmodule Desqer.Venue do
  use Desqer.Web, :model

  schema "venues" do
    has_many :roles, Desqer.Role
    has_many :phones, Desqer.Phone
    has_many :links, Desqer.Link

    field :name, :string
    field :lat, :float
    field :lon, :float
    field :street, :string
    field :number, :string
    field :complement, :string
    field :neighborhood, :string
    field :city, :string
    field :state, :string
    field :country, :string
    field :zip_code, :string
    field :deleted, :boolean, default: false

    timestamps()
  end
end
