defmodule Desqer.Service do
  use Desqer.Web, :model

  schema "services" do
    belongs_to :professional, Desqer.Professional

    field :name, Desqer.Type.String
    field :description, Desqer.Type.String
    field :price, :integer
    field :duration, :integer
    field :in_advance, :integer
    field :sunday, Desqer.Type.Hours
    field :monday, Desqer.Type.Hours
    field :tuesday, Desqer.Type.Hours
    field :wednesday, Desqer.Type.Hours
    field :thursday, Desqer.Type.Hours
    field :friday, Desqer.Type.Hours
    field :saturday, Desqer.Type.Hours
    field :status, Desqer.Collection.ServiceStatus
    field :need_approval, :boolean, default: false
    field :online_scheduling, :boolean, default: true
    field :deleted, :boolean, default: false

    timestamps()
  end
end
