defmodule Desqer.Professional do
  use Desqer.Web, :model

  schema "professionals" do
    belongs_to :user, Desqer.User
    belongs_to :venue, Desqer.Venue

    has_many :services, Desqer.Service

    field :role, :string
    field :owner, :boolean, default: false
    field :deleted, :boolean, default: false

    timestamps()
  end
end
