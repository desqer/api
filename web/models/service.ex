defmodule Desqer.Service do
  use Desqer.Web, :model

  schema "services" do
    belongs_to :venue, Desqer.Venue

    has_many :assignments, Desqer.Assignment

    field :name, :string
    field :description, :string
    field :price, :integer
    field :duration, :integer
    field :status, Desqer.Collection.ServiceStatus
    field :need_approval, :boolean, default: false
    field :online_scheduling, :boolean, default: false
    field :deleted, :boolean, default: false

    timestamps()
  end
end
