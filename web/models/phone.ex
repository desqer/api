defmodule Desqer.Phone do
  use Desqer.Web, :model

  schema "phones" do
    belongs_to :venue, Desqer.Venue

    field :type, Desqer.Type.String
    field :value, Desqer.Type.Phone
    field :deleted, :boolean, default: false

    timestamps()
  end
end
