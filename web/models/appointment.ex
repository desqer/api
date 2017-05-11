defmodule Desqer.Appointment do
  use Desqer.Web, :model

  schema "appointments" do
    belongs_to :user, Desqer.User
    belongs_to :service, Desqer.Service

    field :name, Desqer.Type.String
    field :description, Desqer.Type.String
    field :price, :integer
    field :starts_at, Ecto.DateTime
    field :ends_at, Ecto.DateTime
    field :notes, Desqer.Type.String
    field :status, Desqer.Collection.AppointmentStatus

    field :owned, :boolean, virtual: true

    timestamps()
  end
end
